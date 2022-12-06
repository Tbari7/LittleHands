import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:little_hands/app_config/shared_pref/shared_pref.dart';
import '../../app_config/common/constants/app_asset/app_asset_images/app_asset_images.dart';
import '../../app_config/common/constants/app_asset/app_asset_sound/AppAssetSound.dart';
import '../../app_config/common/constants/app_color/app_color.dart';
import '../../app_config/common/constants/app_strings/app_strings.dart';

/// For age 1 and 2 only single picture will display for single letter and user can play sound and pronounce the letter
/// For age 3 multiple pictures will show for the single letter and user cannot play the sound of the letter

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final _pageController = PageController();
  final _audioPlayer = AudioPlayer();
  final List<bool> _isPlayList =
      List<bool>.generate(AppStrings.alphabetList.length, (index) => false);

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.alphabet),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: AppStrings.alphabetList.length,
        onPageChanged: (int index) {
          if (SharedPref.getChildAge != null && SharedPref.getChildAge != 3) {
            if (mounted) {
              setState(() {
                _isPlayList[index] = false;
              });
            }
            _audioPlayer.pause();
          }
        },
        itemBuilder: (itemBuilder, index) {
          return _listItemsView(
            alphabetSound: AppAssetSound.alphabetSoundList[index],
            index: index,
            alphabetImage:
                SharedPref.getChildAge != null && SharedPref.getChildAge == 3
                    ? AppAssetImages.alphabetImagesForAgeThree[index]
                    : AppAssetImages.alphabetImagesForAgeOneAndTwo[index],
          );
        },
      ),
    );
  }

  Widget _listItemsView(
      {required String alphabetSound,
      required int index,
      required String alphabetImage}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(alphabetImage),
          fit: BoxFit.contain,
        ),
      ),
      alignment: Alignment.topCenter,
      child: SharedPref.getChildAge != null && SharedPref.getChildAge != 3
          ? IconButton(
              splashRadius: 40,
              iconSize: 50,
              onPressed: () async {
                _playPauseAudio(
                  alphabetSound: alphabetSound,
                  index: index,
                );
              },
              color: AppColor.primary,
              icon: Icon(
                _isPlayList[index]
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
              ),
            )
          : null,
    );
  }

  void _playPauseAudio(
      {required String alphabetSound, required int index}) async {
    if (_isPlayList[index] && mounted) {
      setState(() {
        _isPlayList[index] = false;
      });
      await _audioPlayer.pause();
    } else {
      if (mounted) {
        setState(() {
          _isPlayList[index] = true;
        });
      }
      await _audioPlayer.play(AssetSource(alphabetSound));
      Future<void>.delayed(
        const Duration(seconds: 1, milliseconds: 1000),
        () {
          if (mounted) {
            setState(() {
              _isPlayList[index] = false;
            });
          }
        },
      );
    }
  }
}
