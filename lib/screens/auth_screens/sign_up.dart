import 'package:flutter/material.dart';
import '../../app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import '../../app_config/common/constants/app_regexp/app_regexp.dart';
import '../../app_config/common/constants/app_strings/app_strings.dart';
import '../../app_config/common/widget/app_button.dart';
import '../../app_config/common/widget/app_text_field.dart';
import '../../app_config/common/widget/app_toast.dart';
import '../../app_config/firebase_auth_service/firebase_auth_service.dart';


/// If user want to sign in the application then first user needs to create and account
/// with email and strong password (minimum 8 characters, 1 upper case, 1 lower case, 1
/// digit and 1 special symbol). If user account created successfully screen will naviagte
/// to signin screen otherwise an error message will show.

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          alignment: Alignment.center,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                const Text(
                  AppStrings.signUp,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _getCommonSizedBox(),
                _getEmailField(),
                _getCommonSizedBox(),
                _getPasswordField(),
                _getCommonSizedBox(),
                _getConfirmPasswordField(),
                _getCommonSizedBox(),
                AppButton(
                  isLoading: _isLoading,
                  onPressed: () {
                    if (!_isLoading) _signUpValidate();
                  },
                  text: AppStrings.signUp,
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
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.email),
    );
  }

  Widget _getPasswordField() {
    return AppTextFormField(
      controller: _passwordController,
      labelText: "Password",
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      suffixIcon: IconButton(
        splashRadius: 20,
        onPressed: () {
          setState(() {
            if (_isPasswordVisible) {
              _isPasswordVisible = false;
            } else {
              _isPasswordVisible = true;
            }
          });
        },
        icon: const Icon(Icons.password),
      ),
      obscureText: _isPasswordVisible,
    );
  }

  Widget _getConfirmPasswordField() {
    return AppTextFormField(
      controller: _confirmPasswordController,
      labelText: "Confirm Password",
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      suffixIcon: IconButton(
        splashRadius: 20,
        onPressed: () {
          setState(() {
            if (_isConfirmPasswordVisible) {
              _isConfirmPasswordVisible = false;
            } else {
              _isConfirmPasswordVisible = true;
            }
          });
        },
        icon: const Icon(Icons.password),
      ),
      obscureText: _isConfirmPasswordVisible,
    );
  }

  Widget _getCommonSizedBox() {
    return const SizedBox(height: 15);
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

  void _signUpValidate() {
    if (_emailController.text.isEmpty) {
      AppToast(msg: "Email ${AppStrings.emptyErrMsg}");
    } else if (!AppRegExp.validEmailRegExp
        .hasMatch(_emailController.text.trim())) {
      AppToast(msg: "Invalid mail.");
    } else if (_passwordController.text.isEmpty) {
      AppToast(msg: "Password ${AppStrings.emptyErrMsg}");
    } else if (!AppRegExp.strongPasswordRegExp
        .hasMatch(_passwordController.text.trim())) {
      AppToast(msg: AppStrings.passwordStrongErrMsg);
    } else if (_confirmPasswordController.text.isEmpty) {
      AppToast(msg: "Confirm Password ${AppStrings.emptyErrMsg}");
    } else if (_confirmPasswordController.text.trim() !=
        _passwordController.text.trim()) {
      AppToast(msg: "Password not matched.");
    } else {
      _signUp();
    }
  }

  void _signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _isLoading = true;
    setState(() {});
    Map<String, dynamic> signUpResponse =
        await FirebaseAuthService.instance.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    _isLoading = false;
    setState(() {});
    if (signUpResponse['isSignUp'] && mounted) {
      AppToast(
        msg: signUpResponse['message'],
        isBackgroundRedColor: false,
      );
      Navigator.of(context).pop();
    } else {
      AppToast(msg: signUpResponse['message']);
    }
  }
}
