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

  /// `Playlist`
  String get playlist {
    return Intl.message(
      'Playlist',
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

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
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

  /// `Path Settings`
  String get pathSettings {
    return Intl.message(
      'Path Settings',
      name: 'pathSettings',
      desc: '',
      args: [],
    );
  }

  /// `Music Folder`
  String get musicFolder {
    return Intl.message(
      'Music Folder',
      name: 'musicFolder',
      desc: '',
      args: [],
    );
  }

  /// `Video Folder`
  String get videoFolder {
    return Intl.message(
      'Video Folder',
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

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `BV Tools`
  String get bvTools {
    return Intl.message(
      'BV Tools',
      name: 'bvTools',
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

  /// `Developer`
  String get developer {
    return Intl.message(
      'Developer',
      name: 'developer',
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

  /// `Play Settings`
  String get playback_settings {
    return Intl.message(
      'Play Settings',
      name: 'playback_settings',
      desc: '',
      args: [],
    );
  }

  /// `Auto Play Video`
  String get auto_play_video {
    return Intl.message(
      'Auto Play Video',
      name: 'auto_play_video',
      desc: '',
      args: [],
    );
  }

  /// `Auto Download Video`
  String get auto_download_video {
    return Intl.message(
      'Auto Download Video',
      name: 'auto_download_video',
      desc: '',
      args: [],
    );
  }

  /// `Default Music Mode`
  String get default_music_mode {
    return Intl.message(
      'Default Music Mode',
      name: 'default_music_mode',
      desc: '',
      args: [],
    );
  }

  /// `Remember Player State`
  String get remember_player_state {
    return Intl.message(
      'Remember Player State',
      name: 'remember_player_state',
      desc: '',
      args: [],
    );
  }

  /// `Volume and Speed`
  String get volume_and_speed {
    return Intl.message(
      'Volume and Speed',
      name: 'volume_and_speed',
      desc: '',
      args: [],
    );
  }

  /// `Continue Playing After Exit`
  String get continue_play_after_exit {
    return Intl.message(
      'Continue Playing After Exit',
      name: 'continue_play_after_exit',
      desc: '',
      args: [],
    );
  }

  /// `Stop via Global Playback Control`
  String get global_playback_control {
    return Intl.message(
      'Stop via Global Playback Control',
      name: 'global_playback_control',
      desc: '',
      args: [],
    );
  }

  /// `MPV Settings (Incomplete)`
  String get mpv_settings {
    return Intl.message(
      'MPV Settings (Incomplete)',
      name: 'mpv_settings',
      desc: '',
      args: [],
    );
  }

  /// `Display Language`
  String get display_language {
    return Intl.message(
      'Display Language',
      name: 'display_language',
      desc: '',
      args: [],
    );
  }

  /// `Simplified Chinese`
  String get simplified_chinese {
    return Intl.message(
      'Simplified Chinese',
      name: 'simplified_chinese',
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

  /// `Interface Settings`
  String get interface_settings {
    return Intl.message(
      'Interface Settings',
      name: 'interface_settings',
      desc: '',
      args: [],
    );
  }

  /// `Enable Wave Style Progress Bar`
  String get enable_wave_style_progress_bar {
    return Intl.message(
      'Enable Wave Style Progress Bar',
      name: 'enable_wave_style_progress_bar',
      desc: '',
      args: [],
    );
  }

  /// `Invalid in Video Mode`
  String get video_mode_invalid {
    return Intl.message(
      'Invalid in Video Mode',
      name: 'video_mode_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Initial Page`
  String get initial_page {
    return Intl.message(
      'Initial Page',
      name: 'initial_page',
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

  /// `Playlist Default View`
  String get playlist_default_view {
    return Intl.message(
      'Playlist Default View',
      name: 'playlist_default_view',
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
  String get music_library_default_view {
    return Intl.message(
      'Music Library Default View',
      name: 'music_library_default_view',
      desc: '',
      args: [],
    );
  }

  /// `Video Library Default View`
  String get video_library_default_view {
    return Intl.message(
      'Video Library Default View',
      name: 'video_library_default_view',
      desc: '',
      args: [],
    );
  }

  /// `Theme Settings`
  String get theme_settings {
    return Intl.message(
      'Theme Settings',
      name: 'theme_settings',
      desc: '',
      args: [],
    );
  }

  /// `Theme Color`
  String get theme_color {
    return Intl.message(
      'Theme Color',
      name: 'theme_color',
      desc: '',
      args: [],
    );
  }

  /// `Theme Mode Follows System`
  String get theme_mode_follow_system {
    return Intl.message(
      'Theme Mode Follows System',
      name: 'theme_mode_follow_system',
      desc: '',
      args: [],
    );
  }

  /// `Enable Dark Mode`
  String get enable_dark_mode {
    return Intl.message(
      'Enable Dark Mode',
      name: 'enable_dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Developer Settings`
  String get developer_settings {
    return Intl.message(
      'Developer Settings',
      name: 'developer_settings',
      desc: '',
      args: [],
    );
  }

  /// `Enable Tablet UI`
  String get enable_tablet_ui {
    return Intl.message(
      'Enable Tablet UI',
      name: 'enable_tablet_ui',
      desc: '',
      args: [],
    );
  }

  /// `Enable Custom TitleBar`
  String get enable_custom_title_bar {
    return Intl.message(
      'Enable Custom TitleBar',
      name: 'enable_custom_title_bar',
      desc: '',
      args: [],
    );
  }

  /// `TitleBar Offset`
  String get title_bar_offset {
    return Intl.message(
      'TitleBar Offset',
      name: 'title_bar_offset',
      desc: '',
      args: [],
    );
  }

  /// `base: 30`
  String get base {
    return Intl.message(
      'base: 30',
      name: 'base',
      desc: '',
      args: [],
    );
  }

  /// `BV Tools Settings`
  String get bv_tools_settings {
    return Intl.message(
      'BV Tools Settings',
      name: 'bv_tools_settings',
      desc: '',
      args: [],
    );
  }

  /// `Enable BV Tools`
  String get enable_bv_tools {
    return Intl.message(
      'Enable BV Tools',
      name: 'enable_bv_tools',
      desc: '',
      args: [],
    );
  }

  /// `Load Cookies`
  String get load_cookies {
    return Intl.message(
      'Load Cookies',
      name: 'load_cookies',
      desc: '',
      args: [],
    );
  }

  /// `Cookies`
  String get cookies {
    return Intl.message(
      'Cookies',
      name: 'cookies',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
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

  /// `Refresh Cookies Status`
  String get refresh_cookies_status {
    return Intl.message(
      'Refresh Cookies Status',
      name: 'refresh_cookies_status',
      desc: '',
      args: [],
    );
  }

  /// `Current Cookies Status:`
  String get current_cookies_status {
    return Intl.message(
      'Current Cookies Status:',
      name: 'current_cookies_status',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Invalid`
  String get invalid {
    return Intl.message(
      'Invalid',
      name: 'invalid',
      desc: '',
      args: [],
    );
  }

  /// `Visitor Enable 1080P`
  String get visitor_enable_1080p {
    return Intl.message(
      'Visitor Enable 1080P',
      name: 'visitor_enable_1080p',
      desc: '',
      args: [],
    );
  }

  /// `Clear All Cookies`
  String get clear_all_cookies {
    return Intl.message(
      'Clear All Cookies',
      name: 'clear_all_cookies',
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

  /// `Project Address`
  String get project_address {
    return Intl.message(
      'Project Address',
      name: 'project_address',
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

  /// `Create Playlist`
  String get create_playlist {
    return Intl.message(
      'Create Playlist',
      name: 'create_playlist',
      desc: '',
      args: [],
    );
  }

  /// `new_list`
  String get new_list {
    return Intl.message(
      'new_list',
      name: 'new_list',
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

  /// `Toggle Display View`
  String get toggle_display_view {
    return Intl.message(
      'Toggle Display View',
      name: 'toggle_display_view',
      desc: '',
      args: [],
    );
  }

  /// `view_list`
  String get view_list {
    return Intl.message(
      'view_list',
      name: 'view_list',
      desc: '',
      args: [],
    );
  }

  /// `No Playlists`
  String get no_playlists {
    return Intl.message(
      'No Playlists',
      name: 'no_playlists',
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

  /// `Play in Order`
  String get play_in_order {
    return Intl.message(
      'Play in Order',
      name: 'play_in_order',
      desc: '',
      args: [],
    );
  }

  /// `Play Randomly`
  String get play_randomly {
    return Intl.message(
      'Play Randomly',
      name: 'play_randomly',
      desc: '',
      args: [],
    );
  }

  /// `Append to Current List`
  String get append_to_current_list {
    return Intl.message(
      'Append to Current List',
      name: 'append_to_current_list',
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

  /// `Save As`
  String get save_as {
    return Intl.message(
      'Save As',
      name: 'save_as',
      desc: '',
      args: [],
    );
  }

  /// `File Saved As:`
  String get file_saved_as {
    return Intl.message(
      'File Saved As:',
      name: 'file_saved_as',
      desc: '',
      args: [],
    );
  }

  /// `Modify Cover`
  String get modify_cover {
    return Intl.message(
      'Modify Cover',
      name: 'modify_cover',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cover`
  String get clear_cover {
    return Intl.message(
      'Clear Cover',
      name: 'clear_cover',
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

  /// `Confirm Action`
  String get confirm_action {
    return Intl.message(
      'Confirm Action',
      name: 'confirm_action',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the playlist?`
  String get confirm_delete_playlist {
    return Intl.message(
      'Are you sure you want to delete the playlist?',
      name: 'confirm_delete_playlist',
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
  String get search_results {
    return Intl.message(
      'Search Results',
      name: 'search_results',
      desc: '',
      args: [],
    );
  }

  /// `Search Playlists, Media Files...`
  String get search_playlists_media_files {
    return Intl.message(
      'Search Playlists, Media Files...',
      name: 'search_playlists_media_files',
      desc: '',
      args: [],
    );
  }

  /// `Recent Search`
  String get recent_search {
    return Intl.message(
      'Recent Search',
      name: 'recent_search',
      desc: '',
      args: [],
    );
  }

  /// `No Recent Searches`
  String get no_recent_search {
    return Intl.message(
      'No Recent Searches',
      name: 'no_recent_search',
      desc: '',
      args: [],
    );
  }

  /// `No Video`
  String get no_video {
    return Intl.message(
      'No Video',
      name: 'no_video',
      desc: '',
      args: [],
    );
  }

  /// `Insert Play`
  String get insert_play {
    return Intl.message(
      'Insert Play',
      name: 'insert_play',
      desc: '',
      args: [],
    );
  }

  /// `Last Played`
  String get last_played {
    return Intl.message(
      'Last Played',
      name: 'last_played',
      desc: '',
      args: [],
    );
  }

  /// `Add to Playlist`
  String get add_to_playlist {
    return Intl.message(
      'Add to Playlist',
      name: 'add_to_playlist',
      desc: '',
      args: [],
    );
  }

  /// `All Episodes`
  String get all_episodes {
    return Intl.message(
      'All Episodes',
      name: 'all_episodes',
      desc: '',
      args: [],
    );
  }

  /// `Current List`
  String get current_list {
    return Intl.message(
      'Current List',
      name: 'current_list',
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
  String get no_music {
    return Intl.message(
      'No Music',
      name: 'no_music',
      desc: '',
      args: [],
    );
  }

  /// `Download Manager`
  String get download_manager {
    return Intl.message(
      'Download Manager',
      name: 'download_manager',
      desc: '',
      args: [],
    );
  }

  /// `Downloading`
  String get downloading {
    return Intl.message(
      'Downloading',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Download Failed`
  String get download_failed {
    return Intl.message(
      'Download Failed',
      name: 'download_failed',
      desc: '',
      args: [],
    );
  }

  /// `All Tasks`
  String get all_tasks {
    return Intl.message(
      'All Tasks',
      name: 'all_tasks',
      desc: '',
      args: [],
    );
  }

  /// `Play Folder`
  String get play_folder {
    return Intl.message(
      'Play Folder',
      name: 'play_folder',
      desc: '',
      args: [],
    );
  }

  /// `Play Local File`
  String get play_local_file {
    return Intl.message(
      'Play Local File',
      name: 'play_local_file',
      desc: '',
      args: [],
    );
  }

  /// `Open Network Stream`
  String get open_network_stream {
    return Intl.message(
      'Open Network Stream',
      name: 'open_network_stream',
      desc: '',
      args: [],
    );
  }

  /// `Media Library`
  String get media_library {
    return Intl.message(
      'Media Library',
      name: 'media_library',
      desc: '',
      args: [],
    );
  }

  /// `collect`
  String get collect {
    return Intl.message(
      'collect',
      name: 'collect',
      desc: '',
      args: [],
    );
  }

  /// `Recently Played`
  String get recently_played {
    return Intl.message(
      'Recently Played',
      name: 'recently_played',
      desc: '',
      args: [],
    );
  }

  /// `No Recently Played`
  String get no_recently_played {
    return Intl.message(
      'No Recently Played',
      name: 'no_recently_played',
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
