import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';


class WalletConnectScrren extends StatefulWidget {
  const WalletConnectScrren({Key? key}) : super(key: key);

  @override
  _WalletConnectScrrenState createState() => _WalletConnectScrrenState();
}

class _WalletConnectScrrenState extends State<WalletConnectScrren> {

  final Completer<WebViewController> _controller =   Completer<WebViewController>();
  int percent = 0;

  JavascriptChannel _walletconnectJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'walletconnect',
      onMessageReceived: (JavascriptMessage message) {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // paramsController.setWalletConnectUrl('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('walletconnect'.tr),
        backgroundColor: color.backColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            backgroundColor: color.backColor,
            value: this.percent / 100.0,
          ),
          Expanded(
            child: WebView(
              initialUrl: context.watch<ParamsProvider>().walletconnectUrl!,
              // initialUrl: 'http://192.168.1.16/flutter',
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>[
                _walletconnectJavascriptChannel(context),
                JavascriptChannel(name: 'Print', onMessageReceived: (JavascriptMessage msg) {
                  print('--------------------');
                  print(msg.message);
                  if(msg.message == 'connect'){
                    context.read<ParamsProvider>().setWalletConnect(true);
                  }else{
                    context.read<ParamsProvider>().setWalletConnectUrl('');
                    context.read<ParamsProvider>().setWalletConnect(false);
                    Get.back();
                  }

                })
              ].toSet(),
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
