import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fitHeight,
            ),
          ),
          padding: EdgeInsets.only(top: Get.height * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.03, horizontal: Get.width * 0.05),
                  child: Text('notify'.tr, style: TextStyle(fontSize: 28, fontFamily: Strings.fBold, color: color.foreColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                            Text('Notification 1', style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                          ],
                        ),
                      ],
                    ),
                    onPressed: () async{
                    },
                    style: ElevatedButton.styleFrom(
                        primary: color.white,
                        side: BorderSide(color: color.borderColor, width: 3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                            Text('Notification 2', style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                          ],
                        ),
                      ],
                    ),
                    onPressed: () async{
                    },
                    style: ElevatedButton.styleFrom(
                      primary: color.white,
                      side: BorderSide(color: color.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
