import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/model/utils.dart';

// The GetX implementation of Theme/Colour system for the application.
class ColorController extends GetxController {

  // The background colour of the application. This changes depending on the Theme Mode.
  Color get backColor => (isLightMode)?(Color(0xFFFFFFFF)):(Color(0xFFFFFFFF));

  Color get contrastColor => (isLightMode)?(Color(0xFFF7F7F7)):(Color(0xFFF7F7F7));

  Color get borderColor => (isLightMode)?(Color(0xFFE5E5E5)):(Color(0xFFE5E5E5));

  // The foreground colour or the colour that is always in contrast to the background colour of the application. This also changes depending on the Theme Mode.
  Color get foreColor => (isLightMode)?(Color(0xFF373737)):(Color(0xFF373737));

  // The styling colour used to identify important elements in the application. In our case, the `style` colour doesn't change value, but can be used as a varying colour in different modes.
  Color get btnPrimaryColor => (isLightMode)? Color(0xFF1AAD81) : Color(0xFF1AAD81);

  // The colour used to make elements standout from those elements that use the styling colour. Or the colour that is used other than the `style` colour.
  Color get btnSecondaryColor => (isLightMode)? Color(0xFF6E6FA4) : Colors.white;

  Color get textColor => (isLightMode)? Color(0xFF505050) : Color(0xFF505050);

  Color get lightTextColor => (isLightMode)? Color(0xFF949494) : Color(0xFF949494);

  Color get contrastTextColor => (isLightMode)? Color(0xFF848484) : Color(0xFF848484);

  // Used just to group all necessary colours in one single class.
  Color get white => Colors.white;

  // Used just to group all necessary colours in one single class.
  Color get black => Color(0xFF222222);

  Color get warn => Color(0xFFC31C1C);
  Color get warnBack => Color(0x33D91717);

  // The most important variable in the Theme System as it determines the colours of various elements.
  RxBool _isDarkMode = false.obs;

  // Tells whether the app is in dark mode.
  bool get isDarkMode => _isDarkMode.value;

  // Tells whether the app is in light mode.
  bool get isLightMode => !(_isDarkMode.value);


  // Switches theme between Dark and Light modes. Also can be customised depending on the value passed to the function.
  void themeSwitcher(ThemeSwitchMode mode) {
    if(mode == ThemeSwitchMode.light) {
      if(isDarkMode) {
        _isDarkMode.value = !_isDarkMode.value;
      }
    } else if(mode == ThemeSwitchMode.dark) {
      if(isLightMode) {
        _isDarkMode.value = !_isDarkMode.value;
      }
    } else {
      _isDarkMode.value = !_isDarkMode.value;
    }
  }

  // A unique implementation that returns a value of any type from the 2 values passed to the function, depending on whether it is light or dark mode.
  // T chooser<T>({required T lightMode, required T darkMode}) {
  //   if(isLightMode) {
  //     return lightMode;
  //   } else {
  //     return darkMode;
  //   }
  // }
}