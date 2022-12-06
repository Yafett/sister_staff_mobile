// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sister_staff_mobile/bloc/leave-application/get_leave_application_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-employee/get_profile_employee_bloc.dart';
import 'package:sister_staff_mobile/models/Employee-model.dart';
import 'package:sister_staff_mobile/pages/auth/profile-page.dart';
import 'package:sister_staff_mobile/pages/auth/splash-page.dart';
import 'package:sister_staff_mobile/pages/employee/leave-app/leave-page.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  bool isOpened = false;
  final dio = Dio();
  final _employeeBloc = GetProfileEmployeeBloc();
  final _leaveBloc = GetLeaveApplicationBloc();

  @override
  void initState() {
    super.initState();
    _employeeBloc.add(GetProfileEmployeeList());
    _leaveBloc.add(GetLeaveApplicationList());
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return BlocBuilder<GetProfileEmployeeBloc, GetProfileEmployeeState>(
      bloc: _employeeBloc,
      builder: (context, state) {
        if (state is GetProfileEmployeeLoaded) {
          Employee employee = state.employeeModel;
          return SideMenu(
            key: _endSideMenuKey,
            inverse: true, // end side menu
            background: Colors.green[700],
            type: SideMenuType.slideNRotate,
            menu: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: _buildSidebar(),
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
              menu: _buildSidebar(),
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
                    backgroundColor: const Color(0xff0D1117),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
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
                          _buildProfileTitle(employee.data),
                          _buildProfileChip(),
                          SizedBox(height: 10),
                          _buildAttendanceSection(),
                          SizedBox(height: 10),
                          _buildLeaveSection(),
                          SizedBox(height: 10),
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

  Widget _buildSidebar() {
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
                  'Hello,  ',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.person_outline,
                size: 20.0, color: Colors.white),
            title: const Text("Profile"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.date_range, size: 20.0, color: Colors.white),
            title: const Text("Schedule"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.paragliding_outlined,
                size: 20.0, color: Colors.white),
            title: const Text("Leave"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
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
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      },
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DigitalClock(
                    areaHeight: 0,
                    areaDecoration: const BoxDecoration(
                      color: const Color(0xff0D1117),
                    ),
                    hourMinuteDigitDecoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff0D1117))),
                    areaWidth: 0,
                    digitAnimationStyle: Curves.elasticOut,
                    showSecondsDigit: false,
                    hourMinuteDigitTextStyle: const TextStyle(
                      color: Color(0xff0D1117),
                      fontSize: 0,
                    ),
                  ),

                  // ! real clock
                  Container(
                    child: DigitalClock(
                        areaDecoration: const BoxDecoration(
                          color: const Color(0xff0D1117),
                        ),
                        areaWidth: 115,
                        showSecondsDigit: false,
                        hourMinuteDigitDecoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff0D1117))),
                        hourMinuteDigitTextStyle: sWhiteTextStyle.copyWith(
                          fontSize: 40,
                        )),
                  ),
                  Text(
                    _setCurrentDate(),
                    style: sWhiteTextStyle,
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildProfileTitle(employee) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${employee.firstName.toString().toLowerCase()} !',
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
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Chip(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xff30363D))),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              backgroundColor: const Color(0xff272C33),
              avatar: Icon(Icons.star, color: sWhiteColor, size: 15),
              deleteIcon: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: sWhiteColor,
              ),
              label: Text(
                'Test',
                style: sWhiteTextStyle.copyWith(fontSize: 16),
              ),
              deleteButtonTooltipMessage: 'erase',
              onDeleted: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveSection() {
    return BlocBuilder<GetLeaveApplicationBloc, GetLeaveApplicationState>(
      bloc: _leaveBloc,
      builder: (context, state) {
        if (state is GetLeaveApplicationLoaded) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave',
                    style: sWhiteTextStyle,
                  ),
                  const SizedBox(height: 5),
                  Material(
                    color: sBlackColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeaveApplicationPage()));
                      },
                      splashColor: const Color(0xff30363D),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [],
                              ),
                              Text('Cuti',
                                  style: sGreenTextStyle.copyWith(
                                      fontSize: 16, fontWeight: semi)),
                              Text('Wednesday, 20 January',
                                  style: sWhiteTextStyle.copyWith(
                                      fontSize: 20, fontWeight: semiBold)),
                              Text('ke luar kota',
                                  style: sGreyTextStyle.copyWith(
                                      fontSize: 16, fontWeight: semiBold)),
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
                                    'See your Leave List',
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

  Widget _buildAttendanceSection() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance',
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
                  Navigator.pushNamed(context, '/student-schedule');
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
                        Text("There's no Schedule avaliable",
                            style: sGreyTextStyle.copyWith(fontSize: 22)),
                        SizedBox(),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xff272C33),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'See your Attendance',
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

  // ! setting Data
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
