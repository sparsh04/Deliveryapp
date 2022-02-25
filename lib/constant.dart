import 'package:flutter/material.dart';

const greencolor = Color(0xFF367520);
const orangecolor = Color(0xFFDFA82A);
Color textcolorgrey = Colors.black.withOpacity(0.6);
const textcolorblack = Colors.black;
const yellowcolor = Color(0xfffbba445);
const whitedark = Color(0xfffdcf8c6);
const whitecolors = Color(0xFFFFFFFF);

TextStyle headingstyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
}

TextStyle subheadingstyle() {
  return TextStyle(
    color: Colors.black.withOpacity(0.6),
    fontSize: 12,
  );
}

//hide keyboard
void hideKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());
