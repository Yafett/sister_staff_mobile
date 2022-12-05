// ignore_for_file: unnecessary_brace_in_string_interps, unused_local_variable

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider {
  login(username, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    var cookieJar = CookieJar();

    var listUser = [];

    var user = 'cecilia';
    final pass = 'admin';

    final verify = await http.post(
        Uri.parse('https://njajal.sekolahmusik.co.id/api/method/login'),
        body: {
          'usr': user,
          'pwd': pass,
        });

    print(verify.body.toString());

    if (verify.statusCode == 200) {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio.post(
        'https://njajal.sekolahmusik.co.id/api/method/login',
        data: {
          'usr': user,
          'pwd': pass,
        },
      );

      prefs.setString('username', user);
      prefs.setString('password', pass);

      if (user.contains('@')) {
        final getCode = await dio.get(
            'https://njajal.sekolahmusik.co.id/api/resource/User?filters=[["email","=","${user}"]]&fields=["*"]');

        final code = getCode.data['data'][0]['name'];

        final getUser = await dio
            .get('https://njajal.sekolahmusik.co.id/api/resource/User/${code}');

        for (var a = 0; a < getUser.data['data']['roles'].length; a++) {
          listUser.add(getUser.data['data']['roles'][a]['role'].toString());
        }
      } else {
        final getCode = await dio.get(
            'https://njajal.sekolahmusik.co.id/api/resource/User?filters=[["username","=","${user}"]]&fields=["*"]');

        final code = getCode.data['data'][0]['name'];

        user = code;

        print(code);

        final getUser = await dio
            .get('https://njajal.sekolahmusik.co.id/api/resource/User/${code}');

        for (var a = 0; a < getUser.data['data']['roles'].length; a++) {
          listUser.add(getUser.data['data']['roles'][a]['role'].toString());
        }
      }

      // if (listUser.contains('Instructor')) {
      //   print('rhodes');

      //   final getInstructorCode = await dio
      //       .get('https://njajal.sekolahmusik.co.id/api/resource/Instructor/');

      //   for (var a = 0; a < getInstructorCode.data['data'].length; a++) {
      //     final getInstructor = await dio.get(
      //         'https://njajal.sekolahmusik.co.id/api/resource/Instructor/${getInstructorCode.data['data'][a]['name'].toString()}');

      //     if (getInstructor.data['data']['instructor_email'].toString() ==
      //         user) {
      //       return 'Instructor';
      //     }
      //   }
      // } else
      if (listUser.contains('Employee')) {
        print('lily');
        final getEmployeeCode = await dio
            .get('https://njajal.sekolahmusik.co.id/api/resource/Employee/');

        for (var a = 0; a < getEmployeeCode.data['data'].length; a++) {
          final getEmployee = await dio.get(
              'https://njajal.sekolahmusik.co.id/api/resource/Employee/${getEmployeeCode.data['data'][a]['name'].toString()}');

          if (getEmployee.data['data']['user_id'].toString() == user) {
            return 'Employee';
          }
        }
      } else if (listUser.contains('Student') ||
          listUser.contains('Guardian')) {
        print('surtr');
        return 'User';
      } else {
        print('kroos');
        final getUserCode = await dio
            .get('https://njajal.sekolahmusik.co.id/api/resource/User/');

        for (var a = 0; a < getUserCode.data['data'].length; a++) {
          final getUser = await dio.get(
              'https://njajal.sekolahmusik.co.id/api/resource/User/${getUserCode.data['data'][a]['name'].toString()}');

          print(user.toString());
          if (getUser.data['data']['user'].toString() == user) {
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
            'https://njajal.sekolahmusik.co.id/api/method/smi.api.registrasi_student'),
        body: body);
  }
}

class NetworkError extends Error {}
