import 'package:bip32/bip32.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/global.dart';

class RecoverScreen extends StatefulWidget {
  const RecoverScreen({Key? key}) : super(key: key);

  @override
  _RecoverScreenState createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {

  bool isCheck = false;

  void initState() {
    super.initState();
    setState(() {
      this.isCheck = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      body: Container(
        padding: EdgeInsets.only(top: Get.height * 0.05),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: Get.height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Text('backup_wallet'.tr, style: TextStyle(color: color.btnPrimaryColor, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: Strings.fBold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Text('12words_sentence'.tr, style: TextStyle(color: color.textColor, fontSize: 15, fontFamily: Strings.fSemiBold)),
            ),
            Expanded(
              child: Container(
                child:  Image.asset('assets/images/wallet.png', fit: BoxFit.fitWidth)
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 6),
                    alignment: Alignment.topCenter,
                    width: Get.width * 0.1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCheck ? color.btnPrimaryColor : Colors.transparent,
                          border: Border.all(color: color.btnPrimaryColor, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: isCheck ? Icon(Icons.check, size: 17.0, color: Colors.white) : Icon(null, size: 17.0),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: Get.height * 0.03, left: Get.width * 0.03),
                    width: Get.width * 0.7,
                    child: Text('lose_recovery'.tr, style: TextStyle(color: color.textColor, fontSize: 12, fontFamily: Strings.fMedium), textAlign: TextAlign.justify)
                  ),
                ],
              ),
            ),
            Container(
              color: color.contrastColor,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 25),
              child: ElevatedButton(
                child: Text('continue'.tr),
                onPressed: !this.isCheck ? null : () async{
                  Get.toNamed(PageNames.randphrase);
                },
                style: ElevatedButton.styleFrom(
                  onSurface: color.btnPrimaryColor,
                  primary: color.btnPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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