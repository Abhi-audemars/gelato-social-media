import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/firebase_options.dart';
import 'package:provider/provider.dart';
import 'controller/user_provider.dart';
import 'responsive/mobile_screen_layout.dart';
import 'responsive/responsive_layout.dart';
import 'responsive/web_screen_layout.dart';
import 'views/login_screen.dart';
import 'utils/colors.dart';
import 'utils/global_vairable.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  } else {
    await Firebase.initializeApp();
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gelato',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor:const Color(0xffD6E2EA),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: mobileBackgroundColor,
            ),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: mobileBackgroundColor,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
        home:
        StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularIndicator(context);
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
