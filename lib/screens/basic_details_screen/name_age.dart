import 'package:flutter/material.dart';
import 'package:little_hands/app_config/common/constants/app_color/app_color.dart';
import 'package:little_hands/app_config/common/constants/app_strings/app_strings.dart';
import 'package:little_hands/app_config/common/routes/AppRoutes.dart';
import 'package:little_hands/app_config/common/widget/app_radio_button.dart';
import 'package:little_hands/app_config/common/widget/app_button.dart';
import 'package:little_hands/app_config/common/widget/app_text_field.dart';
import 'package:little_hands/app_config/common/widget/app_toast.dart';
import 'package:little_hands/app_config/shared_pref/shared_pref.dart';
import '../../app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';


/// User needs to fill the name of the child and select the age of the child by default the age
/// of the child is 1 selected and after that user will navigate to Gender screen
/// All this data will save in the local storage of the phone.

class NameAgeScreen extends StatefulWidget {
  const NameAgeScreen({Key? key}) : super(key: key);

  @override
  State<NameAgeScreen> createState() => _NameAgeScreenState();
}

class _NameAgeScreenState extends State<NameAgeScreen> {
  int _selectedAge = 1;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          margin: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                AppAssetImages.loginScreenImg,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                _nameFieldView(),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Text("Select Age"),
                    Text("*", style: TextStyle(color: AppColor.red)),
                  ],
                ),
                AppRadioButton<int>(
                  onChanged: (int? value) {
                    _selectedAge = value!;
                    setState(() {});
                  },
                  value: 1,
                  groupValue: _selectedAge,
                  text: "1",
                ),
                AppRadioButton<int>(
                  onChanged: (int? value) {
                    _selectedAge = value!;
                    setState(() {});
                  },
                  value: 2,
                  groupValue: _selectedAge,
                  text: "2",
                ),
                AppRadioButton<int>(
                  onChanged: (int? value) {
                    _selectedAge = value!;
                    setState(() {});
                  },
                  value: 3,
                  groupValue: _selectedAge,
                  text: "3",
                ),
                const SizedBox(height: 20),
                Center(
                  child: AppButton(
                    onPressed: () {
                      _saveInfo();
                    },
                    text: "Next",
                    isLoading: false,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

/*  Widget _selectAgeView() {
    return AppDropDownButton<int>(
      hintText: "Select Age",
      items: AppStrings.ageList
          .map(
            (e) => DropdownMenuItem<int>(
              value: e,
              child: Text("Age of child is $e"),
            ),
          )
          .toList(),
      onChanged: (int? value) {
        _selectedAge = value;
        setState(() {});
      },
    );
  }*/

  Widget _nameFieldView() {
    return AppTextFormField(
      controller: _nameController,
      labelText: "Name of child",
    );
  }

  void _saveInfo() {
    if (_nameController.text.trim().isEmpty) {
      AppToast(msg: "Name ${AppStrings.emptyErrMsg}");
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      SharedPref.setChildAge = _selectedAge;
      SharedPref.setChildName = _nameController.text.trim();
      Navigator.of(context).pushNamed(AppRoutes.genderScreen);
    }
  }
}
