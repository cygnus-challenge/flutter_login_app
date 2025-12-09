import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_pallet.dart';
import 'auth_field.dart';
import 'auth_gradient_button.dart';

import '../controller/login_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title with Gradient Shader
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          AppPallet.gradient1,
                          AppPallet.gradient3,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppPallet.whiteColor,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Login Form
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Field for writing username
                          AuthField(
                              hintText: "Username", controller: usernameController),
                          const SizedBox(height: 15),
                          // Field for writing password
                          AuthField(
                              hintText: "Password",
                              controller: passwordController),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromARGB(255, 190, 10, 10),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 150),
                        ],
                      )),
                  // Sign In Button
                  AuthGradientButton(
                    buttonText: "Sign In",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<LoginController>().login(
                              usernameController.text.trim(),
                              passwordController.text.trim(),
                            );
                        // 
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                        text: ('Don\'t have an account? '),
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                      TextSpan(
                        text: 'Register',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppPallet.gradient2,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                  ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}