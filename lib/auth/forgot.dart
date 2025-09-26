// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reset Password")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Enter your email"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (emailController.text.isEmpty) return;
//                 try {
//                   await FirebaseAuth.instance.sendPasswordResetEmail(
//                       email: emailController.text.trim());
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Reset email sent!")),
//                   );
//                   Navigator.pop(context);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error: ${e.toString()}")),
//                   );
//                 }
//               },
//               child: const Text("Send Reset Link"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
