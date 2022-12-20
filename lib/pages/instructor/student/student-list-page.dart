import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
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

  bool isLoading = false;

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.rectangle,
                width: MediaQuery.of(context).size.width,
                height: 80,
              ),
            ),
            const SizedBox(height: 10),
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.rectangle,
                width: MediaQuery.of(context).size.width,
                height: 80,
              ),
            ),
            const SizedBox(height: 10),
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.rectangle,
                width: MediaQuery.of(context).size.width,
                height: 80,
              ),
            ),
          ],
        ),
      );
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

    return SizedBox(
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff30363D),
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  (student['image'] != null)
                      ? Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                        )
                      : Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/staff-profile.jpg'),
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
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
                              fontSize: 16, fontWeight: semiBold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
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
          'ins': code,
        });

    if (getCode.statusCode == 200) {
      for (var a = 0; a < getCode.data['message'].length; a++) {
        var student = getCode.data['message'][a];
        if (mounted) {
          setState(() {
            listStudent.add(student);
          });
        }
      }
      print(listStudent.toString());
    }
  }
}
