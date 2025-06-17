import 'package:advaita_ticket_validator/authentication/login_backend.dart';
import 'package:advaita_ticket_validator/utilities/my_button.dart';
import 'package:advaita_ticket_validator/utilities/my_textbox.dart';
import 'package:advaita_ticket_validator/utilities/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/advaita_logo.png', height: 300),
                MyTextfield(
                  emailController,
                  label: 'Username',
                  icon: false,
                  hintText: "Enter your Username",
                ),
                MyTextfield(
                  passwordController,
                  label: 'Password',
                  obscure: true,
                  icon: true,
                  hintText: "Keep your password safe",
                ),
                SizedBox(height: 20),
                MyButton(
                  onTap: () async {
                    if (emailController.text.isEmpty) {
                      Utils.flushbarErrorMessage('Enter Username', context);
                    } else if (passwordController.text.isEmpty) {
                      Utils.flushbarErrorMessage('Enter Password', context);
                    } else {
                      Map<String, String> user = {
                        'username': emailController.text.trim(),
                        'password': passwordController.text.trim(),
                      };
                      await loginViewModel.loginUser(user, context);
                    }
                  },
                  title: "Log In",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
