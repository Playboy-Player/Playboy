class VideoStreamResponse {
  VideoStreamResponse({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  final int? code;
  final String? message;
  final int? ttl;
  final StreamData? data;

  factory VideoStreamResponse.fromJson(Map<String, dynamic> json) {
    return VideoStreamResponse(
      code: json["code"],
      message: json["message"],
      ttl: json["ttl"],
      data: json["data"] == null ? null : StreamData.fromJson(json["data"]),
    );
  }
}

class StreamData {
  StreamData({
    required this.from,
    required this.result,
    required this.message,
    required this.quality,
    required this.format,
    required this.timelength,
    required this.acceptFormat,
    required this.acceptDescription,
    required this.acceptQuality,
    required this.videoCodecid,
    required this.seekParam,
    required this.seekType,
    required this.dash,
    required this.supportFormats,
    required this.highFormat,
    required this.lastPlayTime,
    required this.lastPlayCid,
  });

  final String? from;
  final String? result;
  final String? message;
  final int? quality;
  final String? format;
  final int? timelength;
  final String? acceptFormat;
  final List<String> acceptDescription;
  final List<int> acceptQuality;
  final int? videoCodecid;
  final String? seekParam;
  final String? seekType;
  final Dash? dash;
  final List<SupportFormat> supportFormats;
  final dynamic highFormat;
  final int? lastPlayTime;
  final int? lastPlayCid;

  factory StreamData.fromJson(Map<String, dynamic> json) {
    return StreamData(
      from: json["from"],
      result: json["result"],
      message: json["message"],
      quality: json["quality"],
      format: json["format"],
      timelength: json["timelength"],
      acceptFormat: json["accept_format"],
      acceptDescription: json["accept_description"] == null
          ? []
          : List<String>.from(json["accept_description"]!.map((x) => x)),
      acceptQuality: json["accept_quality"] == null
          ? []
          : List<int>.from(json["accept_quality"]!.map((x) => x)),
      videoCodecid: json["video_codecid"],
      seekParam: json["seek_param"],
      seekType: json["seek_type"],
      dash: json["dash"] == null ? null : Dash.fromJson(json["dash"]),
      supportFormats: json["support_formats"] == null
          ? []
          : List<SupportFormat>.from(
              json["support_formats"]!.map((x) => SupportFormat.fromJson(x))),
      highFormat: json["high_format"],
      lastPlayTime: json["last_play_time"],
      lastPlayCid: json["last_play_cid"],
    );
  }
}

class Dash {
  Dash({
    required this.duration,
    required this.minBufferTime,
    required this.dashMinBufferTime,
    required this.video,
    required this.audio,
    required this.dolby,
    required this.flac,
  });

  final int? duration;
  final double? minBufferTime;
  final double? dashMinBufferTime;
  final List<Audio> video;
  final List<Audio> audio;
  final Dolby? dolby;
  final dynamic flac;

  factory Dash.fromJson(Map<String, dynamic> json) {
    return Dash(
      duration: json["duration"],
      minBufferTime: json["minBufferTime"],
      dashMinBufferTime: json["min_buffer_time"],
      video: json["video"] == null
          ? []
          : List<Audio>.from(json["video"]!.map((x) => Audio.fromJson(x))),
      audio: json["audio"] == null
          ? []
          : List<Audio>.from(json["audio"]!.map((x) => Audio.fromJson(x))),
      dolby: json["dolby"] == null ? null : Dolby.fromJson(json["dolby"]),
      flac: json["flac"],
    );
  }
}

class Audio {
  Audio({
    required this.id,
    required this.baseUrl,
    required this.audioBaseUrl,
    required this.backupUrl,
    required this.audioBackupUrl,
    required this.bandwidth,
    required this.mimeType,
    required this.audioMimeType,
    required this.codecs,
    required this.width,
    required this.height,
    required this.frameRate,
    required this.audioFrameRate,
    required this.sar,
    required this.startWithSap,
    required this.audioStartWithSap,
    required this.segmentBase,
    required this.audioSegmentBase,
    required this.codecid,
  });

  final int? id;
  final String? baseUrl;
  final String? audioBaseUrl;
  final List<String> backupUrl;
  final List<String> audioBackupUrl;
  final int? bandwidth;
  final String? mimeType;
  final String? audioMimeType;
  final String? codecs;
  final int? width;
  final int? height;
  final String? frameRate;
  final String? audioFrameRate;
  final String? sar;
  final int? startWithSap;
  final int? audioStartWithSap;
  final SegmentBase? segmentBase;
  final SegmentBaseClass? audioSegmentBase;
  final int? codecid;

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json["id"],
      baseUrl: json["baseUrl"],
      audioBaseUrl: json["base_url"],
      backupUrl: json["backupUrl"] == null
          ? []
          : List<String>.from(json["backupUrl"]!.map((x) => x)),
      audioBackupUrl: json["backup_url"] == null
          ? []
          : List<String>.from(json["backup_url"]!.map((x) => x)),
      bandwidth: json["bandwidth"],
      mimeType: json["mimeType"],
      audioMimeType: json["mime_type"],
      codecs: json["codecs"],
      width: json["width"],
      height: json["height"],
      frameRate: json["frameRate"],
      audioFrameRate: json["frame_rate"],
      sar: json["sar"],
      startWithSap: json["startWithSap"],
      audioStartWithSap: json["start_with_sap"],
      segmentBase: json["SegmentBase"] == null
          ? null
          : SegmentBase.fromJson(json["SegmentBase"]),
      audioSegmentBase: json["segment_base"] == null
          ? null
          : SegmentBaseClass.fromJson(json["segment_base"]),
      codecid: json["codecid"],
    );
  }
}

class SegmentBaseClass {
  SegmentBaseClass({
    required this.initialization,
    required this.indexRange,
  });

  final String? initialization;
  final String? indexRange;

  factory SegmentBaseClass.fromJson(Map<String, dynamic> json) {
    return SegmentBaseClass(
      initialization: json["initialization"],
      indexRange: json["index_range"],
    );
  }
}

class SegmentBase {
  SegmentBase({
    required this.initialization,
    required this.indexRange,
  });

  final String? initialization;
  final String? indexRange;

  factory SegmentBase.fromJson(Map<String, dynamic> json) {
    return SegmentBase(
      initialization: json["Initialization"],
      indexRange: json["indexRange"],
    );
  }
}

class Dolby {
  Dolby({
    required this.type,
    required this.audio,
  });

  final int? type;
  final dynamic audio;

  factory Dolby.fromJson(Map<String, dynamic> json) {
    return Dolby(
      type: json["type"],
      audio: json["audio"],
    );
  }
}

class SupportFormat {
  SupportFormat({
    required this.quality,
    required this.format,
    required this.newDescription,
    required this.displayDesc,
    required this.superscript,
    required this.codecs,
  });

  final int? quality;
  final String? format;
  final String? newDescription;
  final String? displayDesc;
  final String? superscript;
  final List<String> codecs;

  factory SupportFormat.fromJson(Map<String, dynamic> json) {
    return SupportFormat(
      quality: json["quality"],
      format: json["format"],
      newDescription: json["new_description"],
      displayDesc: json["display_desc"],
      superscript: json["superscript"],
      codecs: json["codecs"] == null
          ? []
          : List<String>.from(json["codecs"]!.map((x) => x)),
    );
  }
}
