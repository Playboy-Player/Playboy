# Playboy Player
中文 | [English](./README_en.md)  

基于 libmpv 的 Material 3 风格跨平台媒体播放器.

[![build](https://img.shields.io/github/actions/workflow/status/Playboy-Player/Playboy/build.yml?style=for-the-badge)](https://github.com/Playboy-Player/Playboy/actions) 
[![release](https://img.shields.io/badge/beta-2025.2-blue?style=for-the-badge)](https://github.com/Playboy-Player/Playboy/releases) [![roadmap](https://img.shields.io/badge/roadmap-grey?style=for-the-badge)](https://github.com/orgs/Playboy-Player/projects/3)

![](https://m3-markdown-badges.vercel.app/stars/7/2/Playboy-Player/Playboy)
![](https://m3-markdown-badges.vercel.app/issues/1/2/Playboy-Player/Playboy)  
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Windows/windows3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Linux/linux3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/macOS/macos3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Android/android3.svg)

## 界面截图

<table>
  <tr>
    <td>
      <img src='./screenshots/screenshot4.png' alt="playing">
    </td>
    <td>
      <img src='./screenshots/screenshot1.png' alt="playing dark">
    </td>
  </tr>
  <tr>
    <td>
      <img src='./screenshots/screenshot5.png' alt="video page">
    </td>
    <td>
      <img src='./screenshots/screenshot2.png' alt="video page dark">
    </td>
  </tr>
  <tr>
    <td>
      <img src='./screenshots/screenshot6.png' alt="music page">
    </td>
    <td>
      <img src='./screenshots/screenshot3.png' alt="music page dark">
    </td>
  </tr>
</table>

## 功能

- [x] 自定义主题 & 深色模式
- [x] 播放本地和网络媒体
- [x] 迷你播放器模式 (Windows & macOS)
- [x] 设置为系统打开方式 (Windows)
- [x] 播放列表功能 (随机播放, 单曲循环)
- [x] 任意倍速调节
- [x] 搜索媒体文件和播放列表
- [x] 多语言支持
- [ ] 字幕 (libass)
- [ ] 着色器支持, 如 [Anime4K](https://github.com/bloc97/Anime4K)
- [ ] 自定义快捷键映射
- [ ] 自定义 mpv 初始化参数 & 命令

## For Developers

首先, 根据 [官方教程](https://docs.flutter.dev/get-started/install/) 配置 flutter 环境. 请使用不低于 **3.29.0** 的 flutter 版本.

终端进入项目根目录, 运行 `flutter pub get` 以获取依赖项.

### Windows

运行 `flutter build windows` 以生成 Windows 可执行程序

### Linux

> 目前 Linux 版本存在较多 Bug, 如播放时切换页面可能导致应用崩溃, 迷你播放器显示尺寸错误等

配置完 flutter 后, 请通过系统包管理器或其他途径安装 `libmpv-dev`.

运行 `flutter build linux` 以生成 Linux 可执行程序

### macOS

运行 `flutter build macos` 以生成 macOS 可执行程序  

### android

> 请在平板设备上运行.

运行 `flutter build apk` 以生成 apk 安装包文件

## 为本项目做出贡献

如果您在使用中发现 bug 或者希望添加某些功能, 请 [新建一个 issue](https://github.com/Playboy-Player/Playboy/issues/new).  
也欢迎直接 Pull Request 提交代码贡献.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Playboy-Player/Playboy&type=Date)](https://star-history.com/#Playboy-Player/Playboy&Date)