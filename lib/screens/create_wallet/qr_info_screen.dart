import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRInfoScreen extends StatefulWidget {
  const QRInfoScreen({Key? key}) : super(key: key);

  @override
  _QRInfoScreenState createState() => _QRInfoScreenState();
}

class _QRInfoScreenState extends State<QRInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.backColor,
      appBar: AppBar(
        backgroundColor: color.backColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.size.width * 0.1, vertical: Get.size.height * 0.05),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.05),
              color: color.btnSecondaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Container(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: color.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: QrImage(
                        data: web3Controller.mnemonic,
                        version: QrVersions.auto,
                        size: Get.width * 0.6,
                        gapless: true,
                        foregroundColor: color.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
                    child: Text('qr_info'.tr, style: TextStyle(color: color.contrastTextColor, ), textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
            Card(
              elevation: 20,
              color: color.foreColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_outlined, color: Colors.red,),
                    SizedBox(width: Get.width * 0.02),
                    Container(
                      width: Get.width * 0.6,
                      child: Text('never_share'.tr, style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left)
                    ),
                  ],
                )
              )
            ),

            // Expanded(child: Container()),
            // ElevatedButton(
            //   child: Text('BACK'),
            //   onPressed: () {
            //     Get.back();
            //   },
            //   style: ElevatedButton.styleFrom(
            //       onSurface: Colors.brown,
            //       primary: color.foreColor,
            //       padding: EdgeInsets.symmetric(vertical: 15),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(0)),
            //       textStyle: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold)),
            // ),
          ],
        ),
      )
    );
  }
}
