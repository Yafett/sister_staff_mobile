// ignore_for_file: prefer_is_empty, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sister_staff_mobile/bloc/instructor-schedule/instructor_schedule_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-employee/get_profile_employee_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-instructor/get_profile_instructor_bloc.dart';
import 'package:sister_staff_mobile/bloc/student-group/student_group_bloc.dart';
import 'package:sister_staff_mobile/models/Instructor-model.dart';
import 'package:sister_staff_mobile/models/Schedule-model.dart';
import 'package:sister_staff_mobile/models/Student-Group-model.dart';
import 'package:sister_staff_mobile/pages/auth/profile-page.dart';
import 'package:sister_staff_mobile/pages/auth/splash-page.dart';
import 'package:sister_staff_mobile/pages/instructor-manager/instructor-list.dart';
import 'package:sister_staff_mobile/pages/instructor/schedule/schedule-page.dart';
import 'package:sister_staff_mobile/pages/instructor/student-group/student-group-list.dart';
import 'package:sister_staff_mobile/pages/instructor/student/student-list-page.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class InstructorPage extends StatefulWidget {
  bool? manager;
  InstructorPage({super.key, this.manager});

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

class _InstructorPageState extends State<InstructorPage> {
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  bool isOpened = false;
  final dio = Dio();
  final _employeeBloc = GetProfileEmployeeBloc();
  final _instructorBloc = GetProfileInstructorBloc();
  final _scheduleBloc = InstructorScheduleBloc();
  final _studentGroupBloc = StudentGroupBloc();
  var studentlength;
  var sgrouplength;
  var schedulelength;

