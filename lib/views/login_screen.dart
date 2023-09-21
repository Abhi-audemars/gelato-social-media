// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_clone/views/forgot_screen.dart';
import 'package:insta_clone/views/signup_screen.dart';
import 'package:rive/rive.dart';
import 'package:shimmer/shimmer.dart';
import '../resources/firestore_methods.dart';
import '/resources/auth_methods.dart';
import '/utils/colors.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/global_vairable.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  StateMachineController? machineController;

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  login() async {
    setState(() {
      _isLoading = true;
    });
    List<String> res = await AuthMethods().loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() {
      _isLoading = false;
    });
    if (res[0] != 'success') {
      showDialoguePop(context, res[0], res[1], 85);
    } else {
      FirestoreMethods().updateStatus('Online');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void navigateToForgotPassword() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ForgotScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Shimmer.fromColors(
          baseColor: Colors.purple,
          highlightColor: Colors.pinkAccent,
          child: Text(
            'GELATO',
            style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            blankFlex(1),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: RiveAnimation.asset(
                'assets/images/animated.riv',
                stateMachines: const ['Login Machine'],
                onInit: (artboard) {
                  machineController = StateMachineController.fromArtboard(
                      artboard, 'Login Machine');
                  if (machineController == null) {
                    return;
                  }
                  artboard.addController(machineController!);
                  isChecking = machineController?.findInput('isChecking');
                  isHandsUp = machineController?.findInput('isHandsUp');
                  trigSuccess = machineController?.findInput('trigSuccess');
                  trigFail = machineController?.findInput('trigFail');
                },
                fit: BoxFit.cover,
              ),
            ),
            // TextFieldInput(

            //   controller: _emailController,
            //   hintText: 'Enter Email',
            //   textInputType: TextInputType.emailAddress,
            // ),
            TextField(
              onChanged: (value) {
                if (isHandsUp != null) {
                  isHandsUp!.change(false);
                }
                if (isChecking == null) {
                  return;
                }
                isChecking!.change(true);
              },
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                enabledBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                focusedBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                filled: true,
                contentPadding: const EdgeInsets.all(8),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            blankSpace(24),
            // TextFieldInput(
            //   controller: _passwordController,
            //   hintText: 'Enter Password',
            //   obscureText: true,
            //   textInputType: TextInputType.text,
            // ),
            TextField(
              onChanged: (value) {
                if (isChecking != null) {
                  isChecking!.change(false);
                }
                if (isHandsUp == null) {
                  return;
                }
                isHandsUp!.change(true);
              },
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                enabledBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                focusedBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                filled: true,
                contentPadding: const EdgeInsets.all(8),
              ),
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
            ),
            blankSpace(24),
            InkWell(
              onTap: _isLoading ? () {} : login,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: Colors.pink,
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: navigateToForgotPassword,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot your login details? ',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Get help logging in.',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            blankSpace(12),
            blankFlex(2),
            const Divider(),
            GestureDetector(
              onTap: navigateToSignUp,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
                const Text(
                  'Sign up.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
