import 'package:cancoin_wallet/constants/strings.dart';
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

class AccountItemButton extends StatelessWidget {
  final String name;
  final String address;
  final Function() onPressed;
  final Function() onEditTap;
  const AccountItemButton({
    Key? key,
    required this.name,
    required this.address,
    required this.onPressed,
    required this.onEditTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: Image.asset(
                    'assets/images/wallet-icon.png',
                    fit: BoxFit.cover,
                    width: 35,
                    height: 35
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                      Text(address,
                        style: TextStyle(color: color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fRegular),
                        overflow: TextOverflow.ellipsis
                      )
                    ]
                  )
                )
              ]
            )
          ),
          IconButton(
            onPressed: onEditTap,
            icon: Icon(Icons.more_vert_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor)
          )
        ]
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color.white,
        side: BorderSide(color: color.borderColor, width: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15)
      ),
    );
  }
}
