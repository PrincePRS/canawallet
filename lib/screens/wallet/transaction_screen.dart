import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int selToken = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.selToken = context.read<ParamsProvider>().selTokenId;
      // getTransactionInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<ParamsProvider>().transaction.isSent ? 'sent'.tr : 'received'.tr),
        backgroundColor: color.backColor,
        actions: [
          IconButton(
            onPressed: (){
              String url = Strings.txUrls[context.read<TokenProvider>().curNetwork] + context.read<ParamsProvider>().transaction.hash;
              Share.share(url, subject: 'urls');
            },
            icon: Icon(Icons.share)
          )
        ],
        elevation: 0,
      ),
      backgroundColor: color.borderColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.watch<ParamsProvider>().transaction.isSent ? '- ' : '+ ', style: TextStyle(color: context.watch<ParamsProvider>().transaction.isSent ? color.foreColor : Colors.green, fontSize: 36)),
                Text(context.watch<ParamsProvider>().transaction.value.toString() + context.read<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.watch<ParamsProvider>().transaction.isSent ? color.foreColor : Colors.green, fontSize: 36)
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: Get.height * 0.03),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                  color: Color(0xff232d37)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child:  Text(context.watch<ParamsProvider>().transaction.date, textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 1,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      decoration: BoxDecoration(
                          color: color.btnSecondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(1))
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child:  Text('Completed', textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 1,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      decoration: BoxDecoration(
                          color: color.btnSecondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(1))
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sender', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child:  Text(context.watch<ParamsProvider>().transaction.receiver, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
                color: Color(0xff232d37)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Network Fee', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child:  Text(context.watch<ParamsProvider>().transaction.fee.toString(), textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 1,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    decoration: BoxDecoration(
                      color: color.btnSecondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(1))
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nonce', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child:  Text(context.watch<ParamsProvider>().transaction.nonce.toString(), textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () async{
                String url = Strings.txUrls[context.read<TokenProvider>().curNetwork] + context.read<ParamsProvider>().transaction.hash;
                await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
                // Share.share('check out my website https://example.com', subject: 'Look what I made!');
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(color: color.borderColor, width: 0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
                child: Text("MORE DETAILS".tr, style: TextStyle(color: color.foreColor, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
