import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final int keyType;
  final String hint;
  final Widget? suffix;
  final bool enabled;
  final Function(String val)? onChange;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.keyType = 0,
    required this.hint,
    this.suffix,
    this.onChange,
    this.enabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: color.foreColor,
      style: TextStyle(color: color.contrastTextColor, fontFamily: Strings.fRegular, fontSize: 14),
      keyboardType: keyType == 0 ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.isDarkMode ? color.borderColor : color.borderColor, width: 2)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.borderColor, width: 2)
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.borderColor, width: 2)
        ),
        contentPadding: EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 20),
        hintText: hint,
        hintStyle: TextStyle(color: color.isDarkMode ? color.lightTextColor : color.lightTextColor, fontFamily: Strings.fRegular, fontSize: 14),
        suffixIcon: suffix == null ? Container(width: 0) : suffix
      ),
      onChanged: onChange,
      enabled: enabled,
    );
  }
}