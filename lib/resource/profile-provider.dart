// ignore_for_file: unused_local_variable

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/models/Employee-model.dart';
import 'package:sister_staff_mobile/models/Instructor-model.dart';
import 'package:sister_staff_mobile/models/User-model.dart';

class ProfileProvider {
  final dio = Dio();
  var cookieJar = CookieJar();

  // 最もプレイされたガチャゲーム
  Future<User> fetchProfile(codeDef) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("username");
    var pass = pref.getString('password');

    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio
          .post("https://njajal.sekolahmusik.co.id/api/method/login", data: {
        'usr': user,
        'pwd': pass,
      });

      var emailUser = pref.getString('user-email');

      final request = await dio.get(
          "https://njajal.sekolahmusik.co.id/api/resource/User/${emailUser}");

      return User.fromJson(request.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      return User.withError('Data not found / Connection Issues');
    }
  }

  Future<Employee> fetchProfileEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = pref.getString('username');
    var pass = pref.getString('password');
  
    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio
          .post("https://njajal.sekolahmusik.co.id/api/method/login", data: {
        'usr': user,
        'pwd': pass,
      });

      final getCode = await dio
          .get('https://njajal.sekolahmusik.co.id/api/resource/Employee/');

      final getEmployee = await dio.get(  
          'https://njajal.sekolahmusik.co.id/api/resource/Employee/${getCode.data['data'][0]['name']}');

      return Employee.fromJson(getEmployee.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print('Exception Occured: $error stackTrace: $stacktrace');
      return Employee.withError('Data not found / Connection Issues');
    }
  }

  Future<Instructor> fetchProfileInstructor() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = pref.getString('username');
    var pass = pref.getString('password');

    var listStudentGroup = [];
    var studentLength;

    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio
          .post("https://njajal.sekolahmusik.co.id/api/method/login", data: {
        'usr': 'maria_hikarita',
        'pwd': 'admin',
      });

      final getCode = await dio
          .get('https://njajal.sekolahmusik.co.id/api/resource/Instructor/');

      final getInstructor = await dio.get(
          'https://njajal.sekolahmusik.co.id/api/resource/Instructor/${getCode.data['data'][0]['name']}');

      final getstudentLength = await dio.post(
          "https://njajal.sekolahmusik.co.id/api/method/smi.api.get_student_list",
          data: {
            'ins': '${getCode.data['data'][0]['name']}',
          });

      // for (var i = 0; i < getstudentLength.data['message'].length; i++) {
      //   print(getstudentLength.data['message'][i]['student_name']);
      // }

      // print(getCode.data['data'][0]['name'].toString());
      // print(getstudentLength.data['message'].toString());
      // print(getstudentLength.data['message'].length.toString());

      pref.setString('student-length', getstudentLength.data['message'].length.toString());

      return Instructor.fromJson(getInstructor.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print('Exception Occured: $error stackTrace: $stacktrace');
      return Instructor.withError('Data not found / Connection Issues');
    }
  }
}

class NetworkError extends Error {}
