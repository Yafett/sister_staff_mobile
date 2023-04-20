// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_string_interpolations

import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class InstructorManagerDetailPage extends StatefulWidget {
  String instructor;
  String instructorName;
  String studentTotal;
  String scheduleTotal;
  var studentList = [];
  var scheduleList = [];

  InstructorManagerDetailPage(
      {super.key,
      required this.instructor,
      required this.studentTotal,
      required this.scheduleTotal,
      required this.instructorName,
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

  ExpandableController expandableController = ExpandableController();

  @override
  void initState() {
    super.initState();
    listRawStudent = widget.studentList;
    listSchedule = widget.scheduleList;
    _fetchStudentProfile();
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
                  image: AssetImage('assets/images/default.jpg'),
                  fit: BoxFit.fitHeight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 250,
                child: Text(widget.instructorName,
                    style: sWhiteTextStyle.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontWeight: semiBold)),
              ),
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
                    Text('${widget.studentList.length.toString()}',
                        style: sWhiteTextStyle.copyWith(fontSize: 16)),
                    Text('Total Student', style: sGreyTextStyle),
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
                Icons.exit_to_app,
                color: sWhiteColor,
                size: 35,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.scheduleList.length.toString()}',
                      style: sWhiteTextStyle.copyWith(fontSize: 16)),
                  Text('Total Attendance', style: sGreyTextStyle),
                ],
              )
            ]),
          ),
        ]),
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
        // controller: expandableController,
        theme: ExpandableThemeData(
          iconColor: sWhiteColor,
          useInkWell: false,
          iconPadding: EdgeInsets.all(0),
          hasIcon: false,
        ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                image: AssetImage('assets/images/default.jpg'),
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['first_name'].toString(),
                              style: sWhiteTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                            ),
                            Text(
                              item['name'].toString(),
                              style: sGreyTextStyle.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExpandableIcon(
                      theme: ExpandableThemeData(iconColor: sWhiteColor),
                    )
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
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: sBlackColor,
                                    contentPadding: EdgeInsets.all(10),
                                    content: Container(
                                      width: double.maxFinite,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: sBlackColor,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      // ! docstatus Chip
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 3,
                                                                horizontal: 10),
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
                                                                style:
                                                                    sWhiteTextStyle
                                                                        .copyWith(
                                                                  fontSize: 14,
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
                                                                horizontal: 10),
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
                                                                        14,
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
                                                  Divider(
                                                    color: sGreyColor,
                                                    height: 20,
                                                  ),
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
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),

                                                  // ! Header 2
                                                  Text(
                                                    schedule['name'].toString(),
                                                    style: sWhiteTextStyle
                                                        .copyWith(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                semiBold),
                                                  ),
                                                  Text(
                                                    schedule['creation'],
                                                    style:
                                                        sGreyTextStyle.copyWith(
                                                      fontSize: 16,
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
                                                            fontSize: 12,
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
                                                    style:
                                                        sGreyTextStyle.copyWith(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Lesson :',
                                                    style: sWhiteTextStyle
                                                        .copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                semiBold),
                                                  ),
                                                  Text(
                                                    schedule['lesson']
                                                        .toString(),
                                                    style:
                                                        sGreyTextStyle.copyWith(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Video URL :',
                                                    style: sWhiteTextStyle
                                                        .copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                semiBold),
                                                  ),
                                                  Text(
                                                    schedule['video_url']
                                                                .toString() ==
                                                            ''
                                                        ? '-'
                                                        : schedule['video_url']
                                                            .toString(),
                                                    style:
                                                        sGreyTextStyle.copyWith(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: sGreyColor,
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      RatingBar.builder(
                                                        itemSize: 30,
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
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              166,
                                                              170),
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {},
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ]),
                                    ),
                                  );
                                },
                              );
                              // showDialog(
                              //     context: context,
                              //     useSafeArea: true,
                              //     builder: (_) => ConstrainedBox(
                              //           constraints:
                              //               BoxConstraints(maxWidth: 1000000),
                              //           child: AlertDialog(
                              //             actionsPadding: EdgeInsets.all(0),
                              //             contentPadding: EdgeInsets.all(10),
                              //             backgroundColor: sBlackColor,
                              //             shape: RoundedRectangleBorder(
                              //                 borderRadius: BorderRadius.all(
                              //                     Radius.circular(8))),
                              //             content: Builder(
                              //               builder: (context) {
                              //                 var height =
                              //                     MediaQuery.of(context)
                              //                         .size
                              //                         .height;
                              //                 var width = MediaQuery.of(context)
                              //                     .size
                              //                     .width;

                              //               },
                              //             ),
                              //           ),
                              //         ));
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
        .post("https://${baseUrl}.sekolahmusik.co.id/api/method/login", data: {
      'usr': 'administrator',
      'pwd': 'admin',
    });

    log(listRawStudent.toString());

    for (var a = 0; a < listRawStudent.length; a++) {
      final getStudent = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Student/${listRawStudent[a]}');

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
