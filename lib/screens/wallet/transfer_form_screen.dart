import 'dart:async';
import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/component/common_textfield.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:web3dart/web3dart.dart';
import 'package:provider/provider.dart';

class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({Key? key}) : super(key: key);
  @override
  _TransferFormScreenState createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {

  final GlobalKey<FormState> transferFormKey = GlobalKey<FormState>();
  late TextEditingController recipientController = TextEditingController();
  late TextEditingController amountController = TextEditingController();
  int selToken = 0;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.selToken = context.read<ParamsProvider>().selTokenId;
      setState(() {
        this.recipientController.text = context.read<ParamsProvider>().receiver;
        this.amountController.text = context.read<ParamsProvider>().amount;
      });
    });
  }

  void transferToken() async{
    if(recipientController.text.trim() == '' || amountController.text.trim() == ''){
      Get.snackbar('Warning', "Recipient or Amount is empty!",
        colorText: color.foreColor,
        backgroundColor: color.btnSecondaryColor,
        isDismissible: true
      );
      return;
    }
    if(!GetUtils.isNum(amountController.text.trim()) || double.parse(amountController.text.trim()) == 0){
      Get.snackbar('warn'.tr, 'correct_amount'.tr,
        colorText: color.foreColor,
        backgroundColor: color.btnSecondaryColor,
        isDismissible: true
      );
      return;
    }
    setState(() {
      this.isLoading = true;
    });


    Transaction tx;
    if(context.read<TokenProvider>().tokens[this.selToken].address == ''){
      int amount = (double.parse(this.amountController.text) * BigInt.from(10).pow(18).toDouble()).round();
      tx = await web3Controller.transfer(this.recipientController.text.trim(), amount);
    }else{
      tx = await web3Controller.tokenTransfer(context.read<TokenProvider>().tokens[this.selToken].address, this.recipientController.text.trim(), double.parse(this.amountController.text));
    }

    setState(() {
      this.isLoading = false;
    });

    if(tx.maxGas == null){
      Get.snackbar('error'.tr, 'transaction_failed'.tr,
        colorText: color.foreColor,
        backgroundColor: color.btnSecondaryColor,
        isDismissible: true
      );
      return;
    }
    context.read<ParamsProvider>().setSignedTransaction(tx);
    context.read<ParamsProvider>().setAmount(amountController.text);
    // paramsController.setSignedTransaction(tx);
    // paramsController.setAmount(amountController.text);
    Get.toNamed(PageNames.signTx);
  }

  var timeout = Duration(seconds: 3);
  var ms = Duration(milliseconds: 1);

  Timer startTimeout([int? milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return Timer(duration, handleTimeout);
  }

  void handleTimeout() {  // callback function
    Get.toNamed(PageNames.dashbaord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.borderColor,
      body: Container(
        padding: EdgeInsets.only(top: Get.height * 0.07, left: Get.width * 0.05, right: Get.width * 0.05),
        decoration: BoxDecoration(
          color: color.white,
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: Get.height * 0.05),
              child: Row(
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
                      Text(context.read<TokenProvider>().tokens[this.selToken].name,
                          style: TextStyle(color: color.foreColor, fontFamily: Strings.fMedium, fontSize: 18)
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      String result = await Get.toNamed(PageNames.qrreader);
                      result = result.replaceAll('ethereum:', '');
                      if(!Strings.Address_Reg.hasMatch(result)){
                        Get.snackbar('invalid_address'.tr, result,
                          colorText: color.foreColor,
                          backgroundColor: color.btnSecondaryColor,
                          isDismissible: true
                        );
                        return;
                      }
                      setState(() {
                        this.recipientController.text = result;
                      });
                    },
                    child: Image.asset('assets/images/scan.png'),
                  )
                ],
              ),
            ),
            Container(
              child: Form(
                key: transferFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: recipientController,
                      keyType: 1,
                      hint: 'recipient_address'.tr,
                      suffix: SuffixTextButton(
                        title: 'paste'.tr,
                        onPressed: (){
                          FlutterClipboard.paste().then((result) async{
                            setState(() {
                              this.recipientController.text = result;
                            });
                          });
                        },
                      ),
                    ),
                    SizedBox(height: Get.height * 0.03),
                    CustomTextField(
                      controller: amountController,
                      hint: 'amount'.tr,
                      suffix: SuffixTextButton(
                        title: 'max'.tr,
                        onPressed: (){
                          setState(() {
                            this.amountController.text = context.read<TokenProvider>().tokens[this.selToken].balance.toString();
                          });
                        },
                      )
                    ),
                    SizedBox(height: Get.height * 0.05),
                    this.isLoading ? Center(child: CircularProgressIndicator(color: color.foreColor)) : PrimaryButton(
                      title: 'transfer'.tr,
                      isActive: true,
                      onPressed: () async{
                        transferToken();
                      },
                    )
                  ]
                )
              ),
            )
          ]
        )
      )
    );
  }

  @override
  void dispose() {
    recipientController.dispose();
    amountController.dispose();
    super.dispose();
  }
}