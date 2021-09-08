import 'dart:async';
import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/component/tx_components.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:cancoin_wallet/screens/dashboard_screen.dart';
import 'package:line_icons/line_icons.dart';
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
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(LineIcons.arrowLeft, color: color.textColor, size: 30),
                ),
                SizedBox(width: 15),
                Text('confirm'.tr, style: TextStyle(color: color.foreColor, fontFamily: Strings.fMedium, fontSize: 18)
                )
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
                        Text(context.read<ParamsProvider>().amount + ' ' + context.read<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.watch<ParamsProvider>().transaction.isSent ? color.btnPrimaryColor : color.btnPrimaryColor, fontSize: 30, fontFamily: Strings.fSemiBold)
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: Get.height * 0.03),
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(7)
                        ),
                        border: Border.all(color: color.borderColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          TxItem(
                            label: TxLabel(title: 'from'.tr),
                            value: TxValue(title: storageController.instance!.getString('accountAddress')!)
                          ),
                          TxDivider(),
                          TxItem(
                            label: TxLabel(title: 'to'.tr),
                            value: TxValue(title: context.read<ParamsProvider>().signedTx!.to.toString()),
                            bottom: 0,
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
                            value: TxValue(title: this.fee.toString() + ' ETH'),
                            bottom: 0,
                          ),
                        ],
                      ),
                    ),
                    this.isLoading ? Center(child: CircularProgressIndicator(color: color.foreColor)) : PrimaryButton(
                      title: 'confirm'.tr,
                      isActive: true,
                      onPressed: () async{
                        confirmTransaction();
                      }
                    )
                  ],
                ),
              )
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