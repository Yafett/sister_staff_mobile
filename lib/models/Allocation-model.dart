class Allocation {
  Data? data;
  String? error;

  Allocation({this.data, this.error});

  Allocation.withError(String errorMessage) {
    error = errorMessage;
  }

  Allocation.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  String? namingSeries;
  String? employee;
  String? employeeName;
  String? department;
  String? company;
  String? leaveType;
  String? fromDate;
  String? toDate;
  double? newLeavesAllocated;
  int? carryForward;
  double? unusedLeaves;
  double? totalLeavesAllocated;
  double? totalLeavesEncashed;
  double? carryForwardedLeavesCount;
  int? expired;
  String? doctype;

  Data(
      {this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.idx,
      this.docstatus,
      this.namingSeries,
      this.employee,
      this.employeeName,
      this.department,
      this.company,
      this.leaveType,
      this.fromDate,
      this.toDate,
      this.newLeavesAllocated,
      this.carryForward,
      this.unusedLeaves,
      this.totalLeavesAllocated,
      this.totalLeavesEncashed,
      this.carryForwardedLeavesCount,
      this.expired,
      this.doctype});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    namingSeries = json['naming_series'];
    employee = json['employee'];
    employeeName = json['employee_name'];
    department = json['department'];
    company = json['company'];
    leaveType = json['leave_type'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    newLeavesAllocated = json['new_leaves_allocated'];
    carryForward = json['carry_forward'];
    unusedLeaves = json['unused_leaves'];
    totalLeavesAllocated = json['total_leaves_allocated'];
    totalLeavesEncashed = json['total_leaves_encashed'];
    carryForwardedLeavesCount = json['carry_forwarded_leaves_count'];
    expired = json['expired'];
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
    data['naming_series'] = this.namingSeries;
    data['employee'] = this.employee;
    data['employee_name'] = this.employeeName;
    data['department'] = this.department;
    data['company'] = this.company;
    data['leave_type'] = this.leaveType;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['new_leaves_allocated'] = this.newLeavesAllocated;
    data['carry_forward'] = this.carryForward;
    data['unused_leaves'] = this.unusedLeaves;
    data['total_leaves_allocated'] = this.totalLeavesAllocated;
    data['total_leaves_encashed'] = this.totalLeavesEncashed;
    data['carry_forwarded_leaves_count'] = this.carryForwardedLeavesCount;
    data['expired'] = this.expired;
    data['doctype'] = this.doctype;
    return data;
  }
}
