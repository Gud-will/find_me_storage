import 'package:flutter/material.dart';

import '../utils/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    if (_themeData.brightness == Brightness.dark) {
      _themeData = lightTheme;
    } else {
      _themeData = darkTheme;
    }
    notifyListeners();
  }
  bool islighttheme(){
    if(_themeData==lightTheme){
      return true;
    }
    return false;
  }
  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}
