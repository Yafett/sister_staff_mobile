class Leave {
  Data? data;
  String? error;

  Leave({this.data, this.error});

  Leave.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Leave.withError(String errorMessage) {
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
  String? workflowState;
  String? namingSeries;
  String? employee;
  String? employeeName;
  String? leaveType;
  String? department;
  double? leaveBalance;
  String? fromDate;
  String? toDate;
  int? halfDay;
  double? totalLeaveDays;
  String? description;
  String? leaveApprover;
  String? leaveApproverName;
  String? status;
  String? postingDate;
  int? followViaEmail;
  String? company;
  String? letterHead;
  String? doctype;

  Data(
      {this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.idx,
      this.docstatus,
      this.workflowState,
      this.namingSeries,
      this.employee,
      this.employeeName,
      this.leaveType,
      this.department,
      this.leaveBalance,
      this.fromDate,
      this.toDate,
      this.halfDay,
      this.totalLeaveDays,
      this.description,
      this.leaveApprover,
      this.leaveApproverName,
      this.status,
      this.postingDate,
      this.followViaEmail,
      this.company,
      this.letterHead,
      this.doctype});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    workflowState = json['workflow_state'];
    namingSeries = json['naming_series'];
    employee = json['employee'];
    employeeName = json['employee_name'];
    leaveType = json['leave_type'];
    department = json['department'];
    leaveBalance = json['leave_balance'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    halfDay = json['half_day'];
    totalLeaveDays = json['total_leave_days'];
    description = json['description'];
    leaveApprover = json['leave_approver'];
    leaveApproverName = json['leave_approver_name'];
    status = json['status'];
    postingDate = json['posting_date'];
    followViaEmail = json['follow_via_email'];
    company = json['company'];
    letterHead = json['letter_head'];
    doctype = json['doctype'];
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
    data['workflow_state'] = this.workflowState;
    data['naming_series'] = this.namingSeries;
    data['employee'] = this.employee;
    data['employee_name'] = this.employeeName;
    data['leave_type'] = this.leaveType;
    data['department'] = this.department;
    data['leave_balance'] = this.leaveBalance;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['half_day'] = this.halfDay;
    data['total_leave_days'] = this.totalLeaveDays;
    data['description'] = this.description;
    data['leave_approver'] = this.leaveApprover;
    data['leave_approver_name'] = this.leaveApproverName;
    data['status'] = this.status;
    data['posting_date'] = this.postingDate;
    data['follow_via_email'] = this.followViaEmail;
    data['company'] = this.company;
    data['letter_head'] = this.letterHead;
    data['doctype'] = this.doctype;
    return data;
  }
}
