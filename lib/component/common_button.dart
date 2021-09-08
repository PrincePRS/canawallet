import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final String title;
  final String url;
  final Function() onPressed;
  const CircularButton({
    Key? key,
    required this.title,
    required this.url,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Material(
            color: color.btnPrimaryColor,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/images/' + url),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(title, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function() onPressed;
  const PrimaryButton({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(title),
      onPressed: !isActive ? null : onPressed,
      style: ElevatedButton.styleFrom(
          onSurface: color.btnPrimaryColor,
          primary: color.btnPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          textStyle: TextStyle(fontSize: 15, fontFamily: Strings.fSemiBold)
      ),
    );
  }
}