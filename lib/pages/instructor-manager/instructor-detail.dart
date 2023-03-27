import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/models/Schedule-model.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class InstructorManagerDetailPage extends StatefulWidget {
  String instructor;
  var studentList = [];
  var scheduleList = [];

  InstructorManagerDetailPage(
      {super.key,
      required this.instructor,
      required this.studentList,
      required this.scheduleList});

  @override
  State<InstructorManagerDetailPage> createState() =>
      _InstructorManagerDetailPageState();
}

class _InstructorManagerDetailPageState
    extends State<InstructorManagerDetailPage> {
  var listRawStudent = [];
  var listStudent = [];
  var listSchedule = [];

  @override
  void initState() {
    super.initState();
    listRawStudent = widget.studentList;
    listSchedule = widget.scheduleList;
    log(listSchedule.toString());
    _fetchStudentProfile();

    log(widget.scheduleList.length.toString());
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
              _buildInstructorProfile(),
              SizedBox(height: 10),
              _buildAttendanceInfo(),
              _buildInstructorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructorProfile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                  image: AssetImage('assets/images/staff-profile.jpg'),
                  fit: BoxFit.fitHeight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GUNSLINGER',
                  style: sWhiteTextStyle.copyWith(
                      fontSize: 20, fontWeight: semiBold)),
              Text(
                widget.instructor,
                style: sGreyTextStyle,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAttendanceInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color(0xff30363D),
        ),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.person_2_outlined,
                    color: sWhiteColor,
                    size: 30,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('12', style: sWhiteTextStyle.copyWith(fontSize: 16)),
                      Text('Total Student', style: sGreyTextStyle),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 10),
            Container(
              child: Row(children: [
                Icon(
                  Icons.exit_to_app,
                  color: sWhiteColor,
                  size: 30,
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('123', style: sWhiteTextStyle.copyWith(fontSize: 16)),
                    Text('Total Attendance', style: sGreyTextStyle),
                  ],
                )
              ]),
            ),
            SizedBox(width: 10),
            Container(
              child: Row(children: [
                Icon(
                  Icons.content_paste_off_sharp,
                  color: sWhiteColor,
                  size: 30,
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('12', style: sWhiteTextStyle.copyWith(fontSize: 16)),
                    Text('Total Absent', style: sGreyTextStyle),
                  ],
                )
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildInstructorList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          ...listStudent.map((item) {
            return _buildStudentCard(item['data']);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStudentCard(item) {
    return ExpandablePanel(
        theme: ExpandableThemeData(
            useInkWell: false, iconPadding: EdgeInsets.all(0), hasIcon: false),
        header: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            Material(
              color: sBlackColor,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xff30363D),
                    border: Border.all(
                      color: const Color(0xff30363D),
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/staff-profile.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['first_name'].toString(),
                          style: sWhiteTextStyle.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          item['name'].toString(),
                          style: sGreyTextStyle.copyWith(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        collapsed: Container(),
        expanded: Column(
          children: [
            ...listSchedule.map((schedule) {
              // ! Date
              var rawDate = schedule['date'].toString().replaceAll('-', '');
              String date = DateFormat('EE, dd MMMM yyyy')
                  .format(DateTime.parse(rawDate.substring(0, 8)));

              // !

              return schedule['student'].toString() == item['name']
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  anchorPoint: Offset(0, 0),
                                  context: context,
                                  builder: (_) => ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 10000),
                                        child: AlertDialog(
                                          contentPadding: EdgeInsets.all(10),
                                          backgroundColor: sBlackColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          content: Builder(
                                            builder: (context) {
                                              var height =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height;
                                              var width = MediaQuery.of(context)
                                                  .size
                                                  .width;

                                              return Container(
                                                height: height / 2.2,
                                                width: 10000,
                                                decoration: BoxDecoration(
                                                  color: sBlackColor,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // ! Header
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              date.toString(),
                                                              style:
                                                                  sWhiteTextStyle
                                                                      .copyWith(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    semiBold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${schedule['from_time'].toString() != 'null' ? DateFormat.jm().format(DateFormat("hh:mm:ss").parse(schedule['from_time'].toString())).toString() : '-'} - ${schedule['to_time'].toString() != 'null' ? DateFormat.jm().format(DateFormat("hh:mm:ss").parse(schedule['to_time'].toString())).toString() : '-'}',
                                                              style:
                                                                  sGreyTextStyle
                                                                      .copyWith(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    semiBold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        // ! docstatus Chip
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: schedule['docstatus']
                                                                          .toString() !=
                                                                      '2'
                                                                  ? Color(
                                                                      0xff384D4B)
                                                                  : Color(
                                                                      0xff4D3838)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  _setDocstatusText(
                                                                      schedule[
                                                                          'docstatus']),
                                                                  style: sWhiteTextStyle
                                                                      .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    color: _setDocstatusColor(
                                                                        schedule[
                                                                            'docstatus']),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),

                                                        // ! status Chip
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: schedule['status']
                                                                          .toString() ==
                                                                      'Present'
                                                                  ? Color(
                                                                      0xff384D4B)
                                                                  : Color(
                                                                      0xff4D3838)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  schedule[
                                                                      'status'],
                                                                  style: sWhiteTextStyle.copyWith(
                                                                      fontSize:
                                                                          16,
                                                                      color: schedule['status'].toString() ==
                                                                              'Present'
                                                                          ? Color(
                                                                              0xff70C5AF)
                                                                          : Color(
                                                                              0xffC57070)))
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 20),
                                                    // ! Header 2
                                                    Text(
                                                      schedule['name']
                                                          .toString(),
                                                      style: sWhiteTextStyle
                                                          .copyWith(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  semiBold),
                                                    ),
                                                    Text(
                                                      schedule['creation'],
                                                      style: sGreyTextStyle
                                                          .copyWith(
                                                        fontSize: 18,
                                                      ),
                                                    ),

                                                    Divider(
                                                      color: sGreyColor,
                                                      height: 20,
                                                    ),

                                                    Text(
                                                      'Comment :',
                                                      style: sWhiteTextStyle
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  semiBold),
                                                    ),
                                                    Text(
                                                      schedule['comment']
                                                                  .toString() ==
                                                              ''
                                                          ? '-'
                                                          : schedule['comment']
                                                              .toString(),
                                                      style: sGreyTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Lesson :',
                                                      style: sWhiteTextStyle
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  semiBold),
                                                    ),
                                                    Text(
                                                      schedule['lesson']
                                                          .toString(),
                                                      style: sGreyTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Video URL :',
                                                      style: sWhiteTextStyle
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  semiBold),
                                                    ),
                                                    Text(
                                                      schedule['video_url']
                                                                  .toString() ==
                                                              ''
                                                          ? '-'
                                                          : schedule[
                                                                  'video_url']
                                                              .toString(),
                                                      style: sGreyTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        RatingBar.builder(
                                                          ignoreGestures: true,
                                                          itemPadding:
                                                              EdgeInsets.all(0),
                                                          glowColor: sGreyColor,
                                                          initialRating: schedule[
                                                              'growth_point'],
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xff6B7178),
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {},
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ));
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff30363D),
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.watch_later_outlined,
                                                color: sWhiteColor,
                                                size: 25,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                date.toString(),
                                                style: sWhiteTextStyle.copyWith(
                                                    fontSize: 18,
                                                    fontWeight: semiBold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: schedule['status']
                                                          .toString() ==
                                                      'Present'
                                                  ? Color(0xff384D4B)
                                                  : Color(0xff4D3838)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(schedule['status'],
                                                  style: sWhiteTextStyle.copyWith(
                                                      fontSize: 16,
                                                      color: schedule['status']
                                                                  .toString() ==
                                                              'Present'
                                                          ? Color(0xff70C5AF)
                                                          : Color(0xffC57070)))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 50),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'From Time',
                                                style: sGreyTextStyle.copyWith(
                                                    fontSize: 12,
                                                    color: Color(0xff98A4B1)),
                                              ),
                                              Text(
                                                schedule['from_time']
                                                            .toString() !=
                                                        'null'
                                                    ? DateFormat.jm()
                                                        .format(DateFormat(
                                                                "hh:mm:ss")
                                                            .parse(schedule[
                                                                    'from_time']
                                                                .toString()))
                                                        .toString()
                                                    : '-',
                                                style: sWhiteTextStyle.copyWith(
                                                  fontSize: 18,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'To Time',
                                                style: sGreyTextStyle.copyWith(
                                                    fontSize: 12,
                                                    color: Color(0xff98A4B1)),
                                              ),
                                              // SizedBox(height: 5),
                                              Text(
                                                schedule['to_time']
                                                            .toString() !=
                                                        'null'
                                                    ? DateFormat.jm()
                                                        .format(DateFormat(
                                                                "hh:mm:ss")
                                                            .parse(schedule[
                                                                    'to_time']
                                                                .toString()))
                                                        .toString()
                                                    : '-',
                                                style: sWhiteTextStyle.copyWith(
                                                  fontSize: 18,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )
                  : Container();
            }).toList(),
          ],
        ));
  }

  _fetchStudentProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final dio = Dio();
    final cookieJar = CookieJar();

    var user = pref.getString('username');
    var pass = pref.getString('password');

    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio
        .post("https://njajal.sekolahmusik.co.id/api/method/login", data: {
      'usr': user,
      'pwd': pass,
    });

    for (var a = 0; a < listRawStudent.length; a++) {
      final getStudent = await dio.get(
          'https://njajal.sekolahmusik.co.id/api/resource/Student/${listRawStudent[a]}');

      if (mounted) {
        setState(() {
          listStudent.add(getStudent.data);
        });
      }

      log(getStudent.data.toString());
    }
  }

  _setDocstatusText(schedule) {
    if (schedule.toString() == '0') {
      return 'Draft';
    } else if (schedule.toString() == '1') {
      return 'Submitted';
    } else if (schedule.toString() == '2') {
      return 'Canceled';
    }
  }

  _setDocstatusColor(schedule) {
    if (schedule.toString() == '0') {
      return Color(0xff70C5AF);
    } else if (schedule.toString() == '1') {
      return Color(0xff70C5AF);
    } else if (schedule.toString() == '2') {
      return Color(0xffC57070);
    }
  }
}