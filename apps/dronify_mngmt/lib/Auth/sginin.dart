import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/Auth/first_screen.dart';
import 'package:dronify_mngmt/Auth/forget_password.dart';
import 'package:dronify_mngmt/Auth/otp_Screan.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: Image.asset(
                    'assets/drone.gif',
                    height: 50,
                    width: 50,
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }

            if (state is AuthSignedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign-in successful!')),
              );
              locator.get<AdminDataLayer>().saveData();

              if (supabase.auth.currentUser != null) {
                if (supabase.auth.currentUser!.userMetadata!['role'] ==
                    'employee') {
                  locator.get<AdminDataLayer>().fetchEmpOrders();
                }
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirstScreen(),
                ),
              );
            } else if (state is FailedLoginState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              if (state.isCustomer) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OtpScreen(email: emailController.text),
                  ),
                );
              }
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/appbar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/Group 34611.png',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(child: Image.asset('assets/5 7.png')),
                        const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: const Color(0XFFF5F5F5),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            fillColor: const Color(0XFFF5F5F5),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPassword()),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF072D6F),
                                  Color(0xFF0A3F9A),
                                  Color(0xFF0A43A4),
                                  Color(0xFF0D56D5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();

                                if (email.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter email and password'),
                                    ),
                                  );
                                  return;
                                }
                                context.read<AuthBloc>().add(
                                      SignInEvent(
                                        email: email,
                                        password: password,
                                      ),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 20,
                  left: 140,
                  child: SafeArea(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(1, 1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(-1, -1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(1, -1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(-1, 1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(1, 1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(-1, -1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(1, -1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(-1, 1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(1, -1),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(-1, 1),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Management',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
