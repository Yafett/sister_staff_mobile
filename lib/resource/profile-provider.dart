// ignore_for_file: unused_local_variable

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/models/Employee-model.dart';

class ProfileProvider {
  final dio = Dio();
  var cookieJar = CookieJar();

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
}

class NetworkError extends Error {}
