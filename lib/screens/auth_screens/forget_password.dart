import 'package:flutter/material.dart';
import 'package:little_hands/app_config/firebase_auth_service/firebase_auth_service.dart';

import '../../app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import '../../app_config/common/constants/app_regexp/app_regexp.dart';
import '../../app_config/common/constants/app_strings/app_strings.dart';
import '../../app_config/common/widget/app_button.dart';
import '../../app_config/common/widget/app_text_field.dart';
import '../../app_config/common/widget/app_toast.dart';


/// If user forgot password of the logged in email then user will provide email and send
/// request for reset password and if the request successfully submitted then an reset password
/// link send to the registered email.


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
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
          alignment: Alignment.topCenter,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _backArrowView(),
                SizedBox(height: MediaQuery.of(context).size.height*0.25),
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _getEmailField(),
                const SizedBox(height: 20),
                AppButton(
                  isLoading: _isLoading,
                  onPressed: () {
                    if (!_isLoading) _resetPassword();
                  },
                  text: 'Forgot Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getEmailField() {
    return AppTextFormField(
      controller: _emailController,
      labelText: "Email",
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email),
    );
  }

  Widget _backArrowView() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    if (_emailController.text.isEmpty) {
      AppToast(msg: "Email ${AppStrings.emptyErrMsg}");
    } else if (!AppRegExp.validEmailRegExp
        .hasMatch(_emailController.text.trim())) {
      AppToast(msg: "Invalid mail.");
    } else {
      _isLoading = true;
      setState(() {});
      Map<String, dynamic> resetPasswordResponse = await FirebaseAuthService
          .instance
          .resetPassword(email: _emailController.text.trim());
      _isLoading = false;
      setState(() {});
      AppToast(msg: resetPasswordResponse['msg'],
          isBackgroundRedColor: !resetPasswordResponse['isSendEmail']);
      if (resetPasswordResponse['isSendEmail'] && mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
