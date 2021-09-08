import 'dart:async';
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
        padding: EdgeInsets.only(top: Get.height * 0.07),
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
              padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: Get.height * 0.03),
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
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Form(
                key: transferFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: recipientController,
                      cursorColor: color.foreColor,
                      style: TextStyle(color: color.contrastTextColor),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color.isDarkMode ? color.foreColor : color.backColor)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color.contrastTextColor)
                        ),
                        contentPadding: EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 15),
                        hintText: 'recipient_address'.tr,
                        hintStyle: TextStyle(color: color.isDarkMode ? Color(0x55FFFFFF) : Color(0xFFB0B0B0)),
                        suffixIcon: OutlinedButton(
                          onPressed: (){
                            FlutterClipboard.paste().then((result) async{
                              setState(() {
                                this.recipientController.text = result;
                              });
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            side: BorderSide(color: Colors.transparent, width: 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: Text('paste'.tr, style: TextStyle(color: color.foreColor, fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.03),
                    TextFormField(
                      controller: amountController,
                      cursorColor: color.foreColor,
                      style: TextStyle(color: color.contrastTextColor, fontFamily: Strings.fRegular),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color.isDarkMode ? color.borderColor : color.borderColor)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color.borderColor)
                        ),
                        contentPadding: EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 20),
                        hintText: 'amount'.tr,
                        hintStyle: TextStyle(color: color.isDarkMode ? color.lightTextColor : color.lightTextColor, fontFamily: Strings.fRegular),
                        suffixIcon: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              this.amountController.text = context.read<TokenProvider>().tokens[this.selToken].balance.toString();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            side: BorderSide(color: Colors.transparent, width: 0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
                            child: Text('max'.tr, style: TextStyle(color: color.foreColor, fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.05),
                    this.isLoading ? Center(child: CircularProgressIndicator(color: color.foreColor)) : ElevatedButton(
                      child: Text('transfer'.tr),
                      onPressed: () async{
                        transferToken();
                      },
                      style: ElevatedButton.styleFrom(
                        onSurface: Colors.brown,
                        primary: color.foreColor,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      )
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