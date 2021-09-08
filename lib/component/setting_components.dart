import 'package:cancoin_wallet/global.dart';
import 'package:flutter/material.dart';

class SettingItemButton extends StatelessWidget {
  final Widget leftWidget;
  final Widget? rightWidget;
  final Function() onPressed;
  const SettingItemButton({
    Key? key,
    required this.leftWidget,
    this.rightWidget,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftWidget,
          rightWidget == null ? Container(width: 0) : rightWidget!
        ],
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color.white,
        side: BorderSide(color: color.borderColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15)
      ),
    );
  }
}
