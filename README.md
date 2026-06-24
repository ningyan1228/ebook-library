# 电子书下载站

这是一个静态电子书索引网站：书籍信息写在 `books.json`，页面读取 JSON 后提供搜索、筛选和网盘跳转。

## 数据格式

在 `books.json` 的 `books` 数组里追加记录：

```json
{
  "id": "unique-book-id",
  "title": "书名",
  "authors": ["作者 1", "作者 2"],
  "publisher": "出版社",
  "year": "2024",
  "category": "分类",
  "tags": ["标签 1", "标签 2"],
  "format": "PDF",
  "language": "中文",
  "description": "简介",
  "cloudProvider": "百度网盘",
  "url": "https://pan.baidu.com/s/xxxxx",
  "extractionCode": "abcd",
  "size": "25 MB",
  "accessNote": "可选备注"
}
```

## 本地预览

因为浏览器直接打开 `index.html` 时可能禁止读取本地 JSON，建议在当前目录启动静态服务器：

```powershell
python -m http.server 8080
```

然后访问：

```text
http://localhost:8080
```

## 上线方式

可以部署到 Netlify、GitHub Pages、EdgeOne Pages 或任意静态网站空间。上线时把 `index.html` 和 `books.json` 放在同一目录即可。

## 合规提醒

请只收录你拥有分享权、已获授权或公版书籍的网盘链接。本站只做链接索引，不托管电子书文件。
