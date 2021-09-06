import 'package:cancoin_wallet/constants/strings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/global.dart';

class RandPhraseScreen extends StatefulWidget {
  const RandPhraseScreen({Key? key}) : super(key: key);

  @override
  _RandPhraseScreenState createState() => _RandPhraseScreenState();
}

class _RandPhraseScreenState extends State<RandPhraseScreen> {

  List<String> words = [];

  void initState() {
    super.initState();
    web3Controller.generateMnemonic();

    setState(() {
      words = web3Controller.mnemonic.split(' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      body: Container(
        padding: EdgeInsets.only(top: Get.height * 0.05),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.03),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      decoration: BoxDecoration(
                          color: color.warnBack,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 15),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_outlined, color: Colors.red,),
                              SizedBox(width: Get.width * 0.02),
                              Container(
                                  width: Get.width * 0.6,
                                  child: Text('never_share'.tr, style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: Strings.fSemiBold), textAlign: TextAlign.left)
                              ),
                            ],
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
                      child: Text('your_recovery'.tr, style: TextStyle(color: color.btnPrimaryColor, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: Strings.fBold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      child: Text('save_safe'.tr, style: TextStyle(color: color.textColor, fontSize: 15, fontFamily: Strings.fSemiBold)),
                    ),
                    SizedBox(height: Get.height * 0.03),
                    Container(
                      child: Column(
                        children: [
                          Wrap(
                              alignment: WrapAlignment.center,
                              children:  List.generate(this.words.length, (index) => Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: OutlinedButton(
                                    onPressed: () async {},
                                    style: OutlinedButton.styleFrom(
                                      primary: color.contrastTextColor,
                                      side: BorderSide(color: color.borderColor, width: 1),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4),
                                      child: Text((index + 1).toString() + ' ' + this.words[index], style: TextStyle(color: color.contrastTextColor, fontSize: 12, fontFamily: Strings.fRegular)),
                                    ),
                                  )
                              ))
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child: Text('copy'.tr),
                                onPressed: () {
                                  FlutterClipboard.copy(web3Controller.mnemonic).then((value){
                                    Get.snackbar('Copied Successfully', web3Controller.mnemonic,
                                        colorText: color.foreColor,
                                        backgroundColor: color.btnSecondaryColor,
                                        isDismissible: true
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    onSurface: Color(0x99000000),
                                    primary: Color(0x99000000),
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    textStyle: TextStyle(color: Colors.white, fontSize: 16, fontFamily: Strings.fSemiBold)
                                ),
                              ),
                              SizedBox(width:  Get.width * 0.05),
                              OutlinedButton(
                                onPressed: (){
                                  Get.toNamed(PageNames.qrinfo);
                                },
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.white,
                                  side: BorderSide(color:  Color(0x99000000), width: 2),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                  // backgroundColor: Colors.teal,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text("show_qr".tr, style: TextStyle(color: Color(0x99000000), fontSize: 16, fontFamily: Strings.fSemiBold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              )
            ),
            Container(
              color: color.contrastColor,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 25),
              child: ElevatedButton(
                child: Text('continue'.tr),
                onPressed: () {
                  Get.toNamed(PageNames.verifyphrase);
                },
                style: ElevatedButton.styleFrom(
                  onSurface: color.btnPrimaryColor,
                  primary: color.btnPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
