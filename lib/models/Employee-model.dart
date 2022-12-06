class Employee {
  Data? data;
  String? error;

  Employee({this.data, this.error});

  Employee.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null; 
  }

  Employee.withError(String errorMessage) {
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
  String? employee;
  String? namingSeries;
  String? firstName;
  String? middleName;
  String? lastName;
  String? salutation;
  String? employeeName;
  String? employmentType;
  String? company;
  String? status;
  String? gender;
  String? dateOfBirth;
  String? dateOfJoining;
  String? relation;
  String? userId;
  int? createUserPermission;
  int? noticeNumberOfDays;
  String? dateOfRetirement;
  String? department;
  String? reportsTo;
  String? leaveApprover;
  String? salaryMode;
  String? preferedEmail;
  int? unsubscribed;
  String? permanentAccommodationType;
  String? preferedContactEmail;
  String? currentAccommodationType;
  String? maritalStatus;
  String? bloodGroup;
  String? leaveEncashed;
  int? lft;
  int? rgt;
  String? oldParent;
  String? doctype;
  // List<Null>? education;
  // List<Null>? externalWorkHistory;
  // List<Null>? internalWorkHistory;

  Data({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.idx,
    this.docstatus,
    this.employee,
    this.namingSeries,
    this.firstName,
    this.middleName,
    this.lastName,
    this.salutation,
    this.employeeName,
    this.employmentType,
    this.company,
    this.status,
    this.gender,
    this.dateOfBirth,
    this.dateOfJoining,
    this.relation,
    this.userId,
    this.createUserPermission,
    this.noticeNumberOfDays,
    this.dateOfRetirement,
    this.department,
    this.reportsTo,
    this.leaveApprover,
    this.salaryMode,
    this.preferedEmail,
    this.unsubscribed,
    this.permanentAccommodationType,
    this.preferedContactEmail,
    this.currentAccommodationType,
    this.maritalStatus,
    this.bloodGroup,
    this.leaveEncashed,
    this.lft,
    this.rgt,
    this.oldParent,
    this.doctype,
    // this.education,
    // this.externalWorkHistory,
    // this.internalWorkHistory,
  });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    employee = json['employee'];
    namingSeries = json['naming_series'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    salutation = json['salutation'];
    employeeName = json['employee_name'];
    employmentType = json['employment_type'];
    company = json['company'];
    status = json['status'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    dateOfJoining = json['date_of_joining'];
    relation = json['relation'];
    userId = json['user_id'];
    createUserPermission = json['create_user_permission'];
    noticeNumberOfDays = json['notice_number_of_days'];
    dateOfRetirement = json['date_of_retirement'];
    department = json['department'];
    reportsTo = json['reports_to'];
    leaveApprover = json['leave_approver'];
    salaryMode = json['salary_mode'];
    preferedEmail = json['prefered_email'];
    unsubscribed = json['unsubscribed'];
    permanentAccommodationType = json['permanent_accommodation_type'];
    preferedContactEmail = json['prefered_contact_email'];
    currentAccommodationType = json['current_accommodation_type'];
    maritalStatus = json['marital_status'];
    bloodGroup = json['blood_group'];
    leaveEncashed = json['leave_encashed'];
    lft = json['lft'];
    rgt = json['rgt'];
    oldParent = json['old_parent'];
    doctype = json['doctype'];
    // if (json['education'] != null) {
    //   education = <Null>[];
    //   json['education'].forEach((v) {
    //     education!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['external_work_history'] != null) {
    //   externalWorkHistory = <Null>[];
    //   json['external_work_history'].forEach((v) {
    //     externalWorkHistory!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['internal_work_history'] != null) {
    //   internalWorkHistory = <Null>[];
    //   json['internal_work_history'].forEach((v) {
    //     internalWorkHistory!.add(new Null.fromJson(v));
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
    data['employee'] = this.employee;
    data['naming_series'] = this.namingSeries;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['salutation'] = this.salutation;
    data['employee_name'] = this.employeeName;
    data['employment_type'] = this.employmentType;
    data['company'] = this.company;
    data['status'] = this.status;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['date_of_joining'] = this.dateOfJoining;
    data['relation'] = this.relation;
    data['user_id'] = this.userId;
    data['create_user_permission'] = this.createUserPermission;
    data['notice_number_of_days'] = this.noticeNumberOfDays;
    data['date_of_retirement'] = this.dateOfRetirement;
    data['department'] = this.department;
    data['reports_to'] = this.reportsTo;
    data['leave_approver'] = this.leaveApprover;
    data['salary_mode'] = this.salaryMode;
    data['prefered_email'] = this.preferedEmail;
    data['unsubscribed'] = this.unsubscribed;
    data['permanent_accommodation_type'] = this.permanentAccommodationType;
    data['prefered_contact_email'] = this.preferedContactEmail;
    data['current_accommodation_type'] = this.currentAccommodationType;
    data['marital_status'] = this.maritalStatus;
    data['blood_group'] = this.bloodGroup;
    data['leave_encashed'] = this.leaveEncashed;
    data['lft'] = this.lft;
    data['rgt'] = this.rgt;
    data['old_parent'] = this.oldParent;
    data['doctype'] = this.doctype;
    // if (this.education != null) {
    //   data['education'] = this.education!.map((v) => v.toJson()).toList();
    // }
    // if (this.externalWorkHistory != null) {
    //   data['external_work_history'] =
    //       this.externalWorkHistory!.map((v) => v.toJson()).toList();
    // }
    // if (this.internalWorkHistory != null) {
    //   data['internal_work_history'] =
    //       this.internalWorkHistory!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
