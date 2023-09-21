// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/views/login_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '/responsive/mobile_screen_layout.dart';
import '/utils/utils.dart';
import '/widgets/text_field_input.dart';
import '../resources/auth_methods.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/global_vairable.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  Future<void> selectImage() async {
    Uint8List imageAsBytes = await pickImage(ImageSource.gallery);
    setState(() {
      _image = imageAsBytes;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    List<String> res = await AuthMethods().signUpUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      file: _image,
    );
    setState(() {
      _isLoading = false;
    });
    if (res[0] != 'success') {
      showDialoguePop(context, res[0], res[1], 50);
    } else {
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
        elevation: 0,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                // SvgPicture.asset(
                //   'assets/images/ic_instagram.svg',
                //   color: Theme.of(context).brightness == Brightness.dark
                //       ? primaryColor
                //       : Colors.black,
                //   height: 64,
                // ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!),
                          )
                        :
                        // CircleAvatar(
                        //     radius: 50,
                        //     child: Lottie.network(
                        //         'https://assets1.lottiefiles.com/packages/lf20_mr1kkmr2.json',
                        //         height: 300,
                        //         width: 300),
                        //     // AssetImage('assets/images/user_default.jpg'),
                        //   ),
                        Lottie.network(
                            'https://assets1.lottiefiles.com/packages/lf20_mr1kkmr2.json',
                            fit: BoxFit.cover),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: selectImage,
                        splashRadius: 25,
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: _usernameController,
                  hintText: 'Enter Username',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: _emailController,
                  hintText: 'Enter Email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: _passwordController,
                  hintText: 'Enter Password',
                  obscureText: true,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: _bioController,
                  hintText: 'Enter your Bio',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _isLoading ? () {} : signUpUser,
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
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                // blankSpace(12),
                // blankFlex(2),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Don't have an account?"),
                      ),
                      const Text(
                        'Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
