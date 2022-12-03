import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/models/Leave-model.dart';

class DataProvider {
  final dio = Dio();
  var cookieJar = CookieJar();

  Future<Leave> fetchLeaveApplication() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = pref.getString('username');
    var pass = pref.getString('password');

    try {
      dio.interceptors.add(CookieManager(cookieJar));
      final response = await dio
          .post("https://njajal.sekolahmusik.co.id/api/method/login", data: {
        'usr': 'administrator',
        'pwd': 'admin',
      });

      final getCode = await dio.get(
          'https://njajal.sekolahmusik.co.id/api/resource/Leave Application/');
      final getLeave = await dio.get(
          'https://njajal.sekolahmusik.co.id/api/resource/Leave Application/${getCode.data['data'][0]['name']}');

      return Leave.fromJson(getLeave.data);
    } catch (error, stacktrace) {
      print('Exception Occured: $error stackTrace: $stacktrace');
      return Leave.withError('Data not found / Connection Issues');
    }
  }
}

class NetworkError extends Error {}
