import 'package:flutter/material.dart';
import '../Widget/button.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import '../services/authentication.dart';
import '../widget/custom_inkwell.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateInputs);
    passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final emailError = validateEmail(emailController.text);
    final passwordError = validatePassword(passwordController.text);

    setState(() {
      isButtonEnabled = emailError == null && passwordError == null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  String? validateEmail(String email) {
    final emailPattern = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailPattern.hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  void signupUser() async {
    final emailError = validateEmail(emailController.text);
    final passwordError = validatePassword(passwordController.text);

    if (emailError != null) {
      showSnackBar(context, emailError);
      return;
    }

    if (passwordError != null) {
      showSnackBar(context, passwordError);
      return;
    }

    // set is loading to true.
    setState(() {
      isLoading = true;
    });

    // signup user using our auth method
    String res = await AuthServices().signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);

    // if string return is success, user has been created and navigate to next screen otherwise show error.
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      // navigate to the next screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text,
                labelText: 'Name',
              ),
              TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                labelText: 'Email',
              ),
              TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
                labelText: 'Password',
              ),
              MyButtons(onTap: signupUser, text: "Sign Up"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  CustomInkwell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
