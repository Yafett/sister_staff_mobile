import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/bloc/leave-allocation/get_leave_allocation_bloc.dart';
import 'package:sister_staff_mobile/bloc/leave-application/get_leave_application_bloc.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LeaveApplicationPage extends StatefulWidget {
  const LeaveApplicationPage({super.key});

  @override
  State<LeaveApplicationPage> createState() => _LeaveApplicationPageState();
}

class _LeaveApplicationPageState extends State<LeaveApplicationPage> {
  var leaveList = [];
  var rawLeaveList = [];
  var allocationList = [];
  var leaveStatus = ['All', 'Approved', 'Cancelled', 'Open'];
  int defaultChoiceIndex = 0;

  final _leaveBloc = GetLeaveApplicationBloc();
  final _allocationBloc = GetLeaveAllocationBloc();

  CalendarController _controller = CalendarController();
  String? _text = '', _titleText = '';
  Color? _headerColor, _viewHeaderColor, _calendarColor;

  @override
  void initState() {
    _leaveBloc.add(GetLeaveApplicationList());
    _allocationBloc.add(GetLeaveAllocationList());
    _fetchLeaveData();
    _fetchAllocationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return Scaffold(
      backgroundColor: sBlackColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: sBlackColor,
        leading: const BackButton(color: Color(0xffC9D1D9)),
        title: Text(
          'Leave Application',
          style: sWhiteTextStyle.copyWith(fontWeight: semiBold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
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
              child: Icon(
                Icons.add_circle_outline_outlined,
                color: sWhiteColor,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: SizedBox(
              child: Column(
            children: [
              _buildLeaveAllocation(),
              _buildFilterChip(),
              _buildLeaveList(),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildLeaveAllocation() {
    return BlocBuilder<GetLeaveAllocationBloc, GetLeaveAllocationState>(
      bloc: _allocationBloc,
      builder: (context, state) {
        if (state is GetLeaveAllocationLoaded) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...allocationList.map((item) {
                    return Container(
                      margin: EdgeInsets.only(right: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff444C56)),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            child: Icon(
                                _setAllocationIcon(item['data']['leave_type']),
                                color: Colors.white,
                                size: 30),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['data']['total_leaves_allocated'].toInt().toString()} Days',
                                style: sWhiteTextStyle.copyWith(fontSize: 16),
                              ),
                              Text(
                                _setAllocationType(item['data']['leave_type']),
                                style: sGreyTextStyle.copyWith(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildFilterChip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Wrap(
            spacing: 4,
            children: List.generate(leaveStatus.length, (index) {
              return ChoiceChip(
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                label: Text(
                  leaveStatus[index],
                  style: sWhiteTextStyle,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xff444C56))),
                selected: defaultChoiceIndex == index,
                selectedColor: const Color(0xff2D333B),
                onSelected: (value) {
                  _filterAttendance(leaveStatus[index]);
                  if (mounted) {
                    setState(() {
                      defaultChoiceIndex = value ? index : defaultChoiceIndex;
                    });
                  }
                },
                backgroundColor: sBlackColor,
                elevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              );
            }),
          )
        ]),
      ),
    );
  }

  Widget _buildLeaveList() {
    return BlocBuilder<GetLeaveApplicationBloc, GetLeaveApplicationState>(
      bloc: _leaveBloc,
      builder: (context, state) {
        if (state is GetLeaveApplicationLoaded) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: <Widget>[
                ...leaveList.map((item) {
                  return _buildLeaveCard(item['data']);
                }).toList(),
              ],
            ),
          );
        } else {
          return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                  child: Text(
                "You didn't have any Leave",
                style: sGreyTextStyle,
              )));
        }
      },
    );
  }

  Widget _buildLeaveCard(leave) {
    final DateRangePickerController _controller = DateRangePickerController();
    String _date =
        DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();

    var replacedFrom = leave['from_date'].toString().replaceAll('-', '');
    String dateFromT = replacedFrom.substring(0, 8);
    DateTime fromDateTime = DateTime.parse(dateFromT);

    var replacedTo = leave['to_date'].toString().replaceAll('-', '');
    String dateToT = replacedTo.substring(0, 8);
    DateTime toDateTime = DateTime.parse(dateToT);

    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy').format(fromDateTime);

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
                    Text(formattedDate,
                        style: sWhiteTextStyle.copyWith(
                            fontSize: 20, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Text(
                      leave['status'].toString(),
                      style: sGreenTextStyle.copyWith(
                          fontWeight: semiBold, fontSize: 14),
                    ),
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

                    // ! Reason
                    Text('Reason',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(
                          (leave['description'] == null)
                              ? '-'
                              : leave['description'].toString(),
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // ! Type
                    Text('Type',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(leave['leave_type'].toString().capitalize!,
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Departement
                    Text('Departement',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(
                          (leave['departement'] == null)
                              ? '-'
                              : leave['departement'].toString(),
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Leave Balance
                    Text('Leave Balance',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(leave['leave_balance'].toInt().toString(),
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Duration
                    Text(
                        'Duration - ${leave['total_leave_days'].toInt().toString()} Days',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    _buildCalendar(fromDateTime, toDateTime)
                    // _buildCalendar(),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(date1, date2) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 5),
        // decoration: BoxDecoration(border: Border.all(color: sWhiteColor)),
        child: Card(
          child: SfDateRangePickerTheme(
            data: SfDateRangePickerThemeData(
              todayTextStyle: sWhiteTextStyle.copyWith(color: sBlueColor),
              todayHighlightColor: sWhiteColor,
              selectionColor: sWhiteColor,
              rangeSelectionColor: sRedColor,
            ),
            child: SfDateRangePicker(
              // showNavigationArrow: true,
              backgroundColor: Color.fromARGB(255, 204, 204, 204),
              onSelectionChanged: (value) {
                print(value.value.toString());
              },
              initialSelectedRange: PickerDateRange(date1, date2),
              rangeSelectionColor: Color.fromARGB(153, 33, 149, 243),
              todayHighlightColor: sGreenColor,
              toggleDaySelection: false,
              showTodayButton: false,
              startRangeSelectionColor: Color.fromARGB(255, 33, 149, 243),
              view: DateRangePickerView.month,
              monthViewSettings: DateRangePickerMonthViewSettings(
                enableSwipeSelection: false,
              ),
              selectionMode: DateRangePickerSelectionMode.extendableRange,
            ),
          ),
        ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  _fetchLeaveData() async {
    final dio = Dio();
    var cookieJar = CookieJar();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = prefs.getString("username");
    var pass = prefs.getString('password');

    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio
        .post('https://${baseUrl}.sekolahmusik.co.id/api/method/login', data: {
      'usr': user,
      'pwd': pass,
    });

    print(response.data.toString());

    final getCode = await dio.get(
        'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Application/');

    for (var a = 0; a < getCode.data['data'].length; a++) {
      final code = getCode.data['data'][a]['name'].toString();
      print(code.toString());
      final getLeave = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Application/${code}');

      if (mounted) {
        setState(() {
          leaveList.add(getLeave.data);
          rawLeaveList.add(getLeave.data);
        });
      }

      print('burned : ' + leaveList.toString());
    }
  }

  _filterAttendance(String filter) {
    // isLoading = true;

    if (mounted) {
      setState(() {
        leaveList.clear();
        leaveList = rawLeaveList;
      });
    }

    if (filter.toLowerCase() != 'all') {
      for (var a = 0; a < leaveList.length; a++) {
        var filteredList = leaveList
            .where((element) =>
                element['data']['status'].toString().toLowerCase() ==
                filter.toLowerCase())
            .toList();
        if (mounted) {
          setState(() {
            leaveList = filteredList;
          });
        }
      }
    } else {
      for (var a = 0; a < leaveList.length; a++) {
        var filteredList = leaveList
            .where((element) =>
                element['data']['status'].toString().toLowerCase() !=
                filter.toLowerCase())
            .toList();
        if (mounted) {
          setState(() {
            leaveList = filteredList;
          });
        }
      }
    }
  }

  _fetchAllocationData() async {
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

      if (mounted) {
        setState(() {
          allocationList.add(getData.data);
        });
      }
    }
  }

  _setAllocationIcon(item) {
    if (item.toString().toLowerCase() == 'sakit') {
      return Icons.sick_outlined;
    } else if (item.toString().toLowerCase() == 'day off') {
      return Icons.holiday_village_outlined;
    } else if (item.toString().toLowerCase() == 'cuti') {
      return Icons.family_restroom_outlined;
    }
  }

  _setAllocationType(item) {
    if (item.toString().toLowerCase() == 'sakit') {
      return 'Sick Leaves';
    } else if (item.toString().toLowerCase() == 'day off') {
      return 'Days Off';
    } else if (item.toString().toLowerCase() == 'cuti') {
      return 'Casual Leaves';
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
