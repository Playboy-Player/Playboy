// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Playlists`
  String get playlist {
    return Intl.message(
      'Playlists',
      name: 'playlist',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Scan Options`
  String get scanOptions {
    return Intl.message(
      'Scan Options',
      name: 'scanOptions',
      desc: '',
      args: [],
    );
  }

  /// `Rescan Video and Music Libraries`
  String get rescanMediaLibraries {
    return Intl.message(
      'Rescan Video and Music Libraries',
      name: 'rescanMediaLibraries',
      desc: '',
      args: [],
    );
  }

  /// `Rescan Video Library`
  String get rescanVideoLibrary {
    return Intl.message(
      'Rescan Video Library',
      name: 'rescanVideoLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Rescan Music Library`
  String get rescanMusicLibrary {
    return Intl.message(
      'Rescan Music Library',
      name: 'rescanMusicLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Library Settings`
  String get pathSettings {
    return Intl.message(
      'Library Settings',
      name: 'pathSettings',
      desc: '',
      args: [],
    );
  }

  /// `Music Folders`
  String get musicFolder {
    return Intl.message(
      'Music Folders',
      name: 'musicFolder',
      desc: '',
      args: [],
    );
  }

  /// `Video Folders`
  String get videoFolder {
    return Intl.message(
      'Video Folders',
      name: 'videoFolder',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Screenshot Folder`
  String get screenshotFolder {
    return Intl.message(
      'Screenshot Folder',
      name: 'screenshotFolder',
      desc: '',
      args: [],
    );
  }

  /// `Download Folder`
  String get downloadFolder {
    return Intl.message(
      'Download Folder',
      name: 'downloadFolder',
      desc: '',
      args: [],
    );
  }

  /// `App Data`
  String get appData {
    return Intl.message(
      'App Data',
      name: 'appData',
      desc: '',
      args: [],
    );
  }

  /// `Open App Data Folder`
  String get openAppDataFolder {
    return Intl.message(
      'Open App Data Folder',
      name: 'openAppDataFolder',
      desc: '',
      args: [],
    );
  }

  /// `Restore Default Settings`
  String get restoreDefaultSettings {
    return Intl.message(
      'Restore Default Settings',
      name: 'restoreDefaultSettings',
      desc: '',
      args: [],
    );
  }

  /// `Irreversible, takes effect after restart`
  String get irreversibleWarning {
    return Intl.message(
      'Irreversible, takes effect after restart',
      name: 'irreversibleWarning',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Player`
  String get player {
    return Intl.message(
      'Player',
      name: 'player',
      desc: '',
      args: [],
    );
  }

  /// `Storage`
  String get storage {
    return Intl.message(
      'Storage',
      name: 'storage',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Player Settings`
  String get playSettings {
    return Intl.message(
      'Player Settings',
      name: 'playSettings',
      desc: '',
      args: [],
    );
  }

  /// `Auto Play`
  String get autoPlayVideo {
    return Intl.message(
      'Auto Play',
      name: 'autoPlayVideo',
      desc: '',
      args: [],
    );
  }

  /// `Auto Download`
  String get autoDownloadVideo {
    return Intl.message(
      'Auto Download',
      name: 'autoDownloadVideo',
      desc: '',
      args: [],
    );
  }

  /// `Default Music Mode`
  String get defaultMusicView {
    return Intl.message(
      'Default Music Mode',
      name: 'defaultMusicView',
      desc: '',
      args: [],
    );
  }

  /// `Remember Player State`
  String get rememberPlayerStatus {
    return Intl.message(
      'Remember Player State',
      name: 'rememberPlayerStatus',
      desc: '',
      args: [],
    );
  }

  /// `Volume and Speed`
  String get volumeAndSpeed {
    return Intl.message(
      'Volume and Speed',
      name: 'volumeAndSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Continue Playing After Exit`
  String get playInAppBackground {
    return Intl.message(
      'Continue Playing After Exit',
      name: 'playInAppBackground',
      desc: '',
      args: [],
    );
  }

  /// `Use Media Control Card to Stop`
  String get useMediaControlToStop {
    return Intl.message(
      'Use Media Control Card to Stop',
      name: 'useMediaControlToStop',
      desc: '',
      args: [],
    );
  }

  /// `MPV Settings (WIP)`
  String get mpvSettings {
    return Intl.message(
      'MPV Settings (WIP)',
      name: 'mpvSettings',
      desc: '',
      args: [],
    );
  }

  /// `Display Language`
  String get displayLanguage {
    return Intl.message(
      'Display Language',
      name: 'displayLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Simplified Chinese`
  String get simplifiedChinese {
    return Intl.message(
      'Simplified Chinese',
      name: 'simplifiedChinese',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `UI Settings`
  String get uiSettings {
    return Intl.message(
      'UI Settings',
      name: 'uiSettings',
      desc: '',
      args: [],
    );
  }

  /// `Enable wavy slider`
  String get enableWavySlider {
    return Intl.message(
      'Enable wavy slider',
      name: 'enableWavySlider',
      desc: '',
      args: [],
    );
  }

  /// `Ignored in video mode`
  String get videoModeInvalid {
    return Intl.message(
      'Ignored in video mode',
      name: 'videoModeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Startup Page`
  String get startupPage {
    return Intl.message(
      'Startup Page',
      name: 'startupPage',
      desc: '',
      args: [],
    );
  }

  /// `Playlist Default View`
  String get playlistDefaultView {
    return Intl.message(
      'Playlist Default View',
      name: 'playlistDefaultView',
      desc: '',
      args: [],
    );
  }

  /// `Grid`
  String get grid {
    return Intl.message(
      'Grid',
      name: 'grid',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get list {
    return Intl.message(
      'List',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Music Library Default View`
  String get musicLibraryDefaultView {
    return Intl.message(
      'Music Library Default View',
      name: 'musicLibraryDefaultView',
      desc: '',
      args: [],
    );
  }

  /// `Video Library Default View`
  String get videoLibraryDefaultView {
    return Intl.message(
      'Video Library Default View',
      name: 'videoLibraryDefaultView',
      desc: '',
      args: [],
    );
  }

  /// `Theme Settings`
  String get themeSettings {
    return Intl.message(
      'Theme Settings',
      name: 'themeSettings',
      desc: '',
      args: [],
    );
  }

  /// `Theme Color`
  String get themeColor {
    return Intl.message(
      'Theme Color',
      name: 'themeColor',
      desc: '',
      args: [],
    );
  }

  /// `Theme Mode Follows System`
  String get themeModeFollowSystem {
    return Intl.message(
      'Theme Mode Follows System',
      name: 'themeModeFollowSystem',
      desc: '',
      args: [],
    );
  }

  /// `Enable Dark Mode`
  String get enableDarkMode {
    return Intl.message(
      'Enable Dark Mode',
      name: 'enableDarkMode',
      desc: '',
      args: [],
    );
  }

  /// `Contributors`
  String get contributors {
    return Intl.message(
      'Contributors',
      name: 'contributors',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Project Website`
  String get projectWebsite {
    return Intl.message(
      'Project Website',
      name: 'projectWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Report an Issue`
  String get feedback {
    return Intl.message(
      'Report an Issue',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `New Playlist`
  String get newPlaylist {
    return Intl.message(
      'New Playlist',
      name: 'newPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Toggle Display Mode`
  String get toggleDisplayMode {
    return Intl.message(
      'Toggle Display Mode',
      name: 'toggleDisplayMode',
      desc: '',
      args: [],
    );
  }

  /// `No Playlists`
  String get noPlaylists {
    return Intl.message(
      'No Playlists',
      name: 'noPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Shuffle`
  String get shuffle {
    return Intl.message(
      'Shuffle',
      name: 'shuffle',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Save as`
  String get saveAs {
    return Intl.message(
      'Save as',
      name: 'saveAs',
      desc: '',
      args: [],
    );
  }

  /// `Save file as:`
  String get fileSavedAs {
    return Intl.message(
      'Save file as:',
      name: 'fileSavedAs',
      desc: '',
      args: [],
    );
  }

  /// `Change Cover`
  String get changeCover {
    return Intl.message(
      'Change Cover',
      name: 'changeCover',
      desc: '',
      args: [],
    );
  }

  /// `Remove Cover`
  String get removeCover {
    return Intl.message(
      'Remove Cover',
      name: 'removeCover',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the playlist?`
  String get confirmDeletePlaylist {
    return Intl.message(
      'Are you sure you want to delete the playlist?',
      name: 'confirmDeletePlaylist',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get searchResults {
    return Intl.message(
      'Search Results',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `Search Playlists, Media Files...`
  String get searchPlaylistsMediaFiles {
    return Intl.message(
      'Search Playlists, Media Files...',
      name: 'searchPlaylistsMediaFiles',
      desc: '',
      args: [],
    );
  }

  /// `Recent Search`
  String get recentSearch {
    return Intl.message(
      'Recent Search',
      name: 'recentSearch',
      desc: '',
      args: [],
    );
  }

  /// `No Recent Searches`
  String get noRecentSearch {
    return Intl.message(
      'No Recent Searches',
      name: 'noRecentSearch',
      desc: '',
      args: [],
    );
  }

  /// `No Video`
  String get noVideo {
    return Intl.message(
      'No Video',
      name: 'noVideo',
      desc: '',
      args: [],
    );
  }

  /// `Play Next`
  String get playNext {
    return Intl.message(
      'Play Next',
      name: 'playNext',
      desc: '',
      args: [],
    );
  }

  /// `Play Last`
  String get playLast {
    return Intl.message(
      'Play Last',
      name: 'playLast',
      desc: '',
      args: [],
    );
  }

  /// `Add to a Playlist...`
  String get addToPlaylist {
    return Intl.message(
      'Add to a Playlist...',
      name: 'addToPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `All Episodes`
  String get allEpisodes {
    return Intl.message(
      'All Episodes',
      name: 'allEpisodes',
      desc: '',
      args: [],
    );
  }

  /// `Current List`
  String get currentList {
    return Intl.message(
      'Current List',
      name: 'currentList',
      desc: '',
      args: [],
    );
  }

  /// `Lyrics`
  String get lyrics {
    return Intl.message(
      'Lyrics',
      name: 'lyrics',
      desc: '',
      args: [],
    );
  }

  /// `No Music`
  String get noMusic {
    return Intl.message(
      'No Music',
      name: 'noMusic',
      desc: '',
      args: [],
    );
  }

  /// `Downloads`
  String get downloadManager {
    return Intl.message(
      'Downloads',
      name: 'downloadManager',
      desc: '',
      args: [],
    );
  }

  /// `Open Folder`
  String get openFolder {
    return Intl.message(
      'Open Folder',
      name: 'openFolder',
      desc: '',
      args: [],
    );
  }

  /// `Open File`
  String get openMediaFile {
    return Intl.message(
      'Open File',
      name: 'openMediaFile',
      desc: '',
      args: [],
    );
  }

  /// `Open URL`
  String get openUrl {
    return Intl.message(
      'Open URL',
      name: 'openUrl',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get mediaLibrary {
    return Intl.message(
      'Library',
      name: 'mediaLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Recently Played`
  String get recentlyPlayed {
    return Intl.message(
      'Recently Played',
      name: 'recentlyPlayed',
      desc: '',
      args: [],
    );
  }

  /// `No Recently Played`
  String get noRecentlyPlayed {
    return Intl.message(
      'No Recently Played',
      name: 'noRecentlyPlayed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
