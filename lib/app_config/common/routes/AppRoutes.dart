import 'package:flutter/material.dart';
import 'package:little_hands/screens/auth_screens/forget_password.dart';
import 'package:little_hands/screens/basic_details_screen/gender.dart';
import 'package:little_hands/screens/basic_details_screen/name_age.dart';
import 'package:little_hands/screens/learning_screens/dashboard.dart';
import 'package:little_hands/screens/learning_screens/quiz.dart';
import '../../../screens/auth_screens/sign_in.dart';
import '../../../screens/auth_screens/sign_up.dart';
import '../../../screens/learning_screens/alphabet.dart';
import '../../../screens/splash.dart';

class AppRoutes {
  AppRoutes._private();

  static const String splashScreen = "/";
  static const String alphabetScreen = "/alphabet_screen";
  static const String signInScreen = "/sign_in_screen";
  static const String signUpScreen = "/sign_up_screen";
  static const String genderScreen = "/gender_screen";
  static const String nameAgeScreen = "/name_age_screen";
  static const String dashboardScreen = "/dashboard_screen";
  static const String quizScreen = "/quiz_screen";
  static const String forgetPasswordScreen = "/forget_password_screen";

  static GenerateRoutes onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return GenerateRoutes(child: const SplashScreen());
      case signInScreen:
        return GenerateRoutes(child: const SignInScreen());
      case signUpScreen:
        return GenerateRoutes(child: const SignUpScreen());
      case forgetPasswordScreen:
        return GenerateRoutes(child: const ForgetPasswordScreen());
      case nameAgeScreen:
        return GenerateRoutes(child: const NameAgeScreen());
      case genderScreen:
        return GenerateRoutes(child: const GenderScreen());
      case dashboardScreen:
        return GenerateRoutes(child: const DashboardScreen());
      case alphabetScreen:
        return GenerateRoutes(child: const AlphabetScreen());
      case quizScreen:
        return GenerateRoutes(child: const QuizScreen());
      default:
        return GenerateRoutes(child: const SplashScreen());
    }
  }
}

class GenerateRoutes extends MaterialPageRoute {
  final Widget child;

  GenerateRoutes({required this.child})
      : super(builder: (BuildContext context) {
          return child;
        });
}
