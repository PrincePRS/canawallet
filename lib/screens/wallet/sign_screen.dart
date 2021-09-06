import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:cancoin_wallet/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

class SignTransactionScreen extends StatefulWidget {
  const SignTransactionScreen({Key? key}) : super(key: key);
  @override
  _SignTransactionScreenState createState() => _SignTransactionScreenState();
}

class _SignTransactionScreenState extends State<SignTransactionScreen> {

  final GlobalKey<FormState> transferFormKey = GlobalKey<FormState>();
  late TextEditingController recipientController = TextEditingController();
  late TextEditingController amountController = TextEditingController();
  int selToken = 0;
  bool isLoading = false;
  double fee = 0;
  String walletName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.selToken = context.read<ParamsProvider>().selTokenId;
      if(storageController.instance!.getString('walletName') != null) this.walletName = storageController.instance!.getString('walletName')!;
      fee = (context.read<ParamsProvider>().signedTx!.gasPrice!.getInWei * BigInt.from(context.read<ParamsProvider>().signedTx!.maxGas!)).toDouble() / (BigInt.from(10).pow(18)).toDouble();
    });

    // this.selToken = paramsController.selTokenId;
    // fee = (paramsController.signedTx!.gasPrice!.getInWei * BigInt.from(paramsController.signedTx!.maxGas!)).toDouble() / (BigInt.from(10).pow(18)).toDouble();
  }

  void confirmTransaction() async{
    setState(() {
      this.isLoading = true;
    });

    String receipt = await web3Controller.confirmTransaction(context.read<ParamsProvider>().signedTx!);
    setState(() {
      this.isLoading = false;
    });
    if(receipt != '') {
      Get.snackbar('success'.tr, 'transaction_success'.tr,
       colorText: Colors.green,
       backgroundColor: color.btnSecondaryColor,
       isDismissible: true,
      );
      this.startTimeout();
    } else{
      Get.snackbar(
        'error'.tr, 'transaction_failed'.tr,
        colorText: color.foreColor,
        backgroundColor: color.btnSecondaryColor,
        isDismissible: true
      );
    }
  }

  var timeout = Duration(seconds: 3);
  var ms = Duration(milliseconds: 1);

  Timer startTimeout([int? milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return Timer(duration, handleTimeout);
  }

  void handleTimeout() {  // callback function
    Get.offAll(DashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm'.tr),
        backgroundColor: color.backColor,
        elevation: 0,
      ),
      backgroundColor: color.borderColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1, vertical: Get.height * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(context.read<ParamsProvider>().amount + ' ' + context.read<TokenProvider>().tokens[this.selToken].symbol, style: TextStyle(color: color.foreColor, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Text('From', style: TextStyle(color: color.foreColor, fontSize: 18)),
            Row(children: [
              Text(this.walletName + '(', style: TextStyle(color: color.contrastTextColor)),
              Expanded(child: Text(storageController.instance!.getString('accountAddress')!, overflow: TextOverflow.ellipsis, style: TextStyle(color: color.contrastTextColor))),
              Text(')', style: TextStyle(color: color.contrastTextColor)),
            ]),

            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              height: 2,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: color.btnSecondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(1))
              )
            ),

            Text('To', style: TextStyle(color: color.foreColor, fontSize: 18)),
            Text(context.read<ParamsProvider>().signedTx!.to.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(color: color.contrastTextColor)),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              height: 2,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: color.btnSecondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(1))
              )
            ),

            Text('Network Fee', style: TextStyle(color: color.foreColor, fontSize: 18)),
            Text(this.fee.toString() + ' ETH', style: TextStyle(color: color.contrastTextColor)),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 40),
              height: 2,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: color.btnSecondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(1))
              )
            ),
            this.isLoading ? Center(child: CircularProgressIndicator(color: color.foreColor)) : ElevatedButton(
              child: Text('Confirm'.tr),
              onPressed: () async{
                confirmTransaction();
              },
              style: ElevatedButton.styleFrom(
                onSurface: Colors.brown,
                primary: color.foreColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    recipientController.dispose();
    amountController.dispose();
    super.dispose();
  }
}