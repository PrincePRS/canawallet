import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:flutter/material.dart';

class TxDivider extends StatelessWidget {
  const TxDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        height: 2,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        decoration: BoxDecoration(
            color: color.borderColor,
            borderRadius: BorderRadius.all(Radius.circular(1))
        )
    );
  }
}

class TxValue extends StatelessWidget {
  final title;
  const TxValue({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          this.title,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color.foreColor, fontSize: 14, fontFamily: Strings.fRegular)
        ),
      ),
    );
  }
}

class TxLabel extends StatelessWidget {
  final title;
  const TxLabel({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(this.title, style: TextStyle(color: color.btnPrimaryColor, fontSize: 16, fontFamily: Strings.fSemiBold));
  }
}

class TxItem extends StatelessWidget {
  final double bottom;
  final Widget label;
  final Widget value;

  const TxItem({
    Key? key,
    this.bottom = 20,
    required this.label,
    required this.value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: this.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label,
          value
        ],
      ),
    );
  }
}