  @override
  void initState() {
    _employeeBloc.add(GetProfileEmployeeList());
    _instructorBloc.add(GetProfileInstructorList());
    _scheduleBloc.add(GetScheduleList());
    _studentGroupBloc.add(GetStudentGroupList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return BlocBuilder<GetProfileInstructorBloc, GetProfileInstructorState>(
      bloc: _instructorBloc,
      builder: (context, state) {
        if (state is GetProfileInstructorLoaded) {
          Instructor instructor = state.instructorModel;
          return SideMenu(
            key: _endSideMenuKey,
            inverse: true, // end side menu
            background: Colors.green[700],
            type: SideMenuType.slideNRotate,
            menu: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: _buildSidebar(instructor),
            ),
            maxMenuWidth: 250,
            onChange: (_isOpened) {
              if (mounted) {
                setState(() => isOpened = _isOpened);
              }
            },
            child: SideMenu(
              maxMenuWidth: 250,
              radius: BorderRadius.circular(12),
              background: const Color.fromARGB(255, 41, 41, 41),
              key: _sideMenuKey,
              menu: _buildSidebar(instructor),
              type: SideMenuType.slideNRotate,
              onChange: (_isOpened) {
                if (mounted) {
                  setState(() => isOpened = _isOpened);
                }
              },
              child: IgnorePointer(
                ignoring: isOpened,
                child: Scaffold(
                  backgroundColor: const Color(0xff0D1117),
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: const Color(0xff0D1117),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                      ),
                      onPressed: () => _setToggleMenu(),
                    ),
                    actions: const [
                      Icon(Icons.qr_code_scanner,
                          size: 30, color: Color(0xffC9D1D9)),
                      SizedBox(width: 20),
                    ],
                  ),
                  body: ScrollConfiguration(
                    behavior: NoScrollWaves(),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfilePicture(),
                          _buildProfileTitle(instructor.data),
                          _buildProfileChip(),
                          _buildStudentSection(instructor.data),
                          widget.manager == true
                              ? _buildInstructorSection()
                              : Container(),
                          _buildStudentGroupSection(),
                          _buildScheduleSection(),
                          // const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSidebar(instructor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22.0,
                  backgroundImage:
                      AssetImage('assets/images/smi-logo-white.png'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Hello, ${instructor.data.instructorName.toString()}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(instructor: true)));
            },
            leading: const Icon(Icons.person_outline,
                size: 20.0, color: Colors.white),
            title: const Text("Profile"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentListPage(
                            code: instructor.instructorEmail.toString(),
                          )));
            },
            leading: const Icon(Icons.location_history_outlined,
                size: 20.0, color: Colors.white),
            title: const Text("Student"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentGroupListPage()));
            },
            leading: const Icon(Icons.group_outlined,
                size: 20.0, color: Colors.white),
            title: const Text("Student Group"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () async {
              await dio
                  .get('https://sister.sekolahmusik.co.id/api/method/logout');
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashPage()),
                  (route) => false);
            },
            leading:
                const Icon(Icons.exit_to_app, size: 20.0, color: Colors.white),
            title: const Text("Logout"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(instructor: true)));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(instructor: true)));
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/staff-profile.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     DigitalClock(
              //       areaHeight: 0,
              //       areaDecoration: const BoxDecoration(
              //         color: const Color(0xff0D1117),
              //       ),
              //       minuteDigitDecoration: BoxDecoration(
              //           border: Border.all(
              //               color: Color.fromARGB(255, 254, 254, 255))),
              //       areaWidth: 0,
              //       digitAnimationStyle: Curves.elasticOut,
              //       showSecondsDigit: false,
              //       hourMinuteDigitTextStyle: const TextStyle(
              //         color: Color(0xff0D1117),
              //         fontSize: 0,
              //       ),
              //     ),

              //     // ! real clock
              //     Container(
              //       child: DigitalClock(
              //           areaDecoration: const BoxDecoration(
              //             color: Color.fromARGB(255, 255, 255, 255),
              //           ),
              //           areaWidth: 100,
              //           showSecondsDigit: false,
              //           minuteDigitDecoration: BoxDecoration(
              //               border: Border.all(color: const Color(0xff0D1117))),
              //           hourMinuteDigitTextStyle: sBlackTextStyle.copyWith(
              //             fontSize: 40,
              //           )),
              //     ),
              //     Text(
              //       _setCurrentDate(),
              //       style: sWhiteTextStyle,
              //     ),
              //   ],
              // ),
            ],
          )),
    );
  }

  Widget _buildProfileTitle(instructor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(instructor: true)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${instructor.instructorName.toString().toLowerCase()}!',
              style:
                  sWhiteTextStyle.copyWith(fontSize: 32, fontWeight: semiBold),
            ),
            Text(
              'welcome and happy working',
              style: sWhiteTextStyle.copyWith(fontSize: 18, fontWeight: semi),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            child:
                _buildChip('${studentlength.toString()} Student', Icons.person),
          ),
          GestureDetector(
            child: _buildChip(
                '${sgrouplength.toString()} Student Group', Icons.group),
          ),
          GestureDetector(
            child: _buildChip(
                '${schedulelength.toString()} Schedule', Icons.group),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xff30363D))),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        backgroundColor: const Color(0xff272C33),
        avatar: Icon(icon, color: sWhiteColor, size: 15),
        deleteIcon: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: sWhiteColor,
        ),
        label: Text(
          label,
          style: sWhiteTextStyle.copyWith(fontSize: 16),
        ),
        deleteButtonTooltipMessage: 'erase',
        onDeleted: () {},
      ),
    );
  }

  Widget _buildStudentSection(instructor) {
    _setStudentTotal();
    return Container(
        margin: EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student',
              style: sWhiteTextStyle,
            ),
            const SizedBox(height: 5),
            Material(
              color: sBlackColor,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: sGreyColor,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentListPage(
                                code: instructor.instructorEmail.toString(),
                              )));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff30363D),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student total',
                            style: sWhiteTextStyle.copyWith(
                                fontSize: 16, fontWeight: semiBold)),
                        Text("${studentlength} Students",
                            style: sWhiteTextStyle.copyWith(fontSize: 22)),
                        const SizedBox(),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xff272C33),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'See your Student List',
                              style: sWhiteTextStyle.copyWith(
                                  fontSize: 14, fontWeight: semiBold),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: sWhiteColor,
                              size: 20,
                            )
                          ],
                        )
                      ]),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildScheduleSection() {
    return BlocBuilder<InstructorScheduleBloc, InstructorScheduleState>(
      bloc: _scheduleBloc,
      builder: (context, state) {
        if (state is InstructorScheduleLoaded) {
          Schedule schedule = state.scheduleModel;
          _setDate(schedule);
          _setScheduleTotal();
          return Container(
              margin: EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule',
                    style: sWhiteTextStyle,
                  ),
                  const SizedBox(height: 5),
                  Material(
                    color: sBlackColor,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashColor: sGreyColor,
                      onTap: () {
                        if (schedule.message!.length != 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedulePage()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff30363D),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Upcoming Class',
                                  style: sWhiteTextStyle.copyWith(
                                      fontSize: 16, fontWeight: semiBold)),
                              (schedule.message!.length == 0)
                                  ? Text("There's no Schedule avaliable",
                                      style:
                                          sGreyTextStyle.copyWith(fontSize: 22))
                                  : Text('${_setDate(schedule)}',
                                      style: sWhiteTextStyle.copyWith(
                                          fontSize: 22, fontWeight: semiBold)),
                              (schedule.message!.length == 0)
                                  ? SizedBox()
                                  : Text(
                                      '${schedule.message![0].fromTime.toString()} - ${_setDatetimeSchedule(schedule.message![0].scheduleDate.toString())}',
                                      style: sGreyTextStyle.copyWith(
                                          fontSize: 14, fontWeight: semiBold)),
                              const Divider(
                                height: 20,
                                thickness: 1,
                                color: Color(0xff272C33),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'See your Schedule',
                                    style: sWhiteTextStyle.copyWith(
                                        fontSize: 14, fontWeight: semiBold),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: sWhiteColor,
                                    size: 20,
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildStudentGroupSection() {
    return BlocConsumer<StudentGroupBloc, StudentGroupState>(
        bloc: _studentGroupBloc,
        listener: (context, state) {
          if (state is StudentGroupLoaded) {
            _setStudentGroupTotal();
            print('loaded ');
          }
        },
        builder: (context, state) {
          if (state is StudentGroupLoaded) {
            StudentGroup sgroup = state.sgroupModel;
            _setStudentGroupTotal();

            return Container(
                margin: EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Group',
                      style: sWhiteTextStyle,
                    ),
                    const SizedBox(height: 5),
                    Material(
                      color: sBlackColor,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        splashColor: sGreyColor,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StudentGroupListPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff30363D),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Participate on',
                                    style: sWhiteTextStyle.copyWith(
                                        fontSize: 16, fontWeight: semiBold)),
                                Text("${sgrouplength.toString()} Group",
                                    style:
                                        sWhiteTextStyle.copyWith(fontSize: 22)),
                                const SizedBox(),
                                const Divider(
                                  height: 20,
                                  thickness: 1,
                                  color: Color(0xff272C33),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'See your Student List',
                                      style: sWhiteTextStyle.copyWith(
                                          fontSize: 14, fontWeight: semiBold),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: sWhiteColor,
                                      size: 20,
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    )
                  ],
                ));
          } else {
            return Container();
          }
        });
  }

  Widget _buildLessonPlan() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lesson Plan',
              style: sWhiteTextStyle,
            ),
            const SizedBox(height: 5),
            Material(
              color: sBlackColor,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: sGreyColor,
                onTap: () {
                  // if (schedule.message!.length != 0) {
                  //   Navigator.pushNamed(context, '/student-schedule');
                  // }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff30363D),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // (schedule.message!.length == 0)
                        //     ?
                        Text("No Lesson avaliable",
                            style: sGreyTextStyle.copyWith(fontSize: 22)),
                        // : Text('${_getDate(schedule)}',
                        //     style: sWhiteTextStyle.copyWith(
                        //         fontSize: 22, fontWeight: semiBold)),
                        // (schedule.message!.length == 0)
                        // ?
                        const SizedBox(),
                        // : Text(
                        //     '${schedule.message![0].fromTime.toString()} - ${_setDatetimeSchedule(schedule.message![0].scheduleDate.toString())}',
                        //     style: sGreyTextStyle.copyWith(
                        //         fontSize: 14, fontWeight: semiBold)),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xff272C33),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'See your Lesson List',
                              style: sWhiteTextStyle.copyWith(
                                  fontSize: 12, fontWeight: semiBold),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: sWhiteColor,
                              size: 20,
                            )
                          ],
                        )
                      ]),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildInstructorSection() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructor',
              style: sWhiteTextStyle,
            ),
            const SizedBox(height: 5),
            Material(
              color: sBlackColor,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: sGreyColor,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstructorGroupPage()));  
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff30363D),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Instructor total',
                            style: sWhiteTextStyle.copyWith(
                                fontSize: 16, fontWeight: semiBold)),
                        Text("${studentlength} Instructor",
                            style: sWhiteTextStyle.copyWith(fontSize: 22)),
                        const SizedBox(),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xff272C33),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'See your Instructor List',
                              style: sWhiteTextStyle.copyWith(
                                  fontSize: 14, fontWeight: semiBold),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: sWhiteColor,
                              size: 20,
                            )
                          ],
                        )
                      ]),
                ),
              ),
            )
          ],
        ));
  }

  _setStudentTotal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      studentlength = pref.getString('student-length');
    });
  }

  _setScheduleTotal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      schedulelength = pref.getString('schedule-length');
    });
  }

  _setDate(schedule) {
    var listDate = [];

    for (var a = 0; a < schedule.message.length; a++) {
      var replacedFrom =
          schedule.message[a].scheduleDate.toString().replaceAll('-', '');
      DateTime now = DateTime.now();
      String dateFromT = replacedFrom.substring(0, 8);
      DateTime fromDateTime = DateTime.parse(dateFromT);

      if (fromDateTime.isAfter(now) == true) {
        var parsedDate = DateTime.parse(schedule.message[a].scheduleDate);
        String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);
        listDate.add(schedule.message[a].course.toString() +
            ' ' +
            formattedDate.toString());
      }
    }

    return listDate.last.toString();
  }

  _setStudentGroupTotal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        sgrouplength = pref.getString('student-group-length');
      });
    }
  }

  _setDatetimeSchedule(schedule) {
    var parsedDate = DateTime.parse(schedule);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);
    return formattedDate;
  }

  _setToggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  _setCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedRawDate =
        "${dateParse.day}-${dateParse.month}-${dateParse.year}";

    var formattedDate = DateFormat("EEE, d MMMM").format(DateTime.now());

    return formattedDate.toString();
  }
}
