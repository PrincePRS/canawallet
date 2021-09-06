import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.05),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
                child: GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_outlined, size: 30, color: color.foreColor),
                      Text('  ' + 'wallet_account'.tr, style: TextStyle(fontSize: 20, fontFamily: Strings.fSemiBold, color: color.foreColor))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                child: Text('join_community'.tr, style: TextStyle(fontSize: 14, fontFamily: Strings.fSemiBold, color: color.contrastTextColor)),
              ),
              OutlinedButton(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('wallet_account'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                            Text('My Wallet', style: TextStyle(color: color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fRegular))
                          ]
                        ),
                      ],
                    ),
                    Icon(Icons.more_vert_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor)
                  ],
                ),
                onPressed: () async{
                },
                style: ElevatedButton.styleFrom(
                  primary: color.white,
                  side: BorderSide(color: color.borderColor, width: 3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
