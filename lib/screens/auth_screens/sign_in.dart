import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_hands/app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import '../../app_config/common/constants/app_regexp/app_regexp.dart';
import '../../app_config/common/constants/app_strings/app_strings.dart';
import '../../app_config/common/routes/AppRoutes.dart';
import '../../app_config/common/widget/app_button.dart';
import '../../app_config/common/widget/app_text_field.dart';
import '../../app_config/common/widget/app_toast.dart';
import '../../app_config/firebase_auth_service/firebase_auth_service.dart';
import '../../app_config/shared_pref/shared_pref.dart';


/// If the user signed up then fill the email and password which
/// requires minimum 8 characters, 1 upper case, 1 lower case, 1 digit and 1
/// special symbol. Signin using Firebase_auth.
/// If the user credentials are valid then screen will navigate to NameAndAgeScreen
/// Other error message will show.

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isRememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                _signInTitleView(),
                _getCommonSizedBox(),
                _getEmailField(),
                _getCommonSizedBox(),
                _getPasswordField(),
                _isRememberMeView(),
                _signUpView(),
                AppButton(
                  isLoading: _isLoading,
                  onPressed: () {
                    if (!_isLoading) _signInValidate();
                  },
                  text: AppStrings.signIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInTitleView() {
    return const Text(
      AppStrings.signIn,
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
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

  Widget _getPasswordField() {
    return AppTextFormField(
      controller: _passwordController,
      labelText: "Password",
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
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

  Widget _getCommonSizedBox() {
    return const SizedBox(height: 15);
  }

  Widget _signUpView() {
    return Row(
      children: [
        const Text(AppStrings.dontHaveAnAccount),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.signUpScreen);
          },
          child: const Text(
            AppStrings.signUp,
          ),
        )
      ],
    );
  }

  Widget _isRememberMeView() {
    return Row(
      children: [
        Checkbox(
          value: _isRememberMe,
          onChanged: (value) {
            _isRememberMe = value!;
            setState(() {});
          },
        ),
        const Text("Remember me"),
        const Spacer(),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.forgetPasswordScreen);
            },
            child: const Text("Forgot password"))
      ],
    );
  }

  void _signInValidate() {
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
    } else {
      _signIn();
    }
  }

  void _signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _isLoading = true;
    setState(() {});
    Map<String, dynamic> signInResponse =
        await FirebaseAuthService.instance.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    _isLoading = false;
    setState(() {});
    if (signInResponse['isSignIn'] && mounted) {
      AppToast(msg: signInResponse['message'], isBackgroundRedColor: false);
      SharedPref.setIsRememberMe = _isRememberMe;
      User user = signInResponse['userDetails'] as User;
      SharedPref.setUserDetails = user.email ?? "";
      Navigator.of(context).pushReplacementNamed(AppRoutes.nameAgeScreen);
    } else {
      AppToast(msg: signInResponse['message']);
    }
  }
}
