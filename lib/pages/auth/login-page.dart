import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:sister_staff_mobile/bloc/login-bloc/login_bloc.dart';
import 'package:sister_staff_mobile/pages/employee/employee-page.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLoginTitle(),
                  _buildLoginField(),
                  _buildLoginButton(),
                  _buildRegisterButton(),
                  _buildTerms(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildLoginTitle() {
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
            children: [
              TextSpan(
                  text: 'Proceed with your\n',
                  style: sBlackTextStyle.copyWith(
                      fontSize: 20, fontWeight: light)),
              TextSpan(
                  text: 'Login ',
                  style: sBlackTextStyle.copyWith(
                      fontSize: 30, fontWeight: semiBold)),
              TextSpan(
                  text: 'for Staff!!!',
                  style:
                      sRedTextStyle.copyWith(fontSize: 12, fontWeight: light))
            ],
          ),
        ),
        const SizedBox(height: 120)
      ],
    );
  }

  Widget _buildLoginField() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.person_outlined),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            border: const UnderlineInputBorder(),
            focusColor: Colors.black,
            hintText: 'Email',
            hintStyle: GoogleFonts.openSans(),
          ),
          onSaved: (String? value) {},
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.lock_outline),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            border: const UnderlineInputBorder(),
            focusColor: Colors.black,
            hintText: 'Password',
            hintStyle: GoogleFonts.openSans(),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginSuccess) {
          final role = state.role.toString();

          if (role.toString() == 'Instructor') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmployeePage()));
          }
        } else if (state is LoginError) {
          MotionToast(
            height: 50,
            width: 300,
            primaryColor: sRedColor,
            description: Text(
              state.error.toString(),
              style: sRedTextStyle.copyWith(fontWeight: semiBold),
            ),
            icon: Icons.warning_amber,
            animationCurve: Curves.bounceIn,
          ).show(context);
        }
      },
      builder: (context, state) {
        return Material(
          color: sRedColor,
          child: InkWell(
            splashColor: Colors.grey,
            onTap: () async {
              _loginBloc.add(
                  Login(_usernameController.text, _passwordController.text));
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                  child: Text(
                'Login',
                style: sWhiteTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 20,
                ),
              )),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: [
        const SizedBox(height: 5),
        Material(
          color: const Color(0xffE8E8E8),
          child: InkWell(
            splashColor: Colors.grey,
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE22426))),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                  child: Text(
                'Register',
                style: GoogleFonts.openSans(
                  color: const Color(0xffE22426),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTerms() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Terms and Conditions',
            style: GoogleFonts.openSans(
              color: const Color(0xffE22426),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Privacy and Policy',
            style: GoogleFonts.openSans(
              color: const Color(0xffE22426),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
