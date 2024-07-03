import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/login_screen.dart';
import 'package:flutter_auth/services/authentication.dart';
import 'package:flutter_auth/widget/button.dart';
import 'package:flutter_auth/widget/custom_inkwell.dart';
import 'package:flutter_auth/widget/snackbar.dart';

import '../widget/text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthServices();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Forgot Password'),
        leading: CustomInkwell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            },
            child: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Enter the email to reset the password'),
              TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                labelText: 'Email',
              ),
              MyButtons(
                  onTap: () {
                    _auth.sendPasswordResetLink(emailController.text);
                    showSnackBar(context, 'Reset Password Sent Successfully');
                    Navigator.of(context).pop();
                  },
                  text: "Send Email"),
            ],
          ),
        ],
      ),
    );
  }
}
