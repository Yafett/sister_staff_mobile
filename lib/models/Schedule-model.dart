class Schedule {
  List<Message>? message;
  String? error;

  Schedule({this.message, this.error});

  Schedule.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
  }

  Schedule.withError(String errorMessage) {
    error = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? name;
  String? studentGroup;
  String? instructor;
  String? instructorName;
  String? course;
  String? color;
  String? scheduleDate;
  String? room;
  String? fromTime;
  String? toTime;
  String? title;
  String? status;
  String? program;
  Null? attendanceStatus;
  String? company;

  Message(
      {this.name,
      this.studentGroup,
      this.instructor,
      this.instructorName,
      this.course,
      this.color,
      this.scheduleDate,
      this.room,
      this.fromTime,
      this.toTime,
      this.title,
      this.status,
      this.program,
      this.attendanceStatus,
      this.company});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    studentGroup = json['student_group'];
    instructor = json['instructor'];
    instructorName = json['instructor_name'];
    course = json['course'];
    color = json['color'];
    scheduleDate = json['schedule_date'];
    room = json['room'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    title = json['title'];
    status = json['status'];
    program = json['program'];
    attendanceStatus = json['attendance_status'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['student_group'] = this.studentGroup;
    data['instructor'] = this.instructor;
    data['instructor_name'] = this.instructorName;
    data['course'] = this.course;
    data['color'] = this.color;
    data['schedule_date'] = this.scheduleDate;
    data['room'] = this.room;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['title'] = this.title;
    data['status'] = this.status;
    data['program'] = this.program;
    data['attendance_status'] = this.attendanceStatus;
    data['company'] = this.company;
    return data;
  }
}
