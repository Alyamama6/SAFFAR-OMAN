import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Welcome.dart';
import 'accounttype.dart';
import 'touristlogin.dart';
import 'touristreg.dart';
import 'guidereg.dart';
import 'explore.dart';
import 'guidehome.dart';
import 'admindashboard.dart';
import 'forgetpass.dart';
import 'verificationcode.dart';
import 'resetpass.dart';
import 'passsaved.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SaffarOmanApp());
}

class SaffarOmanApp extends StatelessWidget {
  const SaffarOmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saffar Oman',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/chooseAccountType': (context) => const ChooseAccountTypeScreen(),
        '/touristLogin': (context) => const TouristLoginScreen(),
        '/touristRegister': (context) => const TouristRegisterScreen(),
        '/guideRegistration': (context) => const GuideRegistrationScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/verifyOtp': (context) => const VerificationCodeScreen(),
        '/resetPassword': (context) => const ResetPasswordScreen(),
        '/passwordSaved': (context) => const PasswordSavedScreen(),
        '/adminDashboard': (context) => const AdminDashboardScreen(),
        '/explore': (context) => const ExploreScreen(),
        '/guideHome': (context) => const GuideHomeScreen(),
      },
    );
  }
}
