import 'package:cancoin_wallet/constants/strings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:provider/provider.dart';

class VerifyPhraseScreen extends StatefulWidget {
  const VerifyPhraseScreen({Key? key}) : super(key: key);
  @override
  _VerifyPhraseScreenState createState() => _VerifyPhraseScreenState();
}

class _VerifyPhraseScreenState extends State<VerifyPhraseScreen> {
  bool isCheck = false;
  bool isLoading = false;

  List<String> words = [];
  List<String> orders = [];
  List<String> patterns = [];

  List<String> copyArray(List<String> ary){
    List<String> tp = [];
    ary.forEach((element) {
      tp.add(element);
    });
    return tp;
  }

  void initState() {
    super.initState();
    setState(() {
      List<String> mnemonic = web3Controller.mnemonic.split(' ');
      patterns = web3Controller.mnemonic.split(' ');
      mnemonic.shuffle();
      words = mnemonic;
      orders = [];
      isCheck = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      body: Container(
        padding: EdgeInsets.only(top: Get.height * 0.03),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      child: Column(
                        children: [
                          SizedBox(height: Get.height * 0.05),
                          Text('verify_recover'.tr, style: TextStyle(color: color.btnPrimaryColor, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: Strings.fBold)),
                          SizedBox(height: Get.height * 0.03),
                          Text('tap_words'.tr, style: TextStyle(color: color.textColor, fontSize: 15, fontFamily: Strings.fSemiBold)),
                          SizedBox(height: Get.height * 0.03),
                        ],
                      ),
                    ),
                    Container(
                      color: color.borderColor,
                      constraints: BoxConstraints(minHeight: 79),
                      margin: EdgeInsets.only(bottom: Get.height * 0.02),
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
                      child: Wrap(
                          alignment: WrapAlignment.center,
                          children:  List.generate(this.orders.length, (index) => Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: OutlinedButton(
                                onPressed: () async {
                                  setState(() {
                                    this.words.add(this.orders[index]);
                                    this.orders.removeAt(index);
                                    print(orders.length );
                                    print(patterns.length );
                                    this.isCheck = false;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  primary: color.contrastTextColor,
                                  side: BorderSide(color: color.contrastTextColor, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: Text(this.orders[index], style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fRegular)),
                                ),
                              )
                          ))
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('paste'.tr),
                          onPressed: () {
                            setState(() {
                              this.isCheck = true;
                              this.orders = copyArray(this.patterns);
                              this.words = [];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              onSurface: Color(0x99000000),
                              primary: Color(0x99000000),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              textStyle: TextStyle(color: Colors.white, fontSize: 16, fontFamily: Strings.fSemiBold)
                          ),
                        ),
                        SizedBox(width: Get.width * 0.05),
                        OutlinedButton(
                          onPressed: (){
                            setState(() {
                              this.isCheck = false;
                              this.orders = [];
                              this.words = copyArray(this.patterns);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            side: BorderSide(color:  Color(0x99000000), width: 2),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('clear'.tr, style: TextStyle(color: Color(0x99000000), fontSize: 16, fontFamily: Strings.fSemiBold)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.01),
                      child: Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            children:  List.generate(this.words.length, (index) => Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: OutlinedButton(
                                onPressed: () async {
                                  setState(() {
                                    this.orders.add(this.words[index]);
                                    this.words.removeAt(index);
                                    var isValid = true;
                                    for(int i = 0; i < this.orders.length; i ++){
                                      if(this.orders[i] != this.patterns[i]){
                                        Get.snackbar('warn'.tr, 'invalid_phrase_order'.tr,
                                          colorText: color.foreColor,
                                          backgroundColor: color.btnSecondaryColor,
                                          isDismissible: true
                                        );
                                        break;
                                      }
                                    }
                                    if(this.words.length == 0 && isValid){
                                      this.isCheck = true;
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  primary: color.contrastTextColor,
                                  side: BorderSide(color: color.borderColor, width: 1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: Text(this.words[index], style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fRegular)),
                                ),
                              ),
                            )
                           )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              color: color.contrastColor,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 25),
              child: ElevatedButton(
                child: this.isLoading ? CircularProgressIndicator() : Text('done'.tr),
                onPressed: !this.isCheck ? null : () async {
                  setState(() { isLoading = true; });
                  try{
                    String privateKey = await web3Controller.privateKeyFromMnemonic(web3Controller.mnemonic);
                    Credentials credentials = EthPrivateKey.fromHex(privateKey);
                    EthereumAddress accountAddress = await credentials.extractAddress();
                    await web3Controller.setCredentials(privateKey);
                    storageController.instance!.setString('privateKey', privateKey);
                    storageController.instance!.setString('accountAddress', accountAddress.toString());
                    context.read<TokenProvider>().changeNetwork(0);
                    setState(() { isLoading = false; });
                    Get.toNamed(PageNames.successwallet);
                  }catch(e){
                    setState(() { isLoading = false; });
                    Get.snackbar('error'.tr, 'create_failed'.tr,
                      colorText: color.foreColor,
                      backgroundColor: color.btnSecondaryColor,
                      isDismissible: true
                    );
                  }
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
