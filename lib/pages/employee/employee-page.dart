// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sister_staff_mobile/bloc/leave-allocation/get_leave_allocation_bloc.dart';
import 'package:sister_staff_mobile/bloc/leave-application/get_leave_application_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-employee/get_profile_employee_bloc.dart';
import 'package:sister_staff_mobile/models/Employee-model.dart';
import 'package:sister_staff_mobile/models/Leave-model.dart';
import 'package:sister_staff_mobile/pages/auth/profile-page.dart';
import 'package:sister_staff_mobile/pages/auth/splash-page.dart';
import 'package:sister_staff_mobile/pages/employee/leave-app/leave-allocation-page.dart';
import 'package:sister_staff_mobile/pages/employee/leave-app/leave-page.dart';
import 'package:sister_staff_mobile/pages/instructor/schedule/schedule-page.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:string_extensions/string_extensions.dart';

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
  final _allocationBloc = GetLeaveAllocationBloc();

  String _scanResult = 'No data yet';

  var leaveLength;
  var allocationLength;

  @override
  void initState() {
    super.initState();
    _getData();
    _employeeBloc.add(GetProfileEmployeeList());
    _leaveBloc.add(GetLeaveApplicationList());
    _allocationBloc.add(GetLeaveAllocationList());
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
          return GestureDetector(
            onTap: () {
              final _state = _endSideMenuKey.currentState!;
              final _state2 = _sideMenuKey.currentState!;

              _state.closeSideMenu();
              _state2.closeSideMenu();
            },
            child: SideMenu(
              key: _endSideMenuKey,
              inverse: true, // end side menu
              background: Colors.green[700],
              type: SideMenuType.slideNRotate,
              menu: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: _buildSidebar(employee),
              ),
              maxMenuWidth: 250,
              onChange: (_isOpened) {
                if (mounted) {
                  setState(() => isOpened = _isOpened);
                }
              },
              child: GestureDetector(
                onTap: () => _setToggleMenu(false),
                child: SideMenu(
                  maxMenuWidth: 250,
                  radius: BorderRadius.circular(12),
                  background: const Color.fromARGB(255, 41, 41, 41),
                  key: _sideMenuKey,
                  menu: _buildSidebar(employee),
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
                          icon: const Icon(Icons.menu, size: 30),
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
                              const SizedBox(height: 5),
                              _buildLeaveSection(),
                              SizedBox(height: 10),
                              // _buildLeaveAllocationSection(),
                            ],
                          ),
                        ),
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

  Widget _buildSidebar(user) {
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
                  backgroundImage: AssetImage('assets/images/default.jpg'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Hello, ${user.data.firstName.toString().capitalize}',
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
            title: const Text("Attendance"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaveApplicationPage()));
            },
            leading: const Icon(Icons.paragliding_outlined,
                size: 20.0, color: Colors.white),
            title: const Text("Leave Application"),
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
                builder: (context) => ProfilePage(
                      instructor: false,
                      employee: true,
                    )));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        image: AssetImage('assets/images/default.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildProfileTitle(employee) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(instructor: false, employee: true)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // margin: const EdgeInsets.only(bottom: 10),
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
              avatar: Icon(Icons.catching_pokemon_outlined,
                  color: sWhiteColor, size: 15),
              deleteIcon: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: sWhiteColor,
              ),
              label: Text(
                '${leaveLength} Leave',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Leave',
            style: sWhiteTextStyle,
          ),
        ),
        BlocBuilder<GetLeaveApplicationBloc, GetLeaveApplicationState>(
          bloc: _leaveBloc,
          builder: (context, state) {
            if (state is GetLeaveApplicationLoaded) {
              Leave leave = state.leaveModel;

              final DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy');

              var rawFrom = DateTime.parse(leave.data!.fromDate.toString());
              final String fromDate = formatter.format(rawFrom);

              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: sBlackColor,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LeaveApplicationPage()));
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
                                  Text(
                                      leave.data!.leaveType.capitalize
                                          .toString(),
                                      style: sGreenTextStyle.copyWith(
                                          fontSize: 16, fontWeight: semi)),
                                  Text(fromDate,
                                      style: sWhiteTextStyle.copyWith(
                                          fontSize: 20, fontWeight: semiBold)),
                                  Text(
                                      (leave.data!.description == null)
                                          ? 'Without Description'
                                          : leave.data!.description.toString(),
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
                                        'See your Leave Application',
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
                      ),
                    ],
                  ));
            } else {
              return Container(
                margin: EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                  color: sBlackColor,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    splashColor: sGreyColor,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SchedulePage()));
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
                            Text("There's no Leave avaliable",
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
                                  'See your Leave Application',
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
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildLeaveAllocationSection() {
    _getData();

    return BlocConsumer<GetLeaveAllocationBloc, GetLeaveAllocationState>(
      bloc: _allocationBloc,
      listener: (context, state) async {
        final pref = await SharedPreferences.getInstance();

        if (mounted) {
          setState(() {
            allocationLength = pref.getString('allocation-length');
          });
        }
      },
      builder: (context, state) {
        if (state is GetLeaveAllocationLoaded) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: sBlackColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaveAllocationPage()));
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                        Text('You have',
                            style: sWhiteTextStyle.copyWith(fontSize: 16)),
                        Text("${allocationLength.toString()} Leave Available",
                            style: sGreenTextStyle.copyWith(
                                fontSize: 22, fontWeight: semiBold)),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xff272C33),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'See your Leave Allocation',
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
            ),
          );
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
                  MotionToast(
                    height: 50,
                    width: 300,
                    primaryColor: sYellowColor,
                    description: Text(
                      'Not Ready Yet',
                      style: sYellowTextStyle.copyWith(fontWeight: semiBold),
                    ),
                    icon: Icons.warning_amber,
                    animationCurve: Curves.bounceIn,
                  ).show(context);
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

  _getData() async {
    final pref = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        allocationLength = pref.getString('allocation-length');
        leaveLength = pref.getString('leave-length');
      });
    }

    if (leaveLength.toString() == 'null') {
      if (mounted) {
        setState(() {
          leaveLength = '0';
        });
      }
    }
  }

  Future<void> _scanQR() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
        "#FF0000", "Cancel", true, ScanMode.QR);

    setState(() {
      _scanResult = result;
    });
  }
}
