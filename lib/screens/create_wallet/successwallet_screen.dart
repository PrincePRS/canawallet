import 'package:cancoin_wallet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/screens/dashboard_screen.dart';
// import 'package:cancoin_wallet/common/router/routes.gr.dart';

class SuccessWalletScreen extends StatefulWidget {
  const SuccessWalletScreen({Key? key}) : super(key: key);

  @override
  _SuccessWalletScreenState createState() => _SuccessWalletScreenState();
}

class _SuccessWalletScreenState extends State<SuccessWalletScreen> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sz = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: Get.height * 0.08),
            Expanded(child: Image.asset('assets/images/banner4.png', fit: BoxFit.contain)),
            Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
                height: 2,
                color: color.borderColor
            ),
            Container(
              height: Get.height * 0.2,
              margin: EdgeInsets.only(top: Get.height * 0.08),
              padding: EdgeInsets.only(left: Get.width * 0.05,right: Get.width * 0.05),
              child: Column(
                children: [
                  Text('congratulation'.tr, style: TextStyle(color: color.btnPrimaryColor, fontSize: 28, fontFamily: Strings.fBold), textAlign: TextAlign.center),
                  SizedBox(height: Get.height * 0.03),
                  Text('create_success'.tr, style: TextStyle(color: color.textColor, fontSize: 16, fontFamily: Strings.fSemiBold), textAlign: TextAlign.center)
                ],
              ),
            ),
            Container(
              color: color.contrastColor,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 25),
              child: ElevatedButton(
                child: Text('done'.tr),
                onPressed: () {
                  Get.offAll(DashboardScreen());
                },
                style: ElevatedButton.styleFrom(
                  onSurface: color.btnPrimaryColor,
                  primary: color.btnPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
