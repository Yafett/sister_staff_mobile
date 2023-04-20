// ignore_for_file: file_names

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/themes.dart';
import 'login-page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplashPage(context);
  }

  Widget _buildSplashPage(context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      child: AnimatedSplashScreen(
        splashIconSize: 1000,
        duration: 2000,
        splash: _buildSecondSplashBackground(),
        nextScreen: const LoginPage(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    ));
  }

  Widget _buildSecondSplashBackground() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              // fit: BoxFit.,
              image: AssetImage('assets/images/logo-text.png')),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(''),
            Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  'Version 1.0',
                  style: sGreyTextStyle.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashBackground(context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xffE22426),
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: const AssetImage('assets/images/logo-text.png')),
        ),
        child: _buildSplashText(),
      ),
    );
  }

  Widget _buildSplashText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/smi-logo-white.png'),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'SISTER MOBILE\n',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'set up your future',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
