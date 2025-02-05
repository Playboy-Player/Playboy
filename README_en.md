# Playboy Player

[中文](./README.md) | English

A Material 3 style cross-platform media player.

[![build](https://img.shields.io/github/actions/workflow/status/Playboy-Player/Playboy/build.yml?style=for-the-badge)](https://github.com/Playboy-Player/Playboy/actions) 
[![release](https://img.shields.io/badge/beta-2025.2-blue?style=for-the-badge)](https://github.com/Playboy-Player/Playboy/actions) [![roadmap](https://img.shields.io/badge/loadmap-grey?style=for-the-badge)](https://github.com/orgs/Playboy-Player/projects/3)

![](https://m3-markdown-badges.vercel.app/stars/7/2/Playboy-Player/Playboy)
![](https://m3-markdown-badges.vercel.app/issues/1/2/Playboy-Player/Playboy)  
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Windows/windows3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Linux/linux3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/macOS/macos3.svg)
![](https://ziadoua.github.io/m3-Markdown-Badges/badges/Android/android3.svg)

## Screenshots

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

## Features

- [x] Theme & Dark mode Support
- [x] Open local media and network streaming
- [x] Mini mode (Windows & macOS)
- [x] Set as the system default app (Windows)
- [x] Playlist features
- [x] Playback speed
- [x] Search playlist and media
- [ ] Internationalization Support
- [ ] Lyrics and subtitles
- [ ] Play media on local devices.
- [ ] File download

## For Developer

### Windows 

Requires installation of [Flutter](https://docs.flutter.dev/get-started/install/windows/desktop?tab=vscode) and [Visual Studio 2022](https://visualstudio.microsoft.com/zh-hans/downloads/) with C++ workload (or install [VS 2022 Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)).

Example output of `flutter doctor`:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.24.1, on Microsoft Windows [Version 10.0.22631.4037], locale zh-CN)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Visual Studio - develop Windows apps (Visual Studio Build Tools 2022 17.11.1)
[✓] Connected device (3 available)
[✓] Network resources
```

Run `flutter build windows` in the project folder to generate the Windows executable.

### Linux

> The current Linux version has some bugs, such as crashes when switching pages during playback and incorrect mini player display size.

Requires installation of [Flutter](https://docs.flutter.dev/get-started/install/linux) and `libmpv-dev`.

Example output of `flutter doctor`:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.22.2, on Debian GNU/Linux 12 (bookworm) 5.15.153.1-microsoft-standard-WSL2, locale
    en_US.UTF-8)
[✓] Linux toolchain - develop for Linux desktop
[✓] Connected device (1 available)
[✓] Network resources 
```

Run `flutter build linux` in the project folder to generate the Linux executable.

### macOS

Example output of `flutter doctor`:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.27.2, on macOS 15.2 24C101 darwin-arm64, locale
    zh-Hans-CN)
[!] Xcode - develop for iOS and macOS (Xcode 16.2)
    ✗ Unable to get list of installed Simulator runtimes.
[✓] VS Code (version 1.96.4)
[✓] Connected device (3 available)
[✓] Network resources
```

iOS SDK is not necessary.

### Android

> Please run on tablet devices

Example output of `flutter doctor`:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.24.1, on Microsoft Windows [Version 10.0.22631.4169], locale zh-CN)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Android Studio (version 2024.2)
[✓] Connected device (3 available)
[✓] Network resources
```

## Contributing to the Project

If you encounter bugs or would like to request features, please [create a new issue](https://github.com/Playboy-Player/Playboy/issues/new).  
Contributions via Pull Requests are also welcome.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Playboy-Player/Playboy&type=Date)](https://star-history.com/#Playboy-Player/Playboy&Date)