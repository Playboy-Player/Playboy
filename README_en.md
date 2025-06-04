# Playboy

[中文](./README.md) | English

A `libmpv` based media player with Material 3 design.

[![build](https://img.shields.io/github/actions/workflow/status/Playboy-Player/Playboy/build.yml?style=for-the-badge)](https://github.com/Playboy-Player/Playboy/actions)
[![release](https://img.shields.io/badge/beta-2025.4-gold?style=for-the-badge)](https://github.com/Playboy-Player/Playboy/releases) ![downloads](https://img.shields.io/github/downloads/Playboy-Player/Playboy/total?style=for-the-badge&color=blue) [![project](https://img.shields.io/badge/project-grey?style=for-the-badge)](https://github.com/orgs/Playboy-Player/projects/3)

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
      <img src='./screenshots/screenshot1.png' alt="equalizer">
    </td>
    <td>
      <img src='./screenshots/screenshot2.png' alt="theme">
    </td>
  </tr>
  <tr>
    <td>
      <img src='./screenshots/screenshot3.png' alt="shaders">
    </td>
    <td>
      <img src='./screenshots/screenshot4.png' alt="library">
    </td>
  </tr>
</table>

## Features

You can access all mpv functions using [keyboard shortcuts](https://github.com/mpv-player/random-stuff/blob/master/key_bindings_chart/mpbindings.png). Press `SHIFT+O` while playing to display the mpv OSD interface.

- [X] Custom themes & dark mode
- [X] Play local and online media
- [X] Mini player mode (Windows & macOS)
- [X] Set as system default media player (Windows)
- [X] Playlist support (shuffle, repeat one)
- [X] Chapters and AB loop (via command line)
- [X] Adjustable playback speed
- [X] Media file and playlist search
- [X] Multi-language support
- [X] Subtitles (libass)
- [X] Shader support, such as [Anime4K](https://github.com/bloc97/Anime4K)
- [X] Custom key mapping (input.conf support)
- [X] Compatible with `mpv.conf` configuration files
- [X] Subtitle generation using Whisper
- [ ] LLM-enhanced video analysis(Switch to llm branch to have early access to some new features)

## For Developers

First, set up the Flutter environment according to the [official guide](https://docs.flutter.dev/get-started/install/). Please use Flutter version **3.29.0** or higher.

Then run `flutter pub get` and `dart run whisper4dart:setup --prebuilt` to get necessary dependencies.

### Windows

Before building the application, run `libmpv_dart:setup --platform windows` to get libmpv dependencies.

Run `flutter build windows` in the project directory to generate the Windows executable.

### Linux

After setting up Flutter, install `libmpv-dev` via your system package manager or other means.

Run `flutter build linux` in the project directory to generate the Linux executable.

### macOS

Run `flutter build macos` in the project directory to generate the macOS executable.

### Android

> Please run on tablet devices.

Run `flutter build apk` to generate the APK installation file.

## Contributing to This Project

If you find a bug or want to suggest a feature, please [create a new issue](https://github.com/Playboy-Player/Playboy/issues/new).
Pull requests with code contributions are also welcome.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Playboy-Player/Playboy&type=Date)](https://star-history.com/#Playboy-Player/Playboy&Date)
