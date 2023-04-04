// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:string_extensions/string_extensions.dart';

class StudentGroupListPage extends StatefulWidget {
  const StudentGroupListPage({super.key});

  @override
  State<StudentGroupListPage> createState() => _StudentGroupListPageState();
}

class _StudentGroupListPageState extends State<StudentGroupListPage> {
  final dio = Dio();
  final cookieJar = CookieJar();

  bool isLoading = true;

  var totalEnabled;
  var totalDraft;
  var listStudentGroup = [];

  GoogleMapController? controller;

  String? _topModalData;

  final CameraPosition initialPosition = const CameraPosition(
      target: LatLng(-6.973245480531463, 110.39053279088024), zoom: 50);
  var typemap = MapType.normal;
  var cordinate1 = 'cordinate';
  var lat = -6.973245480531463;
  var long = 110.39053279088024;
  var address = '';
  var options = [
    MapType.normal,
    MapType.hybrid,
    MapType.terrain,
    MapType.satellite,
  ];

  Future<void> getAddress(latt, longg) async {
    List<Placemark> placemark = await placemarkFromCoordinates(latt, longg);
    print(
        '-----------------------------------------------------------------------------------------');
    //here you can see your all the relevent information based on latitude and logitude no.
    print(placemark);
    print(
        '-----------------------------------------------------------------------------------------');
    Placemark place = placemark[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStudentGroupList();
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
        actions: const [],
      ),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStudentGroupDetail(),
                _buildStudentGroupList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentGroupList() {
    if (isLoading == true) {
      return Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Center(
              child: Text('Loading your Student Group Data...',
                  style: sWhiteTextStyle)));
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: sBlackColor,
        child: Column(
          children: <Widget>[
            ...listStudentGroup.map((item) {
              return _buildStudentGroupCard(item);
            }).toList(),
          ],
        ),
      );
    }
  }

  Widget _buildStudentGroupDetail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 10),
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
                  Icons.drafts_outlined,
                  color: sWhiteColor,
                  size: 35,
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        totalDraft.toString() == 'null'
                            ? '0'
                            : totalDraft.toString(),
                        style: sWhiteTextStyle.copyWith(fontSize: 16)),
                    Text('Draft Leave', style: sGreyTextStyle),
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
                Icons.event_available_outlined,
                color: sWhiteColor,
                size: 35,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      totalEnabled.toString() == 'null'
                          ? '0'
                          : totalEnabled.toString(),
                      style: sWhiteTextStyle.copyWith(fontSize: 16)),
                  Text('Enabled Leave', style: sGreyTextStyle),
                ],
              )
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildStudentGroupCard(sgroup) {
    // ! 0 : draft
    // ! 1 : enabled
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: sBlackColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          splashColor: const Color(0xff30363D),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff30363D),
                ),
                borderRadius: BorderRadius.circular(8)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ExpandablePanel(
                theme: ExpandableThemeData(
                  iconColor: sWhiteColor,
                  iconPadding: const EdgeInsets.all(0),
                ),
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      child: Text(sgroup['data']['name'].toString().capitalize!,
                          style: sWhiteTextStyle.copyWith(
                              fontWeight: semiBold,
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    const SizedBox(height: 5),
                    _buildStatus(sgroup),
                    const SizedBox(height: 5),
                  ],
                ),
                collapsed: Column(
                  children: [],
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 20,
                      thickness: 1,
                      color: Color(0xff272C33),
                    ),

                    // !  Company
                    Text('Company',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(sgroup['data']['company'].toString(),
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: sGreyColor,
                      height: 150,
                      child: GoogleMap(
                        initialCameraPosition: initialPosition,
                        mapType: typemap,
                        onMapCreated: (controller) {
                          setState(() {
                            controller = controller;
                          });
                        },
                        onTap: (cordinate) {
                          setState(() {
                            lat = cordinate.latitude;
                            long = cordinate.longitude;
                            getAddress(lat, long);

                            cordinate1 = cordinate.toString();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    // !  Program Enrollment
                    Text('Program Enrollment',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(
                          sgroup['data']['program_enrollment'].toString(),
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Program
                    Text('Program',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(sgroup['data']['program'].toString(),
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Students
                    Text('Students',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(
                          '\u2022 ' +
                              sgroup['data']['students'][0]['student_name']
                                  .toString(),
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _fetchStudentGroupList() async {
    final pref = await SharedPreferences.getInstance();
    var listCode = [];
    var user = pref.getString('username');
    var pass = pref.getString('password');
    var name = pref.getString('instructor-code');

    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio
        .post("https://${baseUrl}.sekolahmusik.co.id/api/method/login", data: {
      'usr': user,
      'pwd': pass,
    });

    final getCode = await dio.get(
      'https://${baseUrl}.sekolahmusik.co.id/api/resource/Student%20Group?fields=["name"]&filters=[["Student Group Instructor","instructor","=","${name}"]]',
    );

    for (var a = 0; a < getCode.data['data'].length; a++) {
      if (mounted) {
        setState(() {
          listCode.add(getCode.data['data'][a]['name']);
        });
      }
    }

    dio.interceptors.add(CookieManager(cookieJar));
    final adminLog = await dio
        .post("https://${baseUrl}.sekolahmusik.co.id/api/method/login", data: {
      'usr': user,
      'pwd': pass,
    });

    for (var a = 0; a < listCode.length; a++) {
      final getStudentDetail = await dio.get(
          "https://${baseUrl}.sekolahmusik.co.id/api/resource/Student Group/${listCode[a]}");

      if (mounted) {
        setState(() {
          listStudentGroup.add(getStudentDetail.data);
        });
      }
    }

    var listEnabled = [];
    var listDraft = [];

    for (var a = 0; a < listStudentGroup.length; a++) {
      if (listStudentGroup[a]['data']['docstatus'].toString() != '0') {
        listDraft.add(listStudentGroup[a]['data']['docstatus']);
      } else {
        listEnabled.add(listStudentGroup[a]['data']['docstatus']);
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
        totalEnabled = listEnabled.length.toString();
        totalDraft = listDraft.length.toString();
      });
    }
  }

  _buildStatus(sgroup) {
    if (sgroup['data']['docstatus'].toString() != '0') {
      return Container(
        width: 70,
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Color(0xff242A30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Draft',
                style: sWhiteTextStyle.copyWith(
                  fontSize: 14,
                ))
          ],
        ),
      );
    } else {
      return Container(
        width: 75,
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Color(0xff384D4B)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enabled',
                style: sWhiteTextStyle.copyWith(
                    fontSize: 14,
                    color: Color(0xff70C5AF),
                    fontWeight: semiBold))
          ],
        ),
      );
    }
  }
}
