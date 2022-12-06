import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-employee/get_profile_employee_bloc.dart';
import 'package:sister_staff_mobile/models/Employee-model.dart';
import 'package:sister_staff_mobile/pages/auth/splash-page.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _employeeBloc = GetProfileEmployeeBloc();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();

  // ! employee
  final _employeeNameController = TextEditingController();
  final _employeeCodeController = TextEditingController();
  final _employeeSalutationController = TextEditingController();
  final _employeeDepartmentController = TextEditingController();
  final _employeeCompanyController = TextEditingController();
  final _employeeStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _employeeBloc.add(GetProfileEmployeeList());
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold();
  }

  Widget _pageScaffold() {
    return Scaffold(
      backgroundColor: sBlackColor,
      appBar: AppBar(
        backgroundColor: sBlackColor,
        leading: const BackButton(color: Color(0xffC9D1D9)),
        title: Text('My Profile',
            style: sWhiteTextStyle.copyWith(fontWeight: semiBold)),
        actions: [],
      ),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: SizedBox(
              child: Column(
            children: [
              _buildUserSection(),
              _buildEmployeeSection(),
            ],
          )),
        ),
      ),
    );
  }

  // ! User
  Widget _buildUserSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserProfile(),
          _buildUserPicture(),
          _buildUserData(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          height: 20,
          width: 10,
          decoration: BoxDecoration(
            color: sGreenColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Text(
          'Sena',
          style: sWhiteTextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Widget _buildUserPicture() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.red,
            image: const DecorationImage(
              image: AssetImage('assets/images/staff-profile.jpg'),
              fit: BoxFit.fitHeight,
            ),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildUserData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

        // ! title
        Text(
          'Basic Information',
          style: sWhiteTextStyle.copyWith(fontWeight: semiBold, fontSize: 20),
        ),
        const Divider(
          thickness: 1,
          color: Color(0xff272C33),
        ),

        // ! First Name Field
        Text('First Name', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _firstNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x john doe',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Last Name Field
        Text('Last Name', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _lastNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x john doe',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Email Field
        Text('Email', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x john@example.com',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Birth Date Field
        Text('Birth Date', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _birthDateController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x date',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  // ! Employee
  Widget _buildEmployeeSection() {
    return BlocBuilder<GetProfileEmployeeBloc, GetProfileEmployeeState>(
        bloc: _employeeBloc,
        builder: (context, state) {
          if (state is GetProfileEmployeeLoaded) {
            Employee employee = state.employeeModel;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ExpandablePanel(
                theme: ExpandableThemeData(
                  iconColor: sWhiteColor,
                  iconPadding: const EdgeInsets.all(0),
                ),
                header: Text(
                  'Employee',
                  style: sWhiteTextStyle.copyWith(
                      fontWeight: semiBold, fontSize: 20),
                ),
                collapsed: Container(),
                expanded: Column(
                  children: [
                    _buildEmployeeData(employee.data),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildEmployeeData(employee) {
    _setEmployeeData(employee);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

        // ! Name Field
        Text('Name', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _employeeNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x john doe',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Employee Code Field
        Text('Employee Code', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _employeeCodeController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x john doe',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Employee Salutation Field
        Text('Employee Salutation', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _employeeSalutationController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x john@example.com',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Employee Department Field
        Text('Employee Department', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _employeeDepartmentController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x date',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Employee Company Field
        Text('Employee Company', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _employeeCompanyController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x date',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),

        // ! Employee Status Field
        Text('Employee Status', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _employeeStatusController,
          decoration: InputDecoration(
            filled: true,
            fillColor: sBlackColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0XFF444C56)),
            ),
            hintText: 'e.x date',
            hintStyle: fGreyTextStyle,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  
  }

  _setEmployeeData(employee) async {
    //     final _employeeNameController = TextEditingController();
    // final _employeeCodeController = TextEditingController();
    // final _employeeSalutationController = TextEditingController();
    // final _employeeDepartmentController = TextEditingController();
    // final _employeeCompanyController = TextEditingController();
    // final _employeeStatusController = TextEditingController();
    _employeeNameController.text = employee.employeeName;
    _employeeCodeController.text = employee.employee;
    _employeeSalutationController.text = employee.salutation;
    _employeeDepartmentController.text = employee.department;
    _employeeCompanyController.text = employee.company;
    _employeeStatusController.text = employee.status;
  }
}
