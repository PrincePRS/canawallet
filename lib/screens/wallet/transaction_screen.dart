import 'package:cancoin_wallet/component/tx_components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:line_icons/line_icons.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.07),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(LineIcons.arrowLeft, color: color.textColor, size: 30),
                    ),
                    SizedBox(width: 15),
                    Text(context.watch<ParamsProvider>().transaction.isSent ? 'sent'.tr : 'received'.tr,
                      style: TextStyle(color: color.foreColor, fontFamily: Strings.fMedium, fontSize: 18)
                    ),
                  ],
                ),
                IconButton(
                  onPressed: (){
                    String url = Strings.txUrls[context.read<TokenProvider>().curNetwork] + context.read<ParamsProvider>().transaction.hash;
                    Share.share(url, subject: 'urls');
                  },
                  icon: Icon(Icons.share), color: color.textColor,
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.02),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.watch<ParamsProvider>().transaction.isSent ? '- ' : '+ ', style: TextStyle(color: context.watch<ParamsProvider>().transaction.isSent ? color.warn : color.btnPrimaryColor, fontSize: 36, fontFamily: Strings.fSemiBold)),
                        Text(context.watch<ParamsProvider>().transaction.value.toString() + context.read<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.watch<ParamsProvider>().transaction.isSent ? color.warn : color.btnPrimaryColor, fontSize: 36, fontFamily: Strings.fSemiBold)
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: Get.height * 0.03),
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: color.borderColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          TxItem(
                              label: TxLabel(title: 'date'.tr),
                              value: TxValue(title: context.watch<ParamsProvider>().transaction.date)
                          ),
                          TxDivider(),
                          TxItem(
                            label: TxLabel(title: 'status'.tr),
                            value: TxValue(title: 'Completed')
                          ),
                          TxDivider(),
                          TxItem(
                            bottom: 0,
                            label: TxLabel(title: 'sender'.tr),
                            value: TxValue(title: context.watch<ParamsProvider>().transaction.receiver)
                          ),
                        ]
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          border: Border.all(color: color.borderColor, width: 2)
                      ),
                      child: Column(
                        children: [
                          TxItem(
                            label: TxLabel(title: 'fee'.tr),
                            value: TxValue(title: context.watch<ParamsProvider>().transaction.fee.toString())
                          ),
                          TxDivider(),
                          TxItem(
                            bottom: 0,
                            label: TxLabel(title: 'nonce'.tr),
                            value: TxValue(title: context.watch<ParamsProvider>().transaction.nonce.toString())
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
                        side: BorderSide(color: color.btnPrimaryColor, width: 2),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
                        child: Text('more_detail'.tr, style: TextStyle(color: color.btnPrimaryColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}