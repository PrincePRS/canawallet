import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancoin_wallet/constants/chains.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:cancoin_wallet/screens/qrreader_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


class WalletCollect extends StatefulWidget {
  const WalletCollect({Key? key}) : super(key: key);

  @override
  _WalletCollectState createState() => _WalletCollectState();
}

class _WalletCollectState extends State<WalletCollect> {

  bool isNumeric(String s) {
    try{
      double.parse(s);
      return true;
    }catch(ex){
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Coming Soon...', style: TextStyle(fontFamily: Strings.fBold, fontSize: 28, color: color.btnPrimaryColor)),
            SizedBox(height: 10),
            Text('Lorem Ipsum Dolor Sir Amet', style: TextStyle(fontFamily: Strings.fSemiBold, fontSize: 14, color: color.foreColor)),
            Image.asset('assets/images/coming2.png')
          ],
        ),
      ),
    );
  }
}
