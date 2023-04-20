import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/models/Allocation-model.dart';
import 'package:sister_staff_mobile/models/Leave-model.dart';
import 'package:sister_staff_mobile/models/Schedule-model.dart';
import 'package:sister_staff_mobile/models/Student-Group-model.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class DataProvider {
  final dio = Dio();
  var cookieJar = CookieJar();

  Future<Leave> fetchLeaveApplication() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = pref.getString('username');
    var pass = pref.getString('password');

    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio.post(
          "https://${baseUrl}.sekolahmusik.co.id/api/method/login",
          data: {
            'usr': user,
            'pwd': pass,
          });

      final getCode = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Application/');

      pref.setString('leave-length', getCode.data['data'].length.toString());

      final getLeave = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Application/${getCode.data['data'][0]['name']}');

      return Leave.fromJson(getLeave.data);
    } catch (error, stacktrace) {
      print('Exception Occured: $error stackTrace: $stacktrace');
      return Leave.withError('Data not found / Connection Issues');
    }
  }

  Future<Allocation> fetchLeaveAllocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = pref.getString('username');
    var pass = pref.getString('password');

    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio.post(
          "https://${baseUrl}.sekolahmusik.co.id/api/method/login",
          data: {
            'usr': user,
            'pwd': pass,
          });

      final getCode = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Allocation/');

      print('allocation : ' + getCode.data['data'].length.toString());

      pref.setString(
          'allocation-length', getCode.data['data'].length.toString());

      final getAllocation = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Leave Allocation/${getCode.data['data'][0]['name']}');

      return Allocation.fromJson(getAllocation.data);
    } catch (error, stacktrace) {
      print('Exception Occured: $error stackTrace: $stacktrace');
      return Allocation.withError('Data not found / Connection Issues');
    }
  }

  Future<Schedule> fetchSchedule({code}) async {
    // 0062-t1-000001
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("username");
    var pass = pref.getString('password');
    var listSchedule = [];
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 7);
    final tommorow = DateTime(now.year, now.month + 1, now.day);

    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio.post(
          'https://${baseUrl}.sekolahmusik.co.id/api/method/login',
          data: {
            'usr': user,
            'pwd': pass,
          });

      if (code == null) {
        final getCode = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/Instructor/');

        final code = getCode.data['data'][0]['name'];

        final getEmail = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/Instructor/${code}');

        final request = await dio.post(
            'https://${baseUrl}.sekolahmusik.co.id/api/method/smi.api.get_course_schedule',
            data: {
              'instructor': getEmail.data['data']['instructor_email'],
              'from_date': yesterday.toString(),
              'to_date': tommorow.toString(),
            });

        pref.setString(
            'schedule-length', request.data['message'].length.toString());

        return Schedule.fromJson(request.data);
      } else {
        final request = await dio.post(
          'https://${baseUrl}.sekolahmusik.co.id/api/method/smi.api.get_course_schedule',
          data: {
            'instructor': code,
            'from_date': yesterday.toString(),
            'to_date': tommorow.toString(),
          },
        );

        if (request.statusCode == 200) {
          pref.setString(
              'schedule-length', request.data['message'].length.toString());

          return Schedule.fromJson(request.data);
        } else {
          return Schedule.withError('Data not found / Connection Issues');
        }
      }
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print('Schedule Data Exception Occured: $error stackTrace: $stacktrace');

      return Schedule.withError('Data not found / Connection Issues');
    }
  }

  Future<StudentGroup> fetchStudentGroup({code}) async {
    // 0062-t1-000001
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("username");
    var pass = pref.getString('password');
    var listGroup = [];

    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio.post(
          'https://${baseUrl}.sekolahmusik.co.id/api/method/login',
          data: {
            'usr': user,
            'pwd': pass,
          });

      if (code == null) {
        final getCode = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/Instructor/');

        final code = getCode.data['data'][0]['name'];

        final getStudentGroupCode = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Student Group/',
        );

        print('adada : ' + getStudentGroupCode.data['data'].length.toString());

        pref.setString('student-group-length',
            getStudentGroupCode.data['data'].length.toString());

        dio.interceptors.add(CookieManager(cookieJar));
        final response = await dio.post(
            'https://${baseUrl}.sekolahmusik.co.id/api/method/login',
            data: {
              'usr': 'administrator',
              'pwd': 'admin',
            });

        print('limbo : ' + response.data.toString());

        final getStudentGroup = await dio.get(
          'https://${baseUrl}.sekolahmusik.co.id/api/resource/Student Group/${getStudentGroupCode.data['data'][0]['name']}',
        );

        return StudentGroup.fromJson(getStudentGroup.data);
      } else {
        final request = await dio.post(
          'https://${baseUrl}.sekolahmusik.co.id/api/method/smi.api.get_course_schedule',
          data: {
            'instructor': code,
          },
        );

        if (request.statusCode == 200) {
          pref.setString(
              'schedule-length', request.data['message'].length.toString());

          return StudentGroup.fromJson(request.data);
        } else {
          return StudentGroup.withError('Data not found / Connection Issues');
        }
      }
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print('Schedule Data Exception Occured: $error stackTrace: $stacktrace');

      return StudentGroup.withError('Data not found / Connection Issues');
    }
  }
}

class NetworkError extends Error {}
