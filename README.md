# 模拟电子技术 · 第一节课预习课件

单文件 HTML 课件，部署到 GitHub Pages 给学生访问。

## 本地预览

双击 `index.html` 即可在浏览器打开。

## 部署到 GitHub Pages

详见根目录的 `一键发布指南.md`，或者直接运行 `deploy.ps1`。

## 修改内容

- 内容全部在 `index.html` 里，直接用文本编辑器（VS Code）打开编辑
- 改完保存，在项目目录跑 `git add . && git commit -m "update" && git push` 即可重新发布

## 目录结构

```
.
├── index.html        # 主课件（部署到 GitHub Pages 用）
├── preview.html      # 同上，备用副本
├── README.md         # 本文件
├── 一键发布指南.md    # 部署步骤详细说明
└── deploy.ps1        # 一键部署脚本（Windows PowerShell）
```