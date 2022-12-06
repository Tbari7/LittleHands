import 'package:flutter/material.dart';
import 'package:little_hands/app_config/common/constants/app_color/app_color.dart';
import 'package:little_hands/app_config/common/widget/app_button.dart';
import '../../app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import '../../app_config/common/constants/app_strings/app_strings.dart';
import '../../app_config/shared_pref/shared_pref.dart';

/// For age 1 and 2 only true/false quiz is available and child will got 10 out 0f 10 points.
/// for age 3 multiple choice quiz will display which will little bit hard.

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _pageController = PageController();
  bool _isShowSubmitButton = false;
  int _correctAnswer = 0;
  int? _selectedAnswer;
  final List<int> _selectedAnswerList = [];

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.quiz),
        centerTitle: true,
      ),
      body: SharedPref.getChildAge != null && SharedPref.getChildAge == 3
          ? _ageThreeQuizView()
          : _ageOneTwoQuizView(),
    );
  }

  Widget _ageOneTwoQuizView() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppAssetImages.alphabetImagesForQuizForAgeOneAndTwo.length,
      itemBuilder: (itemBuilder, index) {
        return _listItemsViewForAgeOneAndTwo(
          index: index,
          alphabetImage:
              AppAssetImages.alphabetImagesForQuizForAgeOneAndTwo[index],
        );
      },
    );
  }

  Widget _listItemsViewForAgeOneAndTwo(
      {required String alphabetImage, required int index}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(alphabetImage),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(flex: 20),
          Row(
            children: [
              AppButton(
                onPressed: () => _onPressTrue(index),
                text: "TRUE",
                isLoading: false,
              ),
              const Spacer(),
              AppButton(
                color: AppColor.red,
                onPressed: () => _onPressFalse(index),
                text: "FALSE",
                isLoading: false,
              ),
            ],
          ),
          const Spacer(),
          if (_isShowSubmitButton)
            AppButton(
              onPressed: () {
                _showDialog(
                  text: "Awesome ${SharedPref.getChildName}",
                  isBack: true,
                );
              },
              text: "SUMIT",
              isLoading: false,
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _onPressTrue(int index) async {
    if (index == 9) {
      _correctAnswer = 10;
      _isShowSubmitButton = true;
      setState(() {});
    }
    _showDialog(
        text: "Your answer is right.", isBack: false, isShowButton: false);
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.of(context).pop();
      },
    );
    if (index != 9) {
      _pageController.jumpToPage(index + 1);
    }
  }

  void _onPressFalse(int index) {
    if (index == 9) {
      _correctAnswer = 9;
      if (_correctAnswer == 10) {
        _isShowSubmitButton = true;
      } else {
        _isShowSubmitButton = false;
      }
      setState(() {});
    }
    _showDialog(
      text: AppStrings.wrongAsnwerMsg,
      isBack: false,
    );
  }

  Widget _ageThreeQuizView() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppAssetImages.alphabetImagesForQuizForAgeThree.length,
      itemBuilder: (itemBuilder, index) {
        return _listItemsViewForAgeThree(
          images: AppAssetImages.alphabetImagesForQuizForAgeThree[index],
          pageIndex: index,
        );
      },
    );
  }

  Widget _listItemsViewForAgeThree(
      {required List<String> images, required int pageIndex}) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          "${AppStrings.quizAlphabetList[pageIndex]} for _____ ?",
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          itemCount: images.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (itemBuilder, itemIndex) {
            return RadioListTile<int>(
              value: itemIndex,
              secondary: Image.asset(images[itemIndex]),
              contentPadding: const EdgeInsets.all(20),
              groupValue: _selectedAnswer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: _selectedAnswer == itemIndex
                        ? AppColor.primary
                        : AppColor.transparent,
                    width: 2.0),
              ),
              onChanged: (int? value) {
                _selectedAnswer = value;
                setState(() {});
              },
            );
          },
        ),
        const SizedBox(height: 30),
        if (_selectedAnswer != null && pageIndex != 9)
          AppButton(
            onPressed: () {
              _selectedAnswerList.add(_selectedAnswer!);
              _selectedAnswer = null;
              _pageController.jumpToPage(pageIndex + 1);
            },
            text: "NEXT",
            isLoading: false,
          ),
        if (_selectedAnswer != null && pageIndex == 9)
          AppButton(
            onPressed: () {
              _selectedAnswerList.add(_selectedAnswer!);
              setState(() {});
              for (int i = 0; i < _selectedAnswerList.length; i++) {
                if (_selectedAnswerList[i] == AppStrings.correctAnswers[i]) {
                  _correctAnswer++;
                }
              }
              _showDialog(
                  text:
                      "${_correctAnswer >= 9 ? 'Awesome' : _correctAnswer >= 8 ? 'Very Good' : _correctAnswer >= 6 ? 'Good' : 'Need more preparation'} ${SharedPref.getChildName}",
                  isBack: true);
            },
            text: "SUBMIT",
            isLoading: false,
          )
      ],
    );
  }

  Future<void> _showDialog(
      {required String text,
      required bool isBack,
      bool isShowButton = true}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () async {
            if (isBack) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              return false;
            } else {
              return true;
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(25),
            icon: Center(
              child: Text(
                text,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            title: isBack
                ? Center(child: Text("You got $_correctAnswer out of 10."))
                : null,
            content: isShowButton
                ? AppButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (isBack) {
                        Navigator.of(context).pop();
                      }
                    },
                    text: isBack ? "Back" : "Try Again",
                    isLoading: false,
                  )
                : null,
          ),
        );
      },
    );
  }
}
