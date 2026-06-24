import { mkdir, copyFile } from "node:fs/promises";

await mkdir("dist", { recursive: true });

await Promise.all([
  copyFile("index.html", "dist/index.html"),
  copyFile("books.json", "dist/books.json"),
  copyFile(".nojekyll", "dist/.nojekyll")
]);

console.log("Static site copied to dist/");
