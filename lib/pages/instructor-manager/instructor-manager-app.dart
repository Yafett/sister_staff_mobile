// ignore_for_file: prefer_is_empty, prefer_const_constructors

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sister_staff_mobile/bloc/profile-user/get_profile_user_bloc.dart';
import 'package:sister_staff_mobile/models/User-model.dart';
import 'package:sister_staff_mobile/pages/auth/profile-page.dart';
import 'package:sister_staff_mobile/pages/auth/splash-page.dart';
import 'package:sister_staff_mobile/pages/instructor-manager/instructor-list.dart';
import 'package:sister_staff_mobile/pages/instructor/student-group/student-group-list.dart';
import 'package:sister_staff_mobile/pages/instructor/student/student-list-page.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:string_extensions/string_extensions.dart';

class InstructorManagerPage extends StatefulWidget {
  InstructorManagerPage({super.key});

  @override
  State<InstructorManagerPage> createState() => _InstructorPageSManagertate();
}

class _InstructorPageSManagertate extends State<InstructorManagerPage> {
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  bool isOpened = false;
  final dio = Dio();
  final _userBloc = GetProfileUserBloc();

  var instructorLength;

  String _scanResult = 'No data yet';

  @override
  void initState() {
    _userBloc.add(GetProfileUserList());
    _setInstructorTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return BlocBuilder<GetProfileUserBloc, GetProfileUserState>(
      bloc: _userBloc,
      builder: (context, state) {
        if (state is GetProfileUserLoaded) {
          User user = state.userModel;

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
                child: _buildSidebar(user),
              ),
              maxMenuWidth: 250,
              onChange: (_isOpened) {},
              child: GestureDetector(
                onTap: () => _setToggleMenu(false),
                child: SideMenu(
                  maxMenuWidth: 250,
                  radius: BorderRadius.circular(12),
                  background: const Color.fromARGB(255, 41, 41, 41),
                  key: _sideMenuKey,
                  menu: _buildSidebar(user),
                  type: SideMenuType.slideNRotate,
                  onChange: (_isOpened) {},
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
                        actions: [
                          GestureDetector(
                            onTap: () => _scanQR,
                            child: Icon(Icons.qr_code_scanner,
                                size: 30, color: Color(0xffC9D1D9)),
                          ),
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
                              _buildProfileTitle(user.data),
                              _buildProfileChip(),
                              _buildInstructorSection()
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
          return Scaffold(
            body: Container(
              color: sBlackColor,
              child: Center(
                child: Text(
                  'Loading your Data..',
                  style: sWhiteTextStyle,
                ),
              ),
            ),
          );
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
                  'Hello, ${user.data.firstName.toString().toLowerCase().capitalize}',
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
                      builder: (context) => ProfilePage(
                            instructor: false,
                            employee: false,
                          )));
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
                      builder: (context) => InstructorGroupPage()));
            },
            leading: const Icon(Icons.school, size: 20.0, color: Colors.white),
            title: const Text("Instructor List"),
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
                      employee: false,
                    )));
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
                          builder: (context) => ProfilePage(
                                instructor: false,
                                employee: false,
                              )));
                },
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

  Widget _buildProfileTitle(user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      instructor: false,
                      employee: false,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user.firstName.toString().toLowerCase().capitalize}!',
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
            child: _buildChip(
                '${instructorLength.toString()} Instructor', Icons.school),
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
                        Text("${instructorLength} Instructor",
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

  Future<void> _scanQR() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
        "#FF0000", "Cancel", true, ScanMode.QR);

    setState(() {
      _scanResult = result;
    });
  }

  _setInstructorTotal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("username");
    var pass = pref.getString('password');
    var email = pref.getString('instructor-email');
    var company = pref.getString('instructor-company');
    final cookieJar = CookieJar();

    var listCode = [];
    var listMap = [];

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
        });
      }
    }
    if (mounted) {
      setState(() {
        instructorLength = listCode.length.toString();
      });
    }
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
}
