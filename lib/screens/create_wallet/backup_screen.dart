import 'package:cancoin_wallet/constants/strings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:provider/provider.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({Key? key}) : super(key: key);
  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool isCheck = false;
  bool loading = false;
  int btnState = 0;
  TextEditingController _controller = TextEditingController();
  TextEditingController _privatekeyController = TextEditingController();
  List<String> hintWords = [];
  List<String> orders = [];
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.05),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.2, vertical: Get.height * 0.05),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              width: Get.width * 0.75 ,
              decoration: BoxDecoration(
                color: color.backColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: color.borderColor)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(2 , (index) => ElevatedButton(
                  child:  Text(index == 0 ? 'phrases'.tr : 'privateKey'.tr, style: TextStyle(fontFamily: Strings.fSemiBold, fontSize: 14, color: (index == this.btnState) ? color.backColor : color.contrastTextColor)),
                  onPressed: () {
                    setState(() {
                      this.btnState = index;
                      this.hintWords = [];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:  (index == this.btnState) ? color.btnPrimaryColor : color.backColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0
                  ),
                ))
              )
            ),
            this.btnState == 0 ? Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      color: color.borderColor,
                      constraints: BoxConstraints(minHeight: Get.height * 0.2),
                      margin: EdgeInsets.only(bottom: Get.height * 0.02),
                      padding: EdgeInsets.only(left: Get.width * 0.00, right: Get.width * 0.00, bottom: Get.height * 0.02, top: Get.height * 0.055),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children:  List.generate(this.orders.length, (index) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            child:  Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text(this.orders[index], style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fRegular)),
                            ),
                            onPressed: () {
                              setState(() {
                                this.hintWords.add(this.orders[index]);
                                this.orders.removeAt(index);
                                this.isCheck = false;
                                this._controller.text = '';
                                this.hintWords = [];
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: color.white,
                              side: BorderSide(color: color.contrastTextColor, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ))
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        children: [
                          ElevatedButton(
                            child: Icon(Icons.qr_code_scanner),
                            onPressed: () async {
                              String result = await Get.toNamed(PageNames.qrreader);
                              var isValid = await web3Controller.checkValidateMnemonics(result);
                              if(!isValid){
                                Get.snackbar('invalid_phrase'.tr, result,
                                  colorText: color.foreColor,
                                  backgroundColor: color.btnSecondaryColor,
                                  isDismissible: true
                                );
                                return;
                              }
                              var ary = result.split(' ');
                              List<String> tpSplits = [];
                              ary.forEach((element) {
                                if(element.trim() != '') tpSplits.add(element.trim());
                              });
                              if(tpSplits.length == 12){
                                setState(() {
                                  this.orders = tpSplits;
                                  this.isCheck = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              onSurface: color.isDarkMode ? Color(0xAA6E6FA4) : color.backColor,
                              primary:   color.isDarkMode ? color.btnPrimaryColor : color.btnPrimaryColor,
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                          ),
                          ElevatedButton(
                          child: Icon(Icons.paste),
                          onPressed: () async {
                            FlutterClipboard.paste().then((result) async{
                              var isValid = await web3Controller.checkValidateMnemonics(result);
                              if(!isValid){
                                Get.snackbar('invalid_phrase'.tr, result,
                                  colorText: color.foreColor,
                                  backgroundColor: color.btnSecondaryColor,
                                  isDismissible: true
                                );
                                return;
                              }
                              var ary = result.split(' ');
                              List<String> tpSplits = [];
                              ary.forEach((element) {
                                if(element.trim() != '') tpSplits.add(element.trim());
                              });
                              if(tpSplits.length == 12){
                                setState(() {
                                  this.orders = tpSplits;
                                  this.isCheck = true;
                                });
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            onSurface: color.isDarkMode ? Color(0xAA6E6FA4) : color.backColor,
                            primary:   color.isDarkMode ? color.btnPrimaryColor : color.btnPrimaryColor,
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)
                            ),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                        ),
                    ]))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
                  child: TextField(
                    controller: _controller,
                    cursorColor: color.foreColor,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: color.contrastTextColor, fontFamily: Strings.fRegular),
                    textAlign: TextAlign.center,
                    enabled: !isCheck,
                    onChanged: (value){
                      setState(() {
                        this.hintWords = web3Controller.getHintMnemonics(value, this.orders);
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_forward, color: color.contrastTextColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF616161), width: 2)
                        // borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF616161), width: 2)
                        // borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.only(left: 15, bottom: 5, top: 5),
                      hintText: 'search_here'.tr,
                      hintStyle: TextStyle(color: color.isDarkMode ? color.contrastTextColor : color.contrastTextColor, fontFamily: Strings.fRegular)
                    )
                  )
                )
              ],
            ) : Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: color.borderColor,
                  constraints: BoxConstraints(minHeight: Get.height * 0.2),
                  margin: EdgeInsets.only(bottom: Get.height * 0.02),
                  padding: EdgeInsets.only(left: Get.width * 0.00, right: Get.width * 0.00, bottom: Get.height * 0.02, top: Get.height * 0.055),
                  child: TextField(
                    controller: _privatekeyController,
                    cursorColor: color.foreColor,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: color.contrastTextColor, fontFamily: Strings.fRegular),
                    minLines: 1,
                    maxLines: 4,
                    enabled: !isCheck,
                    onChanged: (value){
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
                      hintText: 'privateKey'.tr,
                      hintStyle: TextStyle(color: Color(0x55FFFFFF), fontFamily: Strings.fRegular)
                    )
                  )
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Row(
                    children: [
                      ElevatedButton(
                        child: Icon(Icons.settings_overscan_outlined),
                        onPressed: () async {
                          String result = await Get.toNamed(PageNames.qrreader);
                          if(result.length != 64){
                            Get.snackbar('invaid_privatekey'.tr, result,
                              colorText: color.foreColor,
                              backgroundColor: color.btnSecondaryColor,
                              isDismissible: true
                            );
                            return;
                          }
                          setState(() {
                            this._privatekeyController.text = result;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          onSurface: color.isDarkMode ? color.contrastTextColor : color.contrastTextColor,
                          primary:   color.isDarkMode ? color.btnPrimaryColor : color.btnPrimaryColor,
                          padding:   EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      ElevatedButton(
                        child: Icon(Icons.paste),
                        onPressed: () async {
                          FlutterClipboard.paste().then((result) async{
                            var isValid = await web3Controller.checkValidateMnemonics(result);
                            if(!isValid){
                              Get.snackbar('invalid_phrase'.tr, result,
                                colorText: color.foreColor,
                                backgroundColor: color.btnSecondaryColor,
                                isDismissible: true
                              );
                              return;
                            }
                            var ary = result.split(' ');
                            List<String> tpSplits = [];
                            ary.forEach((element) {
                              if(element.trim() != '') tpSplits.add(element.trim());
                            });
                            if(tpSplits.length == 12){
                              setState(() {
                                this.orders = tpSplits;
                                this.isCheck = true;
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          onSurface: color.isDarkMode ? Color(0xAA6E6FA4) : color.backColor,
                          primary: color.isDarkMode ? color.btnPrimaryColor : color.btnPrimaryColor,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ]
                  )
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(this.hintWords.length, (index) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: OutlinedButton(
                            child: Text(this.hintWords[index], style: TextStyle(color: color.contrastTextColor, fontFamily: Strings.fRegular)),
                            onPressed: () {
                              setState(() {
                                this._controller.text = '';
                                this.orders.add(this.hintWords[index]);
                                this.hintWords = [];
                                if(this.orders.length == 12){
                                  this.isCheck = true;
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              primary: color.contrastTextColor,
                              side: BorderSide(color: color.borderColor, width: 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        )
                      )
                    ),
                    SizedBox(height: Get.height * 0.05),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: this.loading ? Center(child: CircularProgressIndicator(color: color.foreColor)) : ElevatedButton(
                child: Text('backup'.tr),
                onPressed: !this.isCheck && this.btnState == 0 ? null : () async {
                  setState(() { this.loading = true; });
                  try{
                    if(this.btnState == 0){
                      web3Controller.setMnemonics(this.orders.join(' '));
                      String privateKey = await web3Controller.privateKeyFromMnemonic(web3Controller.mnemonic);
                      Credentials credentials = EthPrivateKey.fromHex(privateKey);
                      EthereumAddress accountAddress = await credentials.extractAddress();
                      await web3Controller.setCredentials(privateKey);
                      storageController.instance!.setString('privateKey', privateKey);
                      storageController.instance!.setString('accountAddress', accountAddress.toString());
                    }else{
                      Credentials credentials = EthPrivateKey.fromHex(this._privatekeyController.text);
                      EthereumAddress accountAddress = await credentials.extractAddress();
                      await web3Controller.setCredentials(this._privatekeyController.text);
                      storageController.instance!.setString('privateKey', this._privatekeyController.text);
                      storageController.instance!.setString('accountAddress', accountAddress.toString());
                    }
                    context.read<TokenProvider>().changeNetwork(0);
                    setState(() { loading = false; });
                    Get.toNamed(PageNames.successwallet);
                  }catch(e){
                    setState(() { loading = false; });
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
                  textStyle: TextStyle(fontSize: 15, fontFamily: Strings.fSemiBold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}