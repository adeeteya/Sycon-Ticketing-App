import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sycon_ticketing_app/api_keys.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/screens/home.dart';
import 'package:sycon_ticketing_app/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: kApiKey,
        appId: kAppId,
        messagingSenderId: kMessagingSenderId,
        projectId: kProjectId,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const ProviderScope(child: SyconTicketingApp()));
}

class SyconTicketingApp extends StatelessWidget {
  const SyconTicketingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NunitoSans',
        scaffoldBackgroundColor: kAlabasterWhite,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: kAlabasterWhite,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'NunitoSans',
            color: kRichBlack,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: kCeruleanBlue,
            minimumSize: const Size(double.infinity, 0),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: kSchoolBusYellow,
              secondary: kCeruleanBlue,
            ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Home();
        }
        return const LoginScreen();
      },
    );
  }
}
