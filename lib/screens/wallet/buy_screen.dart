import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';


class BuyScreen extends StatefulWidget {
  const BuyScreen({Key? key}) : super(key: key);

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {

  final Completer<WebViewController> _controller =   Completer<WebViewController>();
  int percent = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SWAP'),
        backgroundColor: color.btnPrimaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            backgroundColor: color.backColor,
            color: color.btnPrimaryColor,
            value: this.percent / 100.0,
          ),
          Expanded(
            child: WebView(
              initialUrl: context.watch<TokenProvider>().curNetwork == 1 ? 'https://pancakeswap.finance/swap' : 'https://app2.kingswap.exchange/#/swap' ,
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (val){
                setState(() {
                  this.percent = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
