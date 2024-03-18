# Playboy

使用 [Flutter](https://flutter.dev/) 开发的媒体播放器, 界面使用 [Material You](https://m3.material.io/) 设计风格.

<img src="https://m3-markdown-badges.vercel.app/stars/7/2/Playboy-Player/Playboy">
<img src="https://m3-markdown-badges.vercel.app/issues/1/2/Playboy-Player/Playboy">

![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Windows/windows3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Linux/linux3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/macOS/macos3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Android/android3.svg)

## 界面截图

<table>
  <tr>
    <td>
      <img src='./screenshots/screenshot4.png'>
    </td>
    <td>
      <img src='./screenshots/screenshot1.png'>
    </td>
  </tr>
  <tr>
    <td>
      <img src='./screenshots/screenshot5.png'>
    </td>
    <td>
      <img src='./screenshots/screenshot2.png'>
    </td>
  </tr>
  <tr>
    <td>
      <img src='./screenshots/screenshot6.png'>
    </td>
    <td>
      <img src='./screenshots/screenshot3.png'>
    </td>
  </tr>
</table>

## 功能 & 开发进度

- [x] 主题颜色自定义
- [x] 深色模式支持
- [ ] 多语言支持
- [x] 播放本地和媒体文件.
- [x] 设置为系统打开方式
- [x] 播放列表 (随机播放, 单曲循环)
- [x] 任意倍速调节 (0-4倍速)
- [ ] 编辑媒体文件.
- [ ] 歌词支持
- [ ] 视频字幕
- [x] 解析BV链接.
- [ ] 文件下载功能.
- [x] 便携版 (Windows)
- [ ] 移动端 (android) 支持
- [ ] 跨桌面端支持 (Windows, Linux, macOS)

## 使用说明

音乐库与视频库按文件夹扫描媒体项, 将文件夹中的 `cover.jpg` 设为媒体项的封面.  
仅扫描与文件夹同名且格式支持的媒体文件, 同名不同扩展名的文件仅会扫描一个.

支持格式: `avi`, `flv`, `mkv`, `mov`, `mp4`, `mpeg`, `webm`, `wmv`, `aac`, `midi`, `mp3`, `ogg`, `wav`

例如, 以下目录会被扫描为一个媒体项

```
Last Resort/Last Resort.mp4
           /cover.jpg
```

## 开发环境

### Windows

需要安装 [Flutter](https://docs.flutter.dev/get-started/install/windows/desktop?tab=vscode), [Visual Studio 2022](https://visualstudio.microsoft.com/zh-hans/downloads/) C++ 工作负载 (或安装 [VS 2022 生成工具](https://aka.ms/vs/17/release/vs_BuildTools.exe))

flutter doctor 输出内容示例:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.19.3, on Microsoft Windows [版本 10.0.22631.3296], locale zh-CN)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Chrome - develop for the web
[✓] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.9.2)
[✓] Android Studio (version 2023.1)
[✓] Connected device (3 available)
[✓] Network resources
```

在项目文件夹下运行 `flutter build windows` 以生成 Windows 可执行程序

### Linux

> 目前 Linux 版本 UI 存在 Bug

需要安装 [Flutter](https://docs.flutter.dev/get-started/install/linux), libmpv.

在项目文件夹下运行 `flutter build linux` 以生成 Linux 可执行程序

### macOS

> 计划中

### android

> 计划中

## 为本项目做出贡献

如果您在使用中发现 bug 或者希望添加某些功能, 请 [新建一个 issue](https://github.com/Playboy-Player/Playboy/issues/new).  
也欢迎直接 Pull Request 提交代码贡献.

## 致谢

[media-kit](https://github.com/media-kit/media-kit)

[dio](https://github.com/cfug/dio)

[bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)

[pilipala](https://github.com/guozhigq/pilipala)