import 'package:cancoin_wallet/screens/wallet/wallet_collect.dart';
import 'package:cancoin_wallet/screens/wallet/wallet_finance.dart';
import 'package:cancoin_wallet/screens/wallet/wallet_tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int btnState = 0;

  List<String> tokensTaps = ['Tokens', 'Finance', 'Collectibles'];

  @override
  void initState() {
    // TODO: implement initState
    this.btnState = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: Get.height * 0.07),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.backColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: color.borderColor)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3 , (index) => ElevatedButton(
                        child:  Text(tokensTaps[index], style: TextStyle(fontFamily: Strings.fSemiBold, fontSize: 14, color: (index == this.btnState) ? color.backColor : color.contrastTextColor,)),
                        onPressed: () {
                          setState(() {
                            this.btnState = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary:  (index == this.btnState) ? color.btnPrimaryColor : color.backColor,
                          padding: EdgeInsets.symmetric( horizontal: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0
                        )
                      ))
                    )
                  )
                ]
              ),
              SizedBox(height: 20),
              btnState == 0 ? WalletToken() : ( btnState == 1 ? WalletFinance() : WalletCollect())
            ],
          ),
        )
      );
    });
  }
}