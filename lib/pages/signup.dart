// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopgoes/auth/auth_service.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/pages/login.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/bottomnav.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogle = false;

  // 👁 Password visibility flags
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.px(400)),
            child: Form(
              key: _formKey,
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

                  // Email
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: context.radius(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!value.contains("@gmail.com")) {
                          return "Only Gmail addresses are allowed";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Password
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: context.radius(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: validatePassword,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Confirm Password
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: context.radius(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50, // TextField height ke barabar
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
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        setState(() => _isLoading = true);

                        try {
                          User? user = await AuthService.signUpWithEmail(
                            email,
                            password,
                          );
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Bottomnav()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Sign Up Successful!"),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          String message = "Sign Up failed";
                          if (e.code == 'email-already-in-use') {
                            message = "This email is already registered";
                          } else if (e.code == 'invalid-email') {
                            message = "Invalid email format";
                          } else if (e.code == 'weak-password') {
                            message = "Password is too weak";
                          }
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong"),
                            ),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: txtColor,
                              ),
                            )
                          : const Text("Sign Up"),
                    ),
                  ),

                  const SizedBox(height: 20),
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
                      onPressed: _isGoogle
                          ? null
                          : () async {
                              setState(() => _isGoogle = true);

                              try {
                                User? user =
                                    await AuthService.signInWithGoogle();
                                if (user != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Bottomnav(),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Login with Google"),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Google Login Failed or Cancelled",
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Something went wrong"),
                                  ),
                                );
                              } finally {
                                setState(() => _isGoogle = false);
                              }
                            },
                      child: _isGoogle
                          ? const CircularProgressIndicator(
                              color:txtColor,
                            )
                          : const Text("Login with Google"),
                    ),
                  ),

                  context.sbHeight(20),

                  // Redirect to Login
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text("Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Password Validator (alphabet + number + special char + min 8 length)
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    final regex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
    );

    if (!regex.hasMatch(value)) {
      return "Password must be at least 8 characters,\ninclude a letter, number & special character";
    }

    return null;
  }
}
