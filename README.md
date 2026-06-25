# 电子书下载站

这是一个静态电子书索引网站：书籍信息写在 `books.json`，页面读取 JSON 后提供搜索、筛选和网盘跳转。

## 免责声明

本站仅用于个人资料整理与检索展示，页面中出现的电子书信息和网盘链接均来自第三方分享或用户自行整理。

本站不存储、不上传、不复制、不分发任何电子书文件，也不提供版权规避、破解、盗版传播或商业下载服务。所有书籍、封面、书名、作者信息及相关内容的版权归原作者、出版社及合法权利人所有。

请访问者自觉遵守所在地区的法律法规，仅在合法授权、合理使用、公版作品或个人已购资源备份等范围内使用相关链接，并支持正版阅读。

如相关权利人认为本站展示的链接或信息侵犯了您的合法权益，请联系站点维护者并提供权属证明。核实后将尽快删除或更正相关内容。

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

请只收录你拥有分享权、已获授权或已经进入公版范围的资源链接。免责声明不能替代授权，也不能使未授权资源合法化。
