import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/bloc/leave-allocation/get_leave_allocation_bloc.dart';
import 'package:sister_staff_mobile/models/Allocation-model.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class LeaveAllocationPage extends StatefulWidget {
  const LeaveAllocationPage({super.key});

  @override
  State<LeaveAllocationPage> createState() => _LeaveAllocationPageState();
}

class _LeaveAllocationPageState extends State<LeaveAllocationPage> {
  final _allocationBloc = GetLeaveAllocationBloc();

  var allocationList = [];
  String _scanResult = 'No data yet';

  Future<void> _scanQR() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
        "#FF0000", "Cancel", true, ScanMode.QR);

    setState(() {
      _scanResult = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllocationList();
    _allocationBloc.add(GetLeaveAllocationList());
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return Scaffold(
      backgroundColor: sBlackColor,
      appBar: AppBar(
        backgroundColor: sBlackColor,
        leading: const BackButton(color: Color(0xffC9D1D9)),
        title: Text(
          'Leave Allocation',
          style: sWhiteTextStyle.copyWith(fontWeight: semiBold),
        ),
        actions: [],
      ),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: SizedBox(
              child: Column(
            children: [
  
              _buildLeaveTotalList(),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildLeaveTotalList() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: BlocBuilder<GetLeaveAllocationBloc, GetLeaveAllocationState>(
          bloc: _allocationBloc,
          builder: (context, state) {
            if (state is GetLeaveAllocationLoaded) {
              Allocation allocation = state.allocation;

              return Column(
                children: <Widget>[
                  ...allocationList.map((item) {
                    return _buildLeaveTotalCard(item['data']);
                  }).toList(),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _buildLeaveTotalCard(allocation) {
    final DateFormat formatter = DateFormat('dd MMM');

    var rawFrom = DateTime.parse(allocation['from_date']);
    final String fromDate = formatter.format(rawFrom);

    var rawTo = DateTime.parse(allocation['to_date']);
    final String toDate = formatter.format(rawTo);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _setLeaveType(allocation['leave_type']),
                    style: sWhiteTextStyle.copyWith(
                        fontSize: 24, fontWeight: semiBold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xff1579D0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_outlined,
                            color: Colors.white, size: 15),
                        SizedBox(width: 5),
                        Text('Submitted',
                            style:
                                sWhiteTextStyle.copyWith(fontWeight: semiBold)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Color(0xff272C33),
              ),
              Text(
                'Manager : Cecilia Tsang',
                style:
                    sGreyTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
              SizedBox(height: 5),
              Text(
                'Leave From : ${fromDate.toString()} - ${toDate.toString()}',
                style:
                    sGreyTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
              SizedBox(height: 5),
              Text(
                'Leaves Allocated : ${allocation['total_leaves_allocated'].toInt().toString()} Leaves',
                style:
                    sGreyTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
              SizedBox(height: 5),
            ]),
          ),
        ),
      ),
    );
  }

  _fetchAllocationList() async {
    final dio = Dio();
    final cookieJar = CookieJar();
    final prefs = await SharedPreferences.getInstance();

    var allocationCode = [];

    var user = prefs.getString("username");
    var pass = prefs.getString('password');

    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio
        .post('https://${baseUrl}.sekolahmusik.co.id/api/method/login', data: {
      'usr': user,
      'pwd': pass,
    });

    final getCode = await dio.get(
        'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Allocation/');

    for (var a = 0; a < getCode.data['data'].length; a++) {
      allocationCode.add(getCode.data['data'][a]['name']);
    }

    for (var b = 0; b < allocationCode.length; b++) {
      final getData = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Allocation/${allocationCode[b]}');
      allocationList.add(getData.data);
    }

    print(allocationList.toString());
  }

  _setLeaveType(allocation) {
    if (allocation.toString().toLowerCase() == 'cuti') {
      return 'Casual Leave';
    } else if (allocation.toString().toLowerCase() == 'sakit') {
      return 'Sick Leave';
    } else if (allocation.toString().toLowerCase() == 'day off') {
      return 'Day Off Leave';
    } else {
      return 'Undefined Leave';
    }
  }
}
