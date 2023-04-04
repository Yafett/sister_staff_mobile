import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/pages/instructor-manager/instructor-detail.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class InstructorGroupPage extends StatefulWidget {
  const InstructorGroupPage({super.key});

  @override
  State<InstructorGroupPage> createState() => _InstructorGroupPageState();
}

class _InstructorGroupPageState extends State<InstructorGroupPage> {
  final dio = Dio();
  final cookieJar = CookieJar();

  bool isLoading = true;

  var totalActive;
  var totalLeft;

  var listInstructor = [];

  var listInstructorTemporary = [];

  @override
  void initState() {
    super.initState();
    _fetchTeacherStudentAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xff0D1117),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0D1117),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInstructorDetail(),
              _buildInstructorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructorDetail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color(0xff30363D),
        ),
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            child: Row(
              children: [
                Icon(
                  Icons.person_2_outlined,
                  color: sWhiteColor,
                  size: 35,
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${totalActive.toString() == 'null' ? '0' : totalActive.toString()}',
                        style: sWhiteTextStyle.copyWith(fontSize: 16)),
                    Text('Active Instructor', style: sGreyTextStyle),
                  ],
                )
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 20,
            color: sWhiteColor,
          ),
          Container(
            child: Row(children: [
              Icon(
                Icons.person_off_outlined,
                color: sWhiteColor,
                size: 35,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${totalLeft.toString() == 'null' ? '0' : totalLeft.toString()}',
                      style: sWhiteTextStyle.copyWith(fontSize: 16)),
                  Text('Left Instructor', style: sGreyTextStyle),
                ],
              )
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildInstructorList() {
    if (isLoading == true) {
      return Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Center(
              child: Text('Loading your Instructor Data...',
                  style: sWhiteTextStyle)));
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            ...listInstructorTemporary.map((item) {
              return _buildInstructorCard(item);
            }).toList(),
          ],
        ),
      );
    }
  }

  Widget _buildInstructorCard(instructor) {
    return SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        Material(
          color: sBlackColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashColor: sGreyColor,
            onTap: () {
              _fetchStudentData(
                  instructor['name'], instructor['instructor_name']);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff30363D),
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                              image: AssetImage('assets/images/default.jpg'),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                            )),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.7,
                              child: Text(
                                  instructor['instructor_name'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  softWrap: false,
                                  style: sWhiteTextStyle.copyWith(
                                      fontSize: 16, fontWeight: semiBold)),
                            ),
                            Text(instructor['name'].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: sGreyTextStyle.copyWith(
                                    fontSize: 14, fontWeight: semiBold)),
                            SizedBox(height: 10),
                            Row(children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: (instructor['status'].toString() ==
                                          'Active')
                                      ? Color(0xff237D29)
                                      : Color(0xff242A30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(instructor['status'].toString(),
                                        style: sWhiteTextStyle)
                                  ],
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 0,
                    color: Color(0xff272C33),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'See this Instructors Student List',
                          style: sWhiteTextStyle.copyWith(
                              fontSize: 14, fontWeight: semiBold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: sWhiteColor,
                          size: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _paymentStatusColor(Instructor) {
    if (Instructor == 'Paid') {
      return Color(0xff237D29);
    } else if (Instructor == 'Unpaid') {
      return Color(0xffF8814F);
    } else if (Instructor == 'Cancelled' ||
        Instructor == 'Overdue' ||
        Instructor == 'Draft') {
      return Color(0xffE24C4C);
    } else {
      return Colors.transparent;
    }
  }

  _fetchTeacherStudentAttendance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("username");
    var pass = pref.getString('password');
    var email = pref.getString('instructor-email');
    var company = pref.getString('instructor-company');

    var listCode = [];
    var listMap = [];
    var rawInstructorList = [];

    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio
        .post('https://${baseUrl}.sekolahmusik.co.id/api/method/login', data: {
      'usr': user,
      'pwd': pass,
    });

    // ! Get Teacher List
    final getInstructor = await dio.post(
        'https://${baseUrl}.sekolahmusik.co.id/api/method/smi.api.get_teacher_list',
        data: {
          'manager_email': '${email}',
          'company': '${company}',
        });

    for (var a = 0; a < getInstructor.data['message'].length; a++) {
      if (mounted) {
        setState(() {
          listCode.add(getInstructor.data['message'][a]['name']);
          listInstructorTemporary.add(getInstructor.data['message'][a]);
        });
      }
    }

    var listActive = [];
    var listNotActive = [];
    for (var a = 0; a < listInstructorTemporary.length; a++) {
      if (listInstructorTemporary[a]['status'] == 'Active') {
        listActive.add(listInstructorTemporary[a]['status']);
      } else {
        listNotActive.add(listInstructorTemporary[a]['status']);
      }
    }

    log('Scientist : ${listActive.length.toString()}');
    log('Maine : ${listNotActive.toString()}');

    // ! Get Attendance List
    final getAttendance = await dio.post(
      'https://${baseUrl}.sekolahmusik.co.id/api/method/smi.api.get_teacher_student_attendance_list',
      data: {
        'manager_email': '${email}',
        'company': '${company}',
      },
    );

    for (var a = 0; a < getAttendance.data['message'].length; a++) {
      if (mounted) {
        setState(() {
          listInstructor.add(getAttendance.data['message']);
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
        totalActive = listActive.length.toString();
        totalLeft = listNotActive.length.toString();
      });
    }
  }

  _fetchStudentData(selectedTeacher, teacherName) async {
    var testList = listInstructor[0][selectedTeacher].values.toList();

    var foxList = [];
    var snowList = [];

    // ! total attendace each student
    var rockList = [];

    var burntList = [];

    // ! itung murid
    for (var a = 0; a < testList.length; a++) {
      if (mounted) {
        setState(() {
          foxList.add(testList[a][0]);
        });
      }
    }

    for (var a = 0; a < foxList.length; a++) {
      if (mounted) {
        setState(() {
          snowList.add(foxList[a]);
        });
      }
    }

    for (var a = 0; a < testList.length; a++) {
      for (var b = 0; b < testList[a].length; b++) {
        if (mounted) {
          setState(() {
            burntList.add(testList[a][b]['student'].toString());
            rockList.add(testList[a][b]);
          });
        }
      }
    }

    var seen = Set<String>();

    // ! total student
    var barrierList =
        burntList.where((codename) => seen.add(codename)).toList();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InstructorManagerDetailPage(
                  instructor: selectedTeacher,
                  instructorName: teacherName,
                  studentList: barrierList,
                  scheduleList: rockList,
                  studentTotal: barrierList.length.toString(),
                  scheduleTotal: rockList.length.toString(),
                )));
  }
}
