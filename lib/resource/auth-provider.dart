// ignore_for_file: unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sister_staff_mobile/shared/themes.dart';

class AuthProvider {
  login(username, password) async {
    //

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    var cookieJar = CookieJar();

    var listUser = [];

    var user = username;
    final pass = password;

    final verify = await http.post(
        Uri.parse('https://${baseUrl}.sekolahmusik.co.id/api/method/login'),
        body: {
          'usr': user,
          'pwd': pass,
        });

    if (verify.statusCode == 200) {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio.post(
        'https://${baseUrl}.sekolahmusik.co.id/api/method/login',
        data: {
          'usr': user,
          'pwd': pass,
        },
      );

      prefs.setString('username', user);
      prefs.setString('password', pass);

      if (user.contains('@')) {
        final getCode = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/User?filters=[["email","=","${user}"]]&fields=["*"]');

        final code = getCode.data['data'][0]['name'];

        prefs.setString('user-email', user);

        final getUser = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/User/${code}');

        for (var a = 0; a < getUser.data['data']['roles'].length; a++) {
          listUser.add(getUser.data['data']['roles'][a]['role'].toString());
        }
      } else {
        final getCode = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/User?filters=[["username","=","${user}"]]&fields=["*"]');

        final code = getCode.data['data'][0]['name'];

        user = code;

        prefs.setString('user-email', user);

        final getUser = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/User/${code}');

        for (var a = 0; a < getUser.data['data']['roles'].length; a++) {
          listUser.add(getUser.data['data']['roles'][a]['role'].toString());
        }
      }

      print(listUser.toString());

      if (listUser.contains('Instructor Manager')) {
        final getInstructorCode = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/Instructor/');

        for (var a = 0; a < getInstructorCode.data['data'].length; a++) {
          final getInstructor = await dio.get(
              'https://${baseUrl}.sekolahmusik.co.id/api/resource/Instructor/${getInstructorCode.data['data'][a]['name'].toString()}');

          if (getInstructor.data['data']['instructor_email'].toString() ==
              user) {
            print('belle');
            return 'Instructor Manager';
          } else {
            print('Dave');
            return 'Instructor Manager Only';
          }
        }
      }

      if (listUser.contains('Instructor')) {
        print('Estoc');
        final getInstructorCode = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/Instructor/');

        for (var a = 0; a < getInstructorCode.data['data'].length; a++) {
          final getInstructor = await dio.get(
              'https://${baseUrl}.sekolahmusik.co.id/api/resource/Instructor/${getInstructorCode.data['data'][a]['name'].toString()}');

          if (getInstructor.data['data']['instructor_email'].toString() ==
              user) {
            return 'Instructor';
          }
        }
      }
      if (listUser.contains('Employee')) {
        print('Gunmetalstorm');
        final getEmployeeCode = await dio.get(
            'https://${baseUrl}.sekolahmusik.co.id/api/resource/Employee/');

        for (var a = 0; a < getEmployeeCode.data['data'].length; a++) {
          final getEmployee = await dio.get(
              'https://${baseUrl}.sekolahmusik.co.id/api/resource/Employee/${getEmployeeCode.data['data'][a]['name'].toString()}');

          if (getEmployee.data['data']['user_id'].toString() == user) {
            return 'Employee';
          }
        }
      }

      if (listUser.contains('Student') || listUser.contains('Guardian')) {
        print('Catoblepas');

        return 'User';
      }

      if (listUser.contains('Employee') != true) {
        final getUserCode = await dio
            .get('https://${baseUrl}.sekolahmusik.co.id/api/resource/User/');

        for (var a = 0; a < getUserCode.data['data'].length; a++) {
          final getUser = await dio.get(
              'https://${baseUrl}.sekolahmusik.co.id/api/resource/User/${getUserCode.data['data'][a]['name'].toString()}');

          if (getUser.data['data']['name'].toString() == user) {
            print('Verethragna');

            return 'Customer';
          }
        }
        return 'Customer';
      }
    } else {
      return 'Error';
    }
  }

  register(Map body) async {
    final response = await http.post(
        Uri.parse(
            'https://${baseUrl}.sekolahmusik.co.id/api/method/smi.api.registrasi_student'),
        body: body);
  }
}

class NetworkError extends Error {}
