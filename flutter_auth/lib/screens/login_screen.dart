import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/forgot_password.dart';
import 'package:flutter_auth/services/authentication.dart';
import '../Widget/button.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import '../widget/custom_inkwell.dart';
import 'home_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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

// email and passowrd auth part
  void loginUser() async {
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
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthServices().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
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
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldInput(
                      icon: Icons.person,
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.text,
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
                  //  we call our forgot password below the login in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomInkwell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const ForgotPassword();
                            },
                          ));
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  MyButtons(onTap: loginUser, text: "Log In"),

                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      ),
                      const Text("  or  "),
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      )
                    ],
                  ),
                  // for google login
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  //   child: ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  //     onPressed: () async {
                  //       // await FirebaseServices().signInWithGoogle();
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const HomeScreen(),
                  //         ),
                  //       );
                  //     },
                  //     child: Row(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 8),
                  //           child: Image.network(
                  //             "https://ouch-cdn2.icons8.com/VGHyfDgzIiyEwg3RIll1nYupfj653vnEPRLr0AeoJ8g/rs:fit:456:456/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODg2/LzRjNzU2YThjLTQx/MjgtNGZlZS04MDNl/LTAwMTM0YzEwOTMy/Ny5wbmc.png",
                  //             height: 35,
                  //           ),
                  //         ),
                  //         const SizedBox(width: 10),
                  //         const Text(
                  //           "Continue with Google",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 20,
                  //             color: Colors.white,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // for phone authentication
                  //  const PhoneAuthentication(),
                  // Don't have an account? got to signup screen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      CustomInkwell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // kIsWeb
            //     ? Image.asset(
            //         'assets/loginpage.png',
            //         width: width / 2,
            //         height: height / 2,
            //       )
            //     : const SizedBox.shrink()
          ],
        ),
      )),
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black45,
          width: 2,
        ),
      ),
      child: Image.network(
        image,
        height: 40,
      ),
    );
  }
}
