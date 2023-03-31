import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sister_staff_mobile/shared/themes.dart';
import 'package:skeletons/skeletons.dart';

class StudentListPage extends StatefulWidget {
  String? code;

  StudentListPage({super.key, this.code});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final dio = Dio();
  final cookieJar = CookieJar();

  bool isLoading = true;

  var listStudent = [];

  @override
  void initState() {
    _fetchStudent(widget.code);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xff0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xff0D1117),
        centerTitle: true,
        actions: const [],
      ),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStudentList(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    if (isLoading == true) {
      return Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Center(
              child: Text('Loading your Student Data...',
                  style: sWhiteTextStyle)));
    } else {
      return Container(
        color: sBlackColor,
        child: Column(
          children: <Widget>[
            ...listStudent.map((item) {
              return _buildStudentCard(item);
            }).toList(),
          ],
        ),
      );
    }
  }

  Widget _buildStudentCard(student) {
    final String image;
    if (student['image'].toString()[0] == '/') {
      image = 'https://njajal.sekolahmusik.co.id${student['image']}';
    } else {
      image = student['image'].toString();
    }

    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        Material(
          color: sBlackColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashColor: sGreyColor,
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff30363D),
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  (student['image'] != null)
                      ? Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only()),
                        )
                      : Container(
                          height: 85,
                          width: 85,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/staff-profile.jpg'),
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              )),
                        ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: Text(student['student_name'].toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              softWrap: false,
                              style: sWhiteTextStyle.copyWith(
                                  fontSize: 16, fontWeight: semiBold)),
                        ),
                        Text(student['student'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: sGreyTextStyle.copyWith(
                                fontSize: 14, fontWeight: semiBold)),
                        SizedBox(height: 10),
                        Row(children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _paymentStatusColor(
                                  student['payment'].toString()),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(student['payment'].toString(),
                                    style: sWhiteTextStyle)
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: (student['status'].toString() == 'Active') 
                                  ? Color(0xff237D29)
                                  : Color(0xff242A30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(student['status'], style: sWhiteTextStyle)
                              ],
                            ),
                          )
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  _paymentStatusColor(payment) {
    if (payment == 'Paid') {
      return Color(0xff237D29);
    } else if (payment == 'Unpaid') {
      return Color(0xffF8814F);
    } else if (payment == 'Cancelled' ||
        payment == 'Overdue' ||
        payment == 'Draft') {
      return Color(0xffE24C4C);
    } else {
      return Colors.transparent;
    }
  }

  _fetchStudent(code) async {
    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio
        .post("https://njajal.sekolahmusik.co.id/api/method/login", data: {
      'usr': 'administrator',
      'pwd': 'admin',
    });

    final getCode = await dio.post(
        "https://njajal.sekolahmusik.co.id/api/method/smi.api.get_student_list",
        data: {
          'user': code,
        });

    if (getCode.statusCode == 200) {
      for (var a = 0; a < getCode.data['message'].length; a++) {
        var student = getCode.data['message'][a];
        if (mounted) {
          setState(() {
            listStudent.add(student);
            isLoading = false;
          });
        }
      }
    }
  }
}
