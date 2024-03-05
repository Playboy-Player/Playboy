//https://github.com/SocialSisterYi/bilibili-API-collect/blob/4c2911c72a5e26860497eef7a6437a5f50c65b4a/docs/video/info.md

class VideoInfoResponse {
  VideoInfoResponse({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  final int? code;
  final String? message;
  final int? ttl;
  final VideoInfoResponseData? data;

  factory VideoInfoResponse.fromJson(Map<String, dynamic> json) {
    return VideoInfoResponse(
      code: json["code"],
      message: json["message"],
      ttl: json["ttl"],
      data: json["data"] == null
          ? null
          : VideoInfoResponseData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class VideoInfoResponseData {
  VideoInfoResponseData({
    required this.bvid,
    required this.aid,
    required this.videos,
    required this.tid,
    required this.tname,
    required this.copyright,
    required this.pic,
    required this.title,
    required this.pubdate,
    required this.ctime,
    required this.desc,
    required this.descV2,
    required this.state,
    required this.duration,
    required this.missionId,
    required this.rights,
    required this.owner,
    required this.stat,
    required this.dataDynamic,
    required this.cid,
    required this.dimension,
    required this.premiere,
    required this.teenageMode,
    required this.isChargeableSeason,
    required this.isStory,
    required this.isUpowerExclusive,
    required this.isUpowerPlay,
    required this.enableVt,
    required this.vtDisplay,
    required this.noCache,
    required this.pages,
    required this.subtitle,
    required this.staff,
    required this.isSeasonDisplay,
    required this.userGarb,
    required this.honorReply,
    required this.likeIcon,
    required this.needJumpBv,
    required this.disableShowUpInfo,
  });

  final String? bvid;
  final int? aid;
  final int? videos;
  final int? tid;
  final String? tname;
  final int? copyright;
  final String? pic;
  final String? title;
  final int? pubdate;
  final int? ctime;
  final String? desc;
  final List<DescV2> descV2;
  final int? state;
  final int? duration;
  final int? missionId;
  final Map<String, int> rights;
  final Owner? owner;
  final Stat? stat;
  final String? dataDynamic;
  final int? cid;
  final Dimension? dimension;
  final dynamic premiere;
  final int? teenageMode;
  final bool? isChargeableSeason;
  final bool? isStory;
  final bool? isUpowerExclusive;
  final bool? isUpowerPlay;
  final int? enableVt;
  final String? vtDisplay;
  final bool? noCache;
  final List<Page> pages;
  final Subtitle? subtitle;
  final List<Staff> staff;
  final bool? isSeasonDisplay;
  final UserGarb? userGarb;
  final HonorReply? honorReply;
  final String? likeIcon;
  final bool? needJumpBv;
  final bool? disableShowUpInfo;

  factory VideoInfoResponseData.fromJson(Map<String, dynamic> json) {
    return VideoInfoResponseData(
      bvid: json["bvid"],
      aid: json["aid"],
      videos: json["videos"],
      tid: json["tid"],
      tname: json["tname"],
      copyright: json["copyright"],
      pic: json["pic"],
      title: json["title"],
      pubdate: json["pubdate"],
      ctime: json["ctime"],
      desc: json["desc"],
      descV2: json["desc_v2"] == null
          ? []
          : List<DescV2>.from(json["desc_v2"]!.map((x) => DescV2.fromJson(x))),
      state: json["state"],
      duration: json["duration"],
      missionId: json["mission_id"],
      rights:
          Map.from(json["rights"]).map((k, v) => MapEntry<String, int>(k, v)),
      owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
      stat: json["stat"] == null ? null : Stat.fromJson(json["stat"]),
      dataDynamic: json["dynamic"],
      cid: json["cid"],
      dimension: json["dimension"] == null
          ? null
          : Dimension.fromJson(json["dimension"]),
      premiere: json["premiere"],
      teenageMode: json["teenage_mode"],
      isChargeableSeason: json["is_chargeable_season"],
      isStory: json["is_story"],
      isUpowerExclusive: json["is_upower_exclusive"],
      isUpowerPlay: json["is_upower_play"],
      enableVt: json["enable_vt"],
      vtDisplay: json["vt_display"],
      noCache: json["no_cache"],
      pages: json["pages"] == null
          ? []
          : List<Page>.from(json["pages"]!.map((x) => Page.fromJson(x))),
      subtitle:
          json["subtitle"] == null ? null : Subtitle.fromJson(json["subtitle"]),
      staff: json["staff"] == null
          ? []
          : List<Staff>.from(json["staff"]!.map((x) => Staff.fromJson(x))),
      isSeasonDisplay: json["is_season_display"],
      userGarb: json["user_garb"] == null
          ? null
          : UserGarb.fromJson(json["user_garb"]),
      honorReply: json["honor_reply"] == null
          ? null
          : HonorReply.fromJson(json["honor_reply"]),
      likeIcon: json["like_icon"],
      needJumpBv: json["need_jump_bv"],
      disableShowUpInfo: json["disable_show_up_info"],
    );
  }

  Map<String, dynamic> toJson() => {
        "bvid": bvid,
        "aid": aid,
        "videos": videos,
        "tid": tid,
        "tname": tname,
        "copyright": copyright,
        "pic": pic,
        "title": title,
        "pubdate": pubdate,
        "ctime": ctime,
        "desc": desc,
        "desc_v2": descV2.map((x) => x.toJson()).toList(),
        "state": state,
        "duration": duration,
        "mission_id": missionId,
        "rights":
            Map.from(rights).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "owner": owner?.toJson(),
        "stat": stat?.toJson(),
        "dynamic": dataDynamic,
        "cid": cid,
        "dimension": dimension?.toJson(),
        "premiere": premiere,
        "teenage_mode": teenageMode,
        "is_chargeable_season": isChargeableSeason,
        "is_story": isStory,
        "is_upower_exclusive": isUpowerExclusive,
        "is_upower_play": isUpowerPlay,
        "enable_vt": enableVt,
        "vt_display": vtDisplay,
        "no_cache": noCache,
        "pages": pages.map((x) => x.toJson()).toList(),
        "subtitle": subtitle?.toJson(),
        "staff": staff.map((x) => x.toJson()).toList(),
        "is_season_display": isSeasonDisplay,
        "user_garb": userGarb?.toJson(),
        "honor_reply": honorReply?.toJson(),
        "like_icon": likeIcon,
        "need_jump_bv": needJumpBv,
        "disable_show_up_info": disableShowUpInfo,
      };
}

class DescV2 {
  DescV2({
    required this.rawText,
    required this.type,
    required this.bizId,
  });

  final String? rawText;
  final int? type;
  final int? bizId;

  factory DescV2.fromJson(Map<String, dynamic> json) {
    return DescV2(
      rawText: json["raw_text"],
      type: json["type"],
      bizId: json["biz_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "raw_text": rawText,
        "type": type,
        "biz_id": bizId,
      };
}

class Dimension {
  Dimension({
    required this.width,
    required this.height,
    required this.rotate,
  });

  final int? width;
  final int? height;
  final int? rotate;

  factory Dimension.fromJson(Map<String, dynamic> json) {
    return Dimension(
      width: json["width"],
      height: json["height"],
      rotate: json["rotate"],
    );
  }

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "rotate": rotate,
      };
}

class HonorReply {
  HonorReply({
    required this.honor,
  });

  final List<Honor> honor;

  factory HonorReply.fromJson(Map<String, dynamic> json) {
    return HonorReply(
      honor: json["honor"] == null
          ? []
          : List<Honor>.from(json["honor"]!.map((x) => Honor.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "honor": honor.map((x) => x.toJson()).toList(),
      };
}

class Honor {
  Honor({
    required this.aid,
    required this.type,
    required this.desc,
    required this.weeklyRecommendNum,
  });

  final int? aid;
  final int? type;
  final String? desc;
  final int? weeklyRecommendNum;

  factory Honor.fromJson(Map<String, dynamic> json) {
    return Honor(
      aid: json["aid"],
      type: json["type"],
      desc: json["desc"],
      weeklyRecommendNum: json["weekly_recommend_num"],
    );
  }

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "type": type,
        "desc": desc,
        "weekly_recommend_num": weeklyRecommendNum,
      };
}

class Owner {
  Owner({
    required this.mid,
    required this.name,
    required this.face,
  });

  final int? mid;
  final String? name;
  final String? face;

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      mid: json["mid"],
      name: json["name"],
      face: json["face"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "name": name,
        "face": face,
      };
}

class Page {
  Page({
    required this.cid,
    required this.page,
    required this.from,
    required this.pagePart,
    required this.duration,
    required this.vid,
    required this.weblink,
    required this.dimension,
  });

  final int? cid;
  final int? page;
  final String? from;
  final String? pagePart;
  final int? duration;
  final String? vid;
  final String? weblink;
  final Dimension? dimension;

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      cid: json["cid"],
      page: json["page"],
      from: json["from"],
      pagePart: json["part"],
      duration: json["duration"],
      vid: json["vid"],
      weblink: json["weblink"],
      dimension: json["dimension"] == null
          ? null
          : Dimension.fromJson(json["dimension"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "page": page,
        "from": from,
        "part": pagePart,
        "duration": duration,
        "vid": vid,
        "weblink": weblink,
        "dimension": dimension?.toJson(),
      };
}

class Staff {
  Staff({
    required this.mid,
    required this.title,
    required this.name,
    required this.face,
    required this.vip,
    required this.official,
    required this.follower,
    required this.labelStyle,
  });

  final int? mid;
  final String? title;
  final String? name;
  final String? face;
  final Vip? vip;
  final Official? official;
  final int? follower;
  final int? labelStyle;

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      mid: json["mid"],
      title: json["title"],
      name: json["name"],
      face: json["face"],
      vip: json["vip"] == null ? null : Vip.fromJson(json["vip"]),
      official:
          json["official"] == null ? null : Official.fromJson(json["official"]),
      follower: json["follower"],
      labelStyle: json["label_style"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "title": title,
        "name": name,
        "face": face,
        "vip": vip?.toJson(),
        "official": official?.toJson(),
        "follower": follower,
        "label_style": labelStyle,
      };
}

class Official {
  Official({
    required this.role,
    required this.title,
    required this.desc,
    required this.type,
  });

  final int? role;
  final String? title;
  final String? desc;
  final int? type;

  factory Official.fromJson(Map<String, dynamic> json) {
    return Official(
      role: json["role"],
      title: json["title"],
      desc: json["desc"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "role": role,
        "title": title,
        "desc": desc,
        "type": type,
      };
}

class Vip {
  Vip({
    required this.type,
    required this.status,
    required this.dueDate,
    required this.vipPayType,
    required this.themeType,
    required this.label,
    required this.avatarSubscript,
    required this.nicknameColor,
    required this.role,
    required this.avatarSubscriptUrl,
    required this.tvVipStatus,
    required this.tvVipPayType,
    required this.tvDueDate,
  });

  final int? type;
  final int? status;
  final int? dueDate;
  final int? vipPayType;
  final int? themeType;
  final Label? label;
  final int? avatarSubscript;
  final String? nicknameColor;
  final int? role;
  final String? avatarSubscriptUrl;
  final int? tvVipStatus;
  final int? tvVipPayType;
  final int? tvDueDate;

  factory Vip.fromJson(Map<String, dynamic> json) {
    return Vip(
      type: json["type"],
      status: json["status"],
      dueDate: json["due_date"],
      vipPayType: json["vip_pay_type"],
      themeType: json["theme_type"],
      label: json["label"] == null ? null : Label.fromJson(json["label"]),
      avatarSubscript: json["avatar_subscript"],
      nicknameColor: json["nickname_color"],
      role: json["role"],
      avatarSubscriptUrl: json["avatar_subscript_url"],
      tvVipStatus: json["tv_vip_status"],
      tvVipPayType: json["tv_vip_pay_type"],
      tvDueDate: json["tv_due_date"],
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": status,
        "due_date": dueDate,
        "vip_pay_type": vipPayType,
        "theme_type": themeType,
        "label": label?.toJson(),
        "avatar_subscript": avatarSubscript,
        "nickname_color": nicknameColor,
        "role": role,
        "avatar_subscript_url": avatarSubscriptUrl,
        "tv_vip_status": tvVipStatus,
        "tv_vip_pay_type": tvVipPayType,
        "tv_due_date": tvDueDate,
      };
}

class Label {
  Label({
    required this.path,
    required this.text,
    required this.labelTheme,
    required this.textColor,
    required this.bgStyle,
    required this.bgColor,
    required this.borderColor,
    required this.useImgLabel,
    required this.imgLabelUriHans,
    required this.imgLabelUriHant,
    required this.imgLabelUriHansStatic,
    required this.imgLabelUriHantStatic,
  });

  final String? path;
  final String? text;
  final String? labelTheme;
  final String? textColor;
  final int? bgStyle;
  final String? bgColor;
  final String? borderColor;
  final bool? useImgLabel;
  final String? imgLabelUriHans;
  final String? imgLabelUriHant;
  final String? imgLabelUriHansStatic;
  final String? imgLabelUriHantStatic;

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      path: json["path"],
      text: json["text"],
      labelTheme: json["label_theme"],
      textColor: json["text_color"],
      bgStyle: json["bg_style"],
      bgColor: json["bg_color"],
      borderColor: json["border_color"],
      useImgLabel: json["use_img_label"],
      imgLabelUriHans: json["img_label_uri_hans"],
      imgLabelUriHant: json["img_label_uri_hant"],
      imgLabelUriHansStatic: json["img_label_uri_hans_static"],
      imgLabelUriHantStatic: json["img_label_uri_hant_static"],
    );
  }

  Map<String, dynamic> toJson() => {
        "path": path,
        "text": text,
        "label_theme": labelTheme,
        "text_color": textColor,
        "bg_style": bgStyle,
        "bg_color": bgColor,
        "border_color": borderColor,
        "use_img_label": useImgLabel,
        "img_label_uri_hans": imgLabelUriHans,
        "img_label_uri_hant": imgLabelUriHant,
        "img_label_uri_hans_static": imgLabelUriHansStatic,
        "img_label_uri_hant_static": imgLabelUriHantStatic,
      };
}

class Stat {
  Stat({
    required this.aid,
    required this.view,
    required this.danmaku,
    required this.reply,
    required this.favorite,
    required this.coin,
    required this.share,
    required this.nowRank,
    required this.hisRank,
    required this.like,
    required this.dislike,
    required this.evaluation,
    required this.argueMsg,
    required this.vt,
  });

  final int? aid;
  final int? view;
  final int? danmaku;
  final int? reply;
  final int? favorite;
  final int? coin;
  final int? share;
  final int? nowRank;
  final int? hisRank;
  final int? like;
  final int? dislike;
  final String? evaluation;
  final String? argueMsg;
  final int? vt;

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      aid: json["aid"],
      view: json["view"],
      danmaku: json["danmaku"],
      reply: json["reply"],
      favorite: json["favorite"],
      coin: json["coin"],
      share: json["share"],
      nowRank: json["now_rank"],
      hisRank: json["his_rank"],
      like: json["like"],
      dislike: json["dislike"],
      evaluation: json["evaluation"],
      argueMsg: json["argue_msg"],
      vt: json["vt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "view": view,
        "danmaku": danmaku,
        "reply": reply,
        "favorite": favorite,
        "coin": coin,
        "share": share,
        "now_rank": nowRank,
        "his_rank": hisRank,
        "like": like,
        "dislike": dislike,
        "evaluation": evaluation,
        "argue_msg": argueMsg,
        "vt": vt,
      };
}

class Subtitle {
  Subtitle({
    required this.allowSubmit,
    required this.list,
  });

  final bool? allowSubmit;
  final List<ListElement> list;

  factory Subtitle.fromJson(Map<String, dynamic> json) {
    return Subtitle(
      allowSubmit: json["allow_submit"],
      list: json["list"] == null
          ? []
          : List<ListElement>.from(
              json["list"]!.map((x) => ListElement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "allow_submit": allowSubmit,
        "list": list.map((x) => x.toJson()).toList(),
      };
}

class ListElement {
  ListElement({
    required this.id,
    required this.lan,
    required this.lanDoc,
    required this.isLock,
    required this.subtitleUrl,
    required this.type,
    required this.idStr,
    required this.aiType,
    required this.aiStatus,
    required this.author,
  });

  final int? id;
  final String? lan;
  final String? lanDoc;
  final bool? isLock;
  final String? subtitleUrl;
  final int? type;
  final String? idStr;
  final int? aiType;
  final int? aiStatus;
  final Author? author;

  factory ListElement.fromJson(Map<String, dynamic> json) {
    return ListElement(
      id: json["id"],
      lan: json["lan"],
      lanDoc: json["lan_doc"],
      isLock: json["is_lock"],
      subtitleUrl: json["subtitle_url"],
      type: json["type"],
      idStr: json["id_str"],
      aiType: json["ai_type"],
      aiStatus: json["ai_status"],
      author: json["author"] == null ? null : Author.fromJson(json["author"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "lan": lan,
        "lan_doc": lanDoc,
        "is_lock": isLock,
        "subtitle_url": subtitleUrl,
        "type": type,
        "id_str": idStr,
        "ai_type": aiType,
        "ai_status": aiStatus,
        "author": author?.toJson(),
      };
}

class Author {
  Author({
    required this.mid,
    required this.name,
    required this.sex,
    required this.face,
    required this.sign,
    required this.rank,
    required this.birthday,
    required this.isFakeAccount,
    required this.isDeleted,
    required this.inRegAudit,
    required this.isSeniorMember,
  });

  final int? mid;
  final String? name;
  final String? sex;
  final String? face;
  final String? sign;
  final int? rank;
  final int? birthday;
  final int? isFakeAccount;
  final int? isDeleted;
  final int? inRegAudit;
  final int? isSeniorMember;

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      mid: json["mid"],
      name: json["name"],
      sex: json["sex"],
      face: json["face"],
      sign: json["sign"],
      rank: json["rank"],
      birthday: json["birthday"],
      isFakeAccount: json["is_fake_account"],
      isDeleted: json["is_deleted"],
      inRegAudit: json["in_reg_audit"],
      isSeniorMember: json["is_senior_member"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "name": name,
        "sex": sex,
        "face": face,
        "sign": sign,
        "rank": rank,
        "birthday": birthday,
        "is_fake_account": isFakeAccount,
        "is_deleted": isDeleted,
        "in_reg_audit": inRegAudit,
        "is_senior_member": isSeniorMember,
      };
}

class UserGarb {
  UserGarb({
    required this.urlImageAniCut,
  });

  final String? urlImageAniCut;

  factory UserGarb.fromJson(Map<String, dynamic> json) {
    return UserGarb(
      urlImageAniCut: json["url_image_ani_cut"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url_image_ani_cut": urlImageAniCut,
      };
}
