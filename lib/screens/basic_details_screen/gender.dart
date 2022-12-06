import 'package:flutter/material.dart';
import 'package:little_hands/app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import 'package:little_hands/app_config/common/constants/app_color/app_color.dart';
import 'package:little_hands/app_config/common/routes/AppRoutes.dart';
import 'package:little_hands/app_config/common/widget/app_button.dart';
import 'package:little_hands/app_config/shared_pref/shared_pref.dart';


/// User can select the gender of the child by default gender is girl selected.
/// after that user will navigate to dashboard screen
/// /// All this data will save in the local storage of the phone.


class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  bool _isBoySelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SharedPref.getChildName),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _isBoySelected = false;
                setState(() {});
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isBoySelected
                        ? AppColor.transparent
                        : AppColor.primary,
                    width: 2,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    maxRadius: 60,
                    backgroundImage: AssetImage(AppAssetImages.girlImg),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _isBoySelected = true;
                setState(() {});
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isBoySelected
                        ? AppColor.primary
                        : AppColor.transparent,
                    width: 2,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: CircleAvatar(
                    maxRadius: 60,
                    backgroundImage: AssetImage(
                      AppAssetImages.boyImg,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: () {
                if (_isBoySelected) {
                  SharedPref.setChildGender = "boy";
                } else {
                  SharedPref.setChildGender = "girl";
                }
                Navigator.of(context).pushReplacementNamed(
                    AppRoutes.dashboardScreen);
              },
              text: "Next",
              isLoading: false,
            )
          ],
        ),
      ),
    );
  }
}
