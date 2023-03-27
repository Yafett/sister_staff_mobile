import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/bloc/instructor-schedule/instructor_schedule_bloc.dart';
import 'package:sister_staff_mobile/models/Schedule-model.dart';
import 'package:sister_staff_mobile/pages/employee/leave-app/leave-page.dart';
import 'package:sister_staff_mobile/pages/instructor/schedule/schedule-details-page.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class SchedulePage extends StatefulWidget {
  final String? codeDef;

  const SchedulePage({super.key, this.codeDef});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _scheduleBloc = InstructorScheduleBloc();

  var length;
  var listSchedule = [];

  DateTime? start;
  DateTime? end;

  final CalendarController _controller = CalendarController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _scheduleBloc.add(GetScheduleList());
    _fetchScheduleList(widget.codeDef);
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return Scaffold(
      // backgroundColor: sBlackColor,
      appBar: AppBar(
        backgroundColor: sBlackColor,
        leading: const BackButton(color: Color(0xffC9D1D9)),
        title: Text('Your Schedule',
            style: sWhiteTextStyle.copyWith(fontWeight: semiBold)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/student-schedule-help');
            },
            child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.help_outline,
                    size: 30, color: Color(0xffC9D1D9))),
          )
        ],
      ),
      body: _buildCalendar(),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: sBlackColor,
      child: BlocBuilder<InstructorScheduleBloc, InstructorScheduleState>(
        bloc: _scheduleBloc,
        builder: (context, state) {
          if (state is InstructorScheduleLoaded) {
            Schedule schedule = state.scheduleModel;
            return SfCalendarTheme(
              data: SfCalendarThemeData(
                todayTextStyle: sWhiteTextStyle,
                timeTextStyle: sWhiteTextStyle,
                cellBorderColor: sBlackColor,
                headerTextStyle: sWhiteTextStyle.copyWith(
                    fontSize: 20, fontWeight: semiBold),
                activeDatesBackgroundColor: sBlackColor,
                selectionBorderColor: sGreyColor,
                viewHeaderDayTextStyle: sWhiteTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
              ),
              child: SfCalendar(
                controller: _controller,
                onTap: calendarTapped,
                headerHeight: 50,
                todayHighlightColor: sRedColor,
                viewHeaderHeight: 50,
                appointmentTextStyle: sWhiteTextStyle,
                dataSource: MeetingDataSource(_getDataSource(schedule.message)),
                allowAppointmentResize: true,
                showNavigationArrow: true,
                view: CalendarView.month,
                monthViewSettings: MonthViewSettings(
                  agendaViewHeight: 300,
                  agendaItemHeight: 50,
                  agendaStyle: AgendaStyle(
                    backgroundColor: sBlackColor,
                    appointmentTextStyle: sWhiteTextStyle,
                    dateTextStyle: sWhiteTextStyle,
                    dayTextStyle: sWhiteTextStyle,
                  ),
                  monthCellStyle: MonthCellStyle(
                    textStyle: sWhiteTextStyle,
                    leadingDatesTextStyle: sGreyTextStyle,
                    trailingDatesTextStyle: sGreyTextStyle,
                  ),
                  showAgenda: true,
                  navigationDirection: MonthNavigationDirection.horizontal,
                ),
                appointmentTimeTextFormat: 'hh:mm a',
              ),
            );
          } else if (state is InstructorScheduleLoading) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Text(
                  'Loading your Schedule...',
                  style: sWhiteTextStyle,
                )));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  // ! FUNCTION
  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Meeting appointment = calendarTapDetails.appointments![0];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScheduleDetailPage(
                  title: appointment.eventName,
                  date: appointment.date,
                  endDate: appointment.to,
                  startDate: appointment.from,
                  instructor: appointment.instructor,
                  location: appointment.location,
                )),
      );
    }
  }

  // ! FETCH DATA
  _fetchScheduleList(codeDef) async {
    final dio = Dio();
    var cookieJar = CookieJar();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("username");
    var pass = pref.getString('password');
    var email = pref.getString('instructor-email');

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 7);
    final tommorow = DateTime(now.year, now.month + 1, now.day);

    isLoading = true;

    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio
        .post('https://njajal.sekolahmusik.co.id/api/method/login', data: {
      'usr': user,
      'pwd': pass,
    });

    if (codeDef == null) {
      final getCode = await dio
          .get('https://njajal.sekolahmusik.co.id/api/resource/Instructor/');

      final code = getCode.data['data'][0]['name'];

      final getEmail = await dio.get(
          'https://njajal.sekolahmusik.co.id/api/resource/Instructor/${code}');

      final request = await dio.post(
          'https://njajal.sekolahmusik.co.id/api/method/smi.api.get_course_schedule',
          data: {
            'instructor': email,
            'from_date': yesterday.toString(),
            'to_date': tommorow.toString(),
          });

      for (var a = 0; a < request.data['message'].length; a++) {
        if (mounted) {
          setState(() {
            listSchedule.add(request.data['message'][a]);
          });
        }
      }
    } else {
      final request = await dio.post(
          'https://njajal.sekolahmusik.co.id/api/method/smi.api.get_course_schedule',
          data: {
            'instructor': email,
            'from_date': yesterday.toString(),
            'to_date': tommorow.toString(),
          });

      for (var a = 0; a < request.data['message'].length; a++) {
        listSchedule.add(request.data['message'][a]);
      }
    }
  }

  _getDataSource(schedule) {
    final List<Meeting> meetings = <Meeting>[];

    for (var a = 0; a < listSchedule.length; a++) {
      var element = listSchedule[a];

      // ! phase 1
      var rawDate = element['schedule_date'];
      var rawTime = element['from_time'];
      var rawEndTime = element['to_time'];
      var time = rawTime;
      var endTime = rawTime;

      // ! phase 2
      if (rawTime.length <= 7) {
        time = '0' + rawTime;
      } else {
        time = rawTime;
      }

      if (rawEndTime.length <= 7) {
        endTime = '0' + rawEndTime;
      } else {
        endTime = rawEndTime;
      }

      // ! phase 3
      var rawDateToDate = rawDate + ' ' + time;

      var replaced = rawDateToDate.replaceAll('-', '');

      var replaced2 = replaced.replaceAll(':', '');

      var replaced3 = replaced2.replaceAll(' ', '');

      var rawDateToDateEnd = rawDate + ' ' + endTime;

      var replace = rawDateToDateEnd.replaceAll('-', '');

      var replace2 = replace.replaceAll(':', '');

      var replace3 = replace2.replaceAll(' ', '');

      String date = replaced3;
      String dateWithT = date.substring(0, 8) + 'T' + date.substring(8);
      DateTime dateTime = DateTime.parse(dateWithT);

      String dateEnd = replace3;
      String dateEndWithT =
          dateEnd.substring(0, 8) + 'T' + dateEnd.substring(8);
      DateTime dateTimeEnd = DateTime.parse(dateEndWithT);

      end = dateTimeEnd;

      String result =
          element['company'].substring(0, element['company'].indexOf(' '));

      print('aere ' + result.toString());

      meetings.add(Meeting(
          '${element['title']}',
          dateTime,
          dateTimeEnd,
          // sGreenColor,
          sGreyColor,
          false,
          element['instructor_name'],
          result + ' - ' + element['room'],
          element['schedule_date']));
    }

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
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.instructor,
    this.location,
    this.date,
  );

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String instructor;
  String location;
  String date;
}
