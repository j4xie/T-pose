# 图标乱码问题修复指南

## 问题描述

在多个页面上，Font Awesome图标显示为乱码字符，如`"□?"`或`"性◊?"`等。这是由于以下可能的原因造成的：

1. CDN资源加载不稳定 - Font Awesome图标库从CDN加载可能不稳定或被阻断
2. 字符编码问题 - 浏览器解析Unicode图标时出现编码错误
3. 字体资源缺失 - 系统中缺少特定的图标字体

## 解决方案

我们提供了以下几种解决方案，按照推荐程度排序：

### 方案1：使用更稳定的CDN和备用加载方式

将现有的Font Awesome引用：
```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
```

替换为：
```html
<!-- Font Awesome - 更新为更稳定的版本 -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v6.4.0/css/all.css" crossorigin="anonymous">
<!-- 备用加载方式 -->
<script defer src="https://use.fontawesome.com/releases/v6.4.0/js/all.js" crossorigin="anonymous"></script>
```

### 方案2：使用备用图标显示方案

我们创建了一个备用图标CSS文件（`assets/css/icon-fix.css`），它使用标准Unicode字符作为图标的替代方案。

在页面中添加：
```html
<link rel="stylesheet" href="../assets/css/icon-fix.css">
```

并为每个图标添加备用显示元素：
```html
<i class="fas fa-users"></i>
<span class="icon-users icon-fallback"></span>
```

### 方案3：本地托管Font Awesome（推荐长期方案）

1. 下载完整的Font Awesome库
2. 将CSS和字体文件放入项目中（如`assets/fonts/fontawesome`）
3. 使用本地引用替代CDN引用

```html
<link rel="stylesheet" href="../assets/fonts/fontawesome/css/all.min.css">
```

## 实施步骤

1. 首先在一个页面上测试方案1（已在table-map-A.html实施）
2. 如果问题仍然存在，在同一页面测试方案2（也已在table-map-A.html实施）
3. 如果上述两种方案都不能完全解决问题，实施方案3

## 注意事项

- 确保所有HTML文件都使用`UTF-8`编码（已确认）
- 检查所有页面的字体引用路径是否正确（注意相对路径）
- 对于生产环境，推荐使用方案3（本地托管），以减少对外部资源的依赖

## 已修改的文件

- `assets/css/icon-fix.css` - 新创建的图标备用方案CSS
- `page/table-map-A.html` - 已实施方案1和方案2的测试页面
- `page/index.html` - 已实施方案1 