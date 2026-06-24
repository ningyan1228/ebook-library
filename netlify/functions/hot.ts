import type { Config, Context } from "@netlify/functions";
import { getStore } from "@netlify/blobs";

type BookStat = {
  clicks: number;
  lastClickedAt: string;
};

const jsonHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
  "Content-Type": "application/json; charset=utf-8"
};

function json(data: unknown, init: ResponseInit = {}) {
  return new Response(JSON.stringify(data), {
    ...init,
    headers: {
      ...jsonHeaders,
      ...(init.headers || {})
    }
  });
}

function getBookIdFromRequest(req: Request) {
  return req.json()
    .then((body) => String(body?.id || "").trim())
    .catch(() => "");
}

export default async (req: Request, context: Context) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: jsonHeaders });
  }

  const store = getStore({ name: "book-hot-rank", consistency: "strong" });
  const path = new URL(req.url).pathname;

  if (path === "/api/rank" && req.method === "GET") {
    const limit = Math.min(Math.max(Number(new URL(req.url).searchParams.get("limit") || 12), 1), 50);
    const { blobs } = await store.list({ prefix: "book/" });
    const ranking = [];

    for (const blob of blobs) {
      const stat = await store.get(blob.key, { type: "json" }) as BookStat | null;
      if (!stat) continue;

      ranking.push({
        id: blob.key.replace(/^book\//, ""),
        clicks: Number(stat.clicks || 0),
        lastClickedAt: stat.lastClickedAt || ""
      });
    }

    ranking.sort((a, b) => (b.clicks - a.clicks) || a.id.localeCompare(b.id));
    return json({ ranking: ranking.slice(0, limit) });
  }

  if (path === "/api/click" && req.method === "POST") {
    const id = await getBookIdFromRequest(req);
    if (!/^[A-Za-z0-9_-]{1,80}$/.test(id)) {
      return json({ error: "Invalid book id" }, { status: 400 });
    }

    const key = `book/${id}`;
    const current = await store.get(key, { type: "json" }) as BookStat | null;
    const next = {
      clicks: Number(current?.clicks || 0) + 1,
      lastClickedAt: new Date().toISOString()
    };

    await store.setJSON(key, next);
    return json({ ok: true, id, clicks: next.clicks });
  }

  return json({ error: "Not found" }, { status: 404 });
};

export const config: Config = {
  path: ["/api/rank", "/api/click"]
};
