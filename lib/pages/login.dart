// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopgoes/auth/auth_service.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/pages/reset.dart';
import 'package:shopgoes/pages/signup.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/bottomnav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isobscure = true;
  bool _isLoading = false;
  bool _isgoogle = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: context.px(150),
                width: context.px(150),
                child: ClipRRect(
                  borderRadius: context.radius(12),
                  child: Image.asset("assets/images/coplogo.jpg"),
                ),
              ),
              context.sbHeight(20),

              // Email Field
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Password Field
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: passwordController,
                  obscureText: isobscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isobscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isobscure = !isobscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button with CircularProgressIndicator
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(btcolor),
                        foregroundColor: WidgetStatePropertyAll(
                          txtColor,
                        ),
                        shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Email and Password cannot be empty')),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);

                          try {
                            User? user =
                                await AuthService.signInWithEmail(email, password);
                            if (user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => Bottomnav()),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String message = 'Login failed';
                            if (e.code == 'user-not-found') {
                              message = 'No user found for this email';
                            } else if (e.code == 'wrong-password') {
                              message = 'Incorrect password';
                            } else if (e.code == 'invalid-email') {
                              message = 'Invalid email format';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Something went wrong')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: txtColor,
                        )
                      : const Text("Login with Email"),
                ),
              ),

              const SizedBox(height: 10),

              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(btcolor),
                        foregroundColor: WidgetStatePropertyAll(
                          txtColor,
                        ),
                        shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: _isgoogle
                      ? null
                      : () async {
                          setState(() => _isgoogle = true);

                          User? user = await AuthService.signInWithGoogle();
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Bottomnav()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login with Google")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Google Login Failed or Cancelled")),
                            );
                          }

                          setState(() => _isgoogle = false);
                        },
                  child: _isgoogle
                      ? const CircularProgressIndicator(
                          color:txtColor,
                        )
                      : const Text("Login with Google"),
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Text("Forgot Password?"),
              ),

              // Sign Up
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
