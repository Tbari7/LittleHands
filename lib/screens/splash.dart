import 'package:flutter/material.dart';
import '../app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import '../app_config/common/routes/AppRoutes.dart';
import '../app_config/shared_pref/shared_pref.dart';



/// Splash screen is the first screen which is visible for sometime
/// If remember me false and user info is empty then screen wll navigate
/// to SignIn Screen Otherwise it will navigate to NameAndAge Screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted &&
            SharedPref.getIsRememberMe &&
            SharedPref.getUserDetails.isNotEmpty) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.nameAgeScreen);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.signInScreen);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssetImages.splashScreenLogo,
            ),
          ),
        ),
      ),
    );
  }
}
