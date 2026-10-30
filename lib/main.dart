import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/phone_login_screen.dart';

void main() {
  runApp(const CareBridgeApp());
}

class CareBridgeApp extends StatelessWidget {
  const CareBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareBridge',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      // L'app démarre maintenant sur l'écran de connexion, plus directement
      // sur HomeShell. On n'arrive à HomeShell qu'après un OTP validé
      // (voir otp_verification_screen.dart).
      home: const PhoneLoginScreen(),
    );
  }
}