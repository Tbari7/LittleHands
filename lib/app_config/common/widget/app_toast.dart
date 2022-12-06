import 'package:fluttertoast/fluttertoast.dart';
import '../constants/app_color/app_color.dart';

class AppToast {
  AppToast({required String msg, bool isBackgroundRedColor = true}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: isBackgroundRedColor ? AppColor.red : AppColor.primary,
      textColor: AppColor.white,
      fontSize: 16.0,
    );
  }
}
