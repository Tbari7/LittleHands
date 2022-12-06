import 'package:flutter/material.dart';
import 'package:little_hands/app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import '../../app_config/common/routes/AppRoutes.dart';
import '../../app_config/common/widget/app_toast.dart';
import '../../app_config/firebase_auth_service/firebase_auth_service.dart';
import '../../app_config/shared_pref/shared_pref.dart';



/// User can navigate to alphabet screen or quiz screen from here

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Letters Numbers Colors Shapes",
        ),
        actions: [
          IconButton(
            onPressed: () {
              _signOut();
            },
            tooltip: "Sign Out",
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: GridView.extent(
          primary: false,
          padding: const EdgeInsets.all(15),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          maxCrossAxisExtent: 200.0,
          children: <Widget>[
            _commonView(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.alphabetScreen),
              image: AppAssetImages.alphabetImg,
            ),
            _commonView(
              image: AppAssetImages.numbersImg,
              onTap: () {},
            ),
            _commonView(
              image: AppAssetImages.colorsImg,
              onTap: () {},
            ),
            _commonView(
              image: AppAssetImages.shapesImg,
              onTap: () {},
            ),
            _commonView(
              image: AppAssetImages.ptestImg,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.quizScreen);
              },
            ),
            _commonView(
              image: AppAssetImages.birdsImg,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _commonView({required String image, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _signOut() {
    FirebaseAuthService.instance.signOut();
    SharedPref.signOut();
    AppToast(msg: "Signout successfully.", isBackgroundRedColor: false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.signInScreen, (route) => false);
  }
}
