class Instructor {
  Data? data;
  String? error;
  
  Instructor({this.data, this.error});

  Instructor.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Instructor.withError(String errorMessage) {
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
  String? instructorEmail;
  String? instructorName;
  String? company;
  String? companyAbbr;
  String? status;
  String? namingSeries;
  String? image;
  String? doctype;
  // List<Null>? instructorSchedule;
  // List<Null>? courseList;
  // List<Null>? instructorLog;

  Data(
      {this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.idx,
      this.docstatus,
      this.instructorEmail,
      this.instructorName,
      this.company,
      this.companyAbbr,
      this.status,
      this.namingSeries,
      this.image,
      this.doctype,
      // this.instructorSchedule,
      // this.courseList,
      // this.instructorLog,
      });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    instructorEmail = json['instructor_email'];
    instructorName = json['instructor_name'];
    company = json['company'];
    companyAbbr = json['company_abbr'];
    status = json['status'];
    namingSeries = json['naming_series'];
    image = json['image'];
    doctype = json['doctype'];
    // if (json['instructor_schedule'] != null) {
    //   instructorSchedule = <Null>[];
    //   json['instructor_schedule'].forEach((v) {
    //     instructorSchedule!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['course_list'] != null) {
    //   courseList = <Null>[];
    //   json['course_list'].forEach((v) {
    //     courseList!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['instructor_log'] != null) {
    //   instructorLog = <Null>[];
    //   json['instructor_log'].forEach((v) {
    //     instructorLog!.add(new Null.fromJson(v));
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
    data['instructor_email'] = this.instructorEmail;
    data['instructor_name'] = this.instructorName;
    data['company'] = this.company;
    data['company_abbr'] = this.companyAbbr;
    data['status'] = this.status;
    data['naming_series'] = this.namingSeries;
    data['image'] = this.image;
    data['doctype'] = this.doctype;
    // if (this.instructorSchedule != null) {
    //   data['instructor_schedule'] =
    //       this.instructorSchedule!.map((v) => v.toJson()).toList();
    // }
    // if (this.courseList != null) {
    //   data['course_list'] = this.courseList!.map((v) => v.toJson()).toList();
    // }
    // if (this.instructorLog != null) {
    //   data['instructor_log'] =
    //       this.instructorLog!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
