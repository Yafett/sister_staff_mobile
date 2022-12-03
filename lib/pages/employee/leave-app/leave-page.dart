import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LeaveApplicationPage extends StatefulWidget {
  const LeaveApplicationPage({super.key});

  @override
  State<LeaveApplicationPage> createState() => _LeaveApplicationPageState();
}

class _LeaveApplicationPageState extends State<LeaveApplicationPage> {
  var leaveList = ['', ''];
  var leaveStatus = ['Approved', 'Cancelled', 'Open'];
  int defaultChoiceIndex = 0;

  CalendarController _controller = CalendarController();
  String? _text = '', _titleText = '';
  Color? _headerColor, _viewHeaderColor, _calendarColor;
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
          'Leave Application',
          style: sWhiteTextStyle.copyWith(fontWeight: semiBold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
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
              _buildFilterChip(),
              _buildLeaveList(),
            ],
          )),
        ),
      ),
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
                  // _filterAttendance(_choicesList[index]);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          ...leaveList.map((item) {
            return _buildLeaveCard();
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLeaveCard() {
    final DateRangePickerController _controller = DateRangePickerController();
    String _date =
        DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();

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
                    Text('Wednesday, 20 January 2022',
                        style: sWhiteTextStyle.copyWith(
                            fontSize: 20, fontWeight: semiBold)),
                    const SizedBox(height: 5),
                    Text(
                      'Approved',
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
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text('Mau Healing',
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // ! Type
                    Text('Type',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text('Cuti',
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Departement
                    Text('Departement',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text('Research & Development',
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Leave Balance
                    Text('Leave Balance',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text('10',
                          style: sGreyTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ),

                    // !  Duration
                    Text('Duration - 21 Days',
                        style: sGreyTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold)),
                    _buildCalendar()
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

  Widget _buildCalendar() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: sWhiteColor,
        child: Card(
          margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: SfDateRangePicker( 
            onSelectionChanged: (value) {
              print(value.value.toString());
            }, 
            initialSelectedRange: PickerDateRange(DateTime(2022, 12, 5), DateTime(2022, 12, 7)),
            selectionColor: sRedColor,
            rangeSelectionColor: sRedColor,
            initialDisplayDate: DateTime(2022, 12, 2),
            // minDate: ,
            todayHighlightColor: sRedColor,
            startRangeSelectionColor: sRedColor,
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.extendableRange,
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
