// ignore_for_file: prefer_const_constructors_in_immutables, sized_box_for_whitespace, prefer_if_null_operators

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-employee/get_profile_employee_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-instructor/get_profile_instructor_bloc.dart';
import 'package:sister_staff_mobile/bloc/profile-user/get_profile_user_bloc.dart';
import 'package:sister_staff_mobile/models/Employee-model.dart';
import 'package:sister_staff_mobile/models/Instructor-model.dart';
import 'package:sister_staff_mobile/models/User-model.dart';
import 'package:sister_staff_mobile/shared/themes.dart';

class ProfilePage extends StatefulWidget {
  var instructor = false;
  var employee = false;
  ProfilePage({super.key, required this.instructor, required this.employee});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userBloc = GetProfileUserBloc();
  final _employeeBloc = GetProfileEmployeeBloc();
  final _instructorBloc = GetProfileInstructorBloc();

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

  // ! instructor
  final _instructorNameController = TextEditingController();
  final _instructorEmailController = TextEditingController();
  final _instructorCompanyController = TextEditingController();
  final _instructorCompanyAbbrController = TextEditingController();

  var isLoading = true;

  @override
  void initState() {
    super.initState();
    _userBloc.add(GetProfileUserList());
    if (widget.employee == true) {
      _employeeBloc.add(GetProfileEmployeeList());
    }
    if (widget.instructor == true) {
      _instructorBloc.add(GetProfileInstructorList());
    }
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
      ),
      body: ScrollConfiguration(
        behavior: NoScrollWaves(),
        child: SingleChildScrollView(
          child: SizedBox(
              child: Column(
            children: [
              _buildUserSection(),
              widget.employee == true ? _buildEmployeeSection() : Container(),
              widget.instructor ? _buildInstructorSection() : Container(),
            ],
          )),
        ),
      ),
    );
  }

  // ! User
  Widget _buildUserSection() {
    return BlocBuilder<GetProfileUserBloc, GetProfileUserState>(
      bloc: _userBloc,
      builder: (context, state) {
        if (state is GetProfileUserLoaded) {
          User user = state.userModel;
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(user.data),
                _buildUserPicture(),
                _buildUserData(user.data),
              ],
            ),
          );
        } else {
          return Container(
              height: MediaQuery.sizeOf(context).height / 1.5,
              child: Center(
                child: Text(
                  'Loading your Profile Data..',
                  style: sWhiteTextStyle,
                ),
              ));
        }
      },
    );
  }

  Widget _buildUserProfile(user) {
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
          user.firstName.toString(),
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
              image: AssetImage('assets/images/default.jpg'),
              fit: BoxFit.fitHeight,
            ),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildUserData(user) {
    _setUserData(user);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

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

  _setUserData(user) {
    _firstNameController.text = (user.firstName == null) ? '' : user.firstName;
    _lastNameController.text = (user.lastName == null) ? '' : user.lastName;
    _emailController.text = (user.email == null) ? '' : user.email;
    _birthDateController.text = (user.birthDate == null) ? '' : user.birthDate;
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

  _setEmployeeData(employee) {
    _employeeNameController.text =
        employee.employeeName == null ? '' : employee.employeeName;
    _employeeCodeController.text =
        employee.employee == null ? '' : employee.employee;
    _employeeSalutationController.text =
        employee.salutation == null ? '' : employee.salutation;
    _employeeDepartmentController.text =
        employee.department == null ? '' : employee.department;
    _employeeCompanyController.text =
        employee.company == null ? '' : employee.company;
    _employeeStatusController.text =
        employee.status == null ? '' : employee.status;
  }

  // ! Instructor
  Widget _buildInstructorSection() {
    return BlocBuilder<GetProfileInstructorBloc, GetProfileInstructorState>(
      bloc: _instructorBloc,
      builder: (context, state) {
        if (state is GetProfileInstructorLoaded) {
          Instructor instructor = state.instructorModel;
          return Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExpandablePanel(
              theme: ExpandableThemeData(
                iconColor: sWhiteColor,
                iconPadding: const EdgeInsets.all(0),
              ),
              header: Text(
                'Instructor',
                style: sWhiteTextStyle.copyWith(
                    fontWeight: semiBold, fontSize: 20),
              ),
              collapsed: Container(),
              expanded: Column(
                children: [
                  _buildInstructorData(instructor.data),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildInstructorData(instructor) {
    _setInstructorData(instructor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

        // ! Name Field
        Text('Name', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _instructorNameController,
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

        // ! Instructor Company Field
        Text('Instructor Company', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _instructorCompanyController,
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

        // ! Instructor Company Abbr Field
        Text('Instructor Company Abbr', style: fTextColorStyle),
        const SizedBox(height: 5),
        TextFormField(
          style: sWhiteTextStyle,
          controller: _instructorCompanyAbbrController,
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
      ],
    );
  }

  _setInstructorData(instructor) {
    _instructorEmailController.text =
        instructor.instructorEmail.toString() == 'null'
            ? ''
            : instructor.instructorEmail.toString();
    _instructorNameController.text =
        instructor.name.toString() == 'null' ? '' : instructor.name;
    _instructorCompanyController.text =
        instructor.company.toString() == 'null' ? '' : instructor.company;
    _instructorCompanyAbbrController.text =
        instructor.companyAbbr.toString() == 'null'
            ? ''
            : instructor.companyAbbr;
  }
}
