class User {
  Data? data;
  String? error;

  User({this.data, this.error});

  User.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  User.withError(String errorMessage) {
    error = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? idx;
  int? docstatus;
  int? enabled;
  String? email;
  String? firstName;
  String? lastName;
  String? username;
  String? fullName;
  String? language;
  String? middleName;
  String? referralCode;
  int? sendWelcomeEmail;
  int? unsubscribed;
  String? userImage;
  String? gender;
  String? birthDate;
  String? deskTheme;
  int? muteSounds;
  String? newPassword;
  int? logoutAllSessions;
  String? resetPasswordKey;
  String? lastPasswordResetDate;
  String? redirectUrl;
  int? documentFollowNotify;
  String? documentFollowFrequency;
  int? threadNotify;
  int? sendMeACopy;
  int? allowedInMentions;
  int? simultaneousSessions;
  String? lastIp;
  int? loginAfter;
  String? userType;
  String? lastActive;
  int? loginBefore;
  int? bypassRestrictIpCheckIf2faEnabled;
  String? lastLogin;
  String? lastKnownVersions;
  String? doctype;
  List<Roles>? roles;
  // List<Null>? userEmails;
  // List<Null>? blockModules;
  // List<Null>? defaults;
  // List<SocialLogins>? socialLogins;

  Data({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.idx,
    this.docstatus,
    this.enabled,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.fullName,
    this.language,
    this.middleName,
    this.referralCode,
    this.sendWelcomeEmail,
    this.unsubscribed,
    this.userImage,
    this.gender,
    this.birthDate,
    this.deskTheme,
    this.muteSounds,
    this.newPassword,
    this.logoutAllSessions,
    this.resetPasswordKey,
    this.lastPasswordResetDate,
    this.redirectUrl,
    this.documentFollowNotify,
    this.documentFollowFrequency,
    this.threadNotify,
    this.sendMeACopy,
    this.allowedInMentions,
    this.simultaneousSessions,
    this.lastIp,
    this.loginAfter,
    this.userType,
    this.lastActive,
    this.loginBefore,
    this.bypassRestrictIpCheckIf2faEnabled,
    this.lastLogin,
    this.lastKnownVersions,
    this.doctype,
    this.roles,
    // this.userEmails,
    // this.blockModules,
    // this.defaults,
    // this.socialLogins,
  });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    enabled = json['enabled'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    fullName = json['full_name'];
    language = json['language'];
    middleName = json['middle_name'];
    referralCode = json['referral_code'];
    sendWelcomeEmail = json['send_welcome_email'];
    unsubscribed = json['unsubscribed'];
    userImage = json['user_image'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    deskTheme = json['desk_theme'];
    muteSounds = json['mute_sounds'];
    newPassword = json['new_password'];
    logoutAllSessions = json['logout_all_sessions'];
    resetPasswordKey = json['reset_password_key'];
    lastPasswordResetDate = json['last_password_reset_date'];
    redirectUrl = json['redirect_url'];
    documentFollowNotify = json['document_follow_notify'];
    documentFollowFrequency = json['document_follow_frequency'];
    threadNotify = json['thread_notify'];
    sendMeACopy = json['send_me_a_copy'];
    allowedInMentions = json['allowed_in_mentions'];
    simultaneousSessions = json['simultaneous_sessions'];
    lastIp = json['last_ip'];
    loginAfter = json['login_after'];
    userType = json['user_type'];
    lastActive = json['last_active'];
    loginBefore = json['login_before'];
    bypassRestrictIpCheckIf2faEnabled =
        json['bypass_restrict_ip_check_if_2fa_enabled'];
    lastLogin = json['last_login'];
    lastKnownVersions = json['last_known_versions'];
    doctype = json['doctype'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    // if (json['user_emails'] != null) {
    //   userEmails = <Null>[];
    //   json['user_emails'].forEach((v) {
    //     userEmails!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['block_modules'] != null) {
    //   blockModules = <Null>[];
    //   json['block_modules'].forEach((v) {
    //     blockModules!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['defaults'] != null) {
    //   defaults = <Null>[];
    //   json['defaults'].forEach((v) {
    //     defaults!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['social_logins'] != null) {
    //   socialLogins = <SocialLogins>[];
    //   json['social_logins'].forEach((v) {
    //     socialLogins!.add(new SocialLogins.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['idx'] = this.idx;
    data['docstatus'] = this.docstatus;
    data['enabled'] = this.enabled;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    data['language'] = this.language;
    data['middle_name'] = this.middleName;
    data['referral_code'] = this.referralCode;
    data['send_welcome_email'] = this.sendWelcomeEmail;
    data['unsubscribed'] = this.unsubscribed;
    data['user_image'] = this.userImage;
    data['gender'] = this.gender;
    data['birth_date'] = this.birthDate;
    data['desk_theme'] = this.deskTheme;
    data['mute_sounds'] = this.muteSounds;
    data['new_password'] = this.newPassword;
    data['logout_all_sessions'] = this.logoutAllSessions;
    data['reset_password_key'] = this.resetPasswordKey;
    data['last_password_reset_date'] = this.lastPasswordResetDate;
    data['redirect_url'] = this.redirectUrl;
    data['document_follow_notify'] = this.documentFollowNotify;
    data['document_follow_frequency'] = this.documentFollowFrequency;
    data['thread_notify'] = this.threadNotify;
    data['send_me_a_copy'] = this.sendMeACopy;
    data['allowed_in_mentions'] = this.allowedInMentions;
    data['simultaneous_sessions'] = this.simultaneousSessions;
    data['last_ip'] = this.lastIp;
    data['login_after'] = this.loginAfter;
    data['user_type'] = this.userType;
    data['last_active'] = this.lastActive;
    data['login_before'] = this.loginBefore;
    data['bypass_restrict_ip_check_if_2fa_enabled'] =
        this.bypassRestrictIpCheckIf2faEnabled;
    data['last_login'] = this.lastLogin;
    data['last_known_versions'] = this.lastKnownVersions;
    data['doctype'] = this.doctype;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    // if (this.userEmails != null) {
    //   data['user_emails'] = this.userEmails!.map((v) => v.toJson()).toList();
    // }
    // if (this.blockModules != null) {
    //   data['block_modules'] =
    //       this.blockModules!.map((v) => v.toJson()).toList();
    // }
    // if (this.defaults != null) {
    //   data['defaults'] = this.defaults!.map((v) => v.toJson()).toList();
    // }
    // if (this.socialLogins != null) {
    //   data['social_logins'] =
    //       this.socialLogins!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Roles {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? role;
  String? doctype;

  Roles(
      {this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.parent,
      this.parentfield,
      this.parenttype,
      this.idx,
      this.docstatus,
      this.role,
      this.doctype});

  Roles.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    role = json['role'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['parent'] = this.parent;
    data['parentfield'] = this.parentfield;
    data['parenttype'] = this.parenttype;
    data['idx'] = this.idx;
    data['docstatus'] = this.docstatus;
    data['role'] = this.role;
    data['doctype'] = this.doctype;
    return data;
  }
}

class SocialLogins {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? provider;
  String? userid;
  String? doctype;

  SocialLogins(
      {this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.parent,
      this.parentfield,
      this.parenttype,
      this.idx,
      this.docstatus,
      this.provider,
      this.userid,
      this.doctype});

  SocialLogins.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    provider = json['provider'];
    userid = json['userid'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['parent'] = this.parent;
    data['parentfield'] = this.parentfield;
    data['parenttype'] = this.parenttype;
    data['idx'] = this.idx;
    data['docstatus'] = this.docstatus;
    data['provider'] = this.provider;
    data['userid'] = this.userid;
    data['doctype'] = this.doctype;
    return data;
  }
}
