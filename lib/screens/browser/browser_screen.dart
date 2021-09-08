import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
              child: Text('Dapps'.tr, style: TextStyle(fontSize: 28, fontFamily: Strings.fBold, color: color.foreColor)),
            ),
            Text('coming_soon'.tr, style: TextStyle(fontFamily: Strings.fBold, fontSize: 28, color: color.btnPrimaryColor)),
            SizedBox(height: 10),
            Text('Lorem Ipsum Dolor Sir Amet', style: TextStyle(fontFamily: Strings.fSemiBold, fontSize: 14, color: color.foreColor)),
            Image.asset('assets/images/coming1.png')
          ],
        ),
      )
    );
  }
}