
// import 'package:dronify_mngmt/Auth/bloc/auth_bloc.dart';
// import 'package:dronify_mngmt/Auth/otp_Screan.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Signup extends StatelessWidget {
//   Signup({super.key});

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           _buildHeader(),
//           _buildForm(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/appbar.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Center(
//         child: Image.asset('assets/Group 34611.png'),
//       ),
//     );
//   }

//   Widget _buildForm(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.78,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(40),
//             topRight: Radius.circular(40),
//           ),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: BlocConsumer<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is AuthError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             } else if (state is AuthSignedUp) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Sign-up successful!')),
//               );
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => OtpScreen(
//                     email: emailController.text.trim(),
               
//                   ),
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is AuthLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(child: Image.asset('assets/5 7.png')),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Sign Up',
//                     style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   _buildTextField('User Name', nameController, false),
//                   const SizedBox(height: 10),
//                   _buildTextField(
//                     'Phone Number',
//                     phoneController,
//                     false,
//                     inputType: TextInputType.phone,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildTextField('Email', emailController, false,
//                       inputType: TextInputType.emailAddress),
//                   const SizedBox(height: 10),
//                   _buildTextField('Password', passwordController, true),
//                   const SizedBox(height: 20),
//                   _buildSignUpButton(context),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller,
//     bool obscure, {
//     TextInputType inputType = TextInputType.text,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: obscure,
//           keyboardType: inputType,
//           decoration: InputDecoration(
//             fillColor: const Color(0XFFF5F5F5),
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSignUpButton(BuildContext context) {
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: const LinearGradient(
//             colors: [
//               Color(0xFF072D6F),
//               Color(0xFF0A3F9A),
//               Color(0xFF0A43A4),
//               Color(0xFF0D56D5),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: ElevatedButton(
//           onPressed: () {
//             final email = emailController.text.trim();
//             final password = passwordController.text.trim();
//             final username = nameController.text.trim();
//             final phone = phoneController.text.trim();

//             // Add validation
//             if (email.isEmpty || password.isEmpty || 
//                 username.isEmpty || phone.isEmpty) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('All fields are required!')),
//               );
//               return;
//             }

//             // Trigger SignUpEvent
//             context.read<AuthBloc>().add(
//                   SignUpEvent(
//                     email: email,
//                     password: password,
//                     username: username,
//                     phone: phone,
//                   ),
//                 );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           child: const Text(
//             'Sign Up',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }