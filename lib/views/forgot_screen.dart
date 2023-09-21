// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/global_vairable.dart';
import '../widgets/text_field_input.dart';
import 'login_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  sendMail() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    if (_emailController.text.trim() == '' ||
        EmailValidator.validate(_emailController.text.trim())) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );

        showDialoguePop(
          context,
          'Email Sent',
          'The request for reset password has been sent to your email.',
          40,
          50,
          'Dismiss',
        ).then((value) => navigateToLogin());
        setState(() {
          _isLoading = false;
        });
      } on FirebaseException catch (e) {
        debugPrint(e.code);
        showDialoguePop(
            context, e.message.toString(), 'The entered email is invalid');
        // Navigator.pop(context);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      showDialoguePop(
        context,
        'Invalid Email',
        "The email you entered doesn't appear to belong to an account. Please check your email and try again.",
        80,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Reset you password',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.pink
                            : Colors.purple,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    blankSpace(15),
                    Text(
                      'Enter your email linked\nto your account',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              blankSpace(24),
              TextFieldInput(
                controller: _emailController,
                hintText: 'Enter Email',
                textInputType: TextInputType.emailAddress,
              ),
              blankSpace(24),
              InkWell(
                onTap: _isLoading ? () {} : sendMail,
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
                      :const Text(
                          'Send Email',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              GestureDetector(
                onTap: navigateToLogin,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Goto ',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade500
                              : Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Login.',
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
              blankFlex(1),
            ],
          ),
        ),
      ),
    );
  }
}
