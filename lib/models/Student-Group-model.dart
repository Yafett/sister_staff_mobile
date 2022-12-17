class StudentGroup {
  Data? data;
  String? error;

  StudentGroup({this.data, this.error});

  StudentGroup.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  StudentGroup.withError(String errorMessage) {
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
  String? academicYear;
  String? groupBasedOn;
  String? studentGroupName;
  int? maxStrength;
  String? company;
  String? companyAbbr;
  String? programEnrollment;
  String? program;
  int? disabled;
  String? doctype;
  List<Students>? students;
  List<Instructors>? instructors;

  Data(
      {this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.idx,
      this.docstatus,
      this.academicYear,
      this.groupBasedOn,
      this.studentGroupName,
      this.maxStrength,
      this.company,
      this.companyAbbr,
      this.programEnrollment,
      this.program,
      this.disabled,
      this.doctype,
      this.students,
      this.instructors});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    academicYear = json['academic_year'];
    groupBasedOn = json['group_based_on'];
    studentGroupName = json['student_group_name'];
    maxStrength = json['max_strength'];
    company = json['company'];
    companyAbbr = json['company_abbr'];
    programEnrollment = json['program_enrollment'];
    program = json['program'];
    disabled = json['disabled'];
    doctype = json['doctype'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
    if (json['instructors'] != null) {
      instructors = <Instructors>[];
      json['instructors'].forEach((v) {
        instructors!.add(new Instructors.fromJson(v));
      });
    }
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
    data['academic_year'] = this.academicYear;
    data['group_based_on'] = this.groupBasedOn;
    data['student_group_name'] = this.studentGroupName;
    data['max_strength'] = this.maxStrength;
    data['company'] = this.company;
    data['company_abbr'] = this.companyAbbr;
    data['program_enrollment'] = this.programEnrollment;
    data['program'] = this.program;
    data['disabled'] = this.disabled;
    data['doctype'] = this.doctype;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    if (this.instructors != null) {
      data['instructors'] = this.instructors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
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
  String? student;
  String? studentName;
  int? groupRollNumber;
  int? active;
  String? doctype;

  Students(
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
      this.student,
      this.studentName,
      this.groupRollNumber,
      this.active,
      this.doctype});

  Students.fromJson(Map<String, dynamic> json) {
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
    student = json['student'];
    studentName = json['student_name'];
    groupRollNumber = json['group_roll_number'];
    active = json['active'];
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
    data['student'] = this.student;
    data['student_name'] = this.studentName;
    data['group_roll_number'] = this.groupRollNumber;
    data['active'] = this.active;
    data['doctype'] = this.doctype;
    return data;
  }
}

class Instructors {
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
  String? instructor;
  String? instructorName;
  String? doctype;

  Instructors(
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
      this.instructor,
      this.instructorName,
      this.doctype});

  Instructors.fromJson(Map<String, dynamic> json) {
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
    instructor = json['instructor'];
    instructorName = json['instructor_name'];
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
    data['instructor'] = this.instructor;
    data['instructor_name'] = this.instructorName;
    data['doctype'] = this.doctype;
    return data;
  }
}
