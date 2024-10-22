import 'package:dronify/src/Auth/verify_cubit/verify_cubit.dart';
import 'package:dronify/src/Bottom_Nav/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    // تصميم الـ Pin قبل الإدخال
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

    // تصميم الـ Pin عند إدخال الرقم
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

    return BlocProvider(
      create: (context) => VerifyCubit(),
      child: Builder(builder: (context) {
        return BlocListener<VerifyCubit, VerifyState>(
          listener: (context, state) {
            if (state is LoadingState) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state is SuccessState) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNav()),
              );
            } else if (state is ErrorState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Column(
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
                    'Verification code',
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
                          context.read<VerifyCubit>().verifyMethod(
                                email: email,
                                otp: pin,
                              );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP Resent!')),
                      );
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
      }),
    );
  }
}
