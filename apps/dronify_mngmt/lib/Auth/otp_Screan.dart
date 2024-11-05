import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/Auth/bloc/auth_bloc.dart';
import 'package:dronify_mngmt/Employee_Screens/Employee_Home/employee_home.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    // Default Pin Theme before input
    final defaultPinTheme = PinTheme(
      width: 12.w,
      height: 7.h,
      textStyle: TextStyle(
        fontSize: 3.h,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffEFEFEF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );

    // Submitted Pin Theme
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFC),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => Center(
                  child: Image.asset(
                    'assets/drone.gif',
                    height: 50,
                    width: 50,
                  ),
                ),
              );
            } else if (state is AuthSignedIn) {
              Navigator.pop(context); // Close loading dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeHome(
                      employee: locator.get<AdminDataLayer>().currentEmployee!),
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is OtpSentSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('OTP Resent!')),
              );
            }
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
                child: Image.asset(
                  'assets/5 7.png',
                  height: 12.h,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 2.5.h,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff73DDFF),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'We have sent the OTP code to',
                style: TextStyle(
                  fontSize: 1.6.h,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff535763),
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 1.6.h,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff535763),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Center(
                  child: Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    onCompleted: (pin) {
                      context.read<AuthBloc>().add(
                            VerifyEvent(
                              email: email,
                              otp: pin,
                            ),
                          );
                    },
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(RequestOtpEmail( email));
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    fontSize: 2.h,
                    color: const Color(0xff73DDFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
