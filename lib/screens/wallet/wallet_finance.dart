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


class WalletToken extends StatefulWidget {
  const WalletToken({Key? key}) : super(key: key);

  @override
  _WalletTokenState createState() => _WalletTokenState();
}

class _WalletTokenState extends State<WalletToken> {

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
      child: Column(
        children: [
          Text("\$ " + context.watch<TokenProvider>().totalBalance.toString(), style: TextStyle(color: color.btnPrimaryColor, fontSize: 38, fontFamily: Strings.fBold)),
          SizedBox(height: 5),
          Text('Coming Soon')
        ],
      ),
    );
  }
}
