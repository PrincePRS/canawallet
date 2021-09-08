import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {

  int btnState = 0;
  int selToken = 0;
  String qrData = '';
  GlobalKey globalKey = new GlobalKey();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.btnState = 0;

    WidgetsBinding.instance!.addPostFrameCallback((_){
      this.selToken = context.read<ParamsProvider>().selTokenId;
      setQRData();
    });
  }

  void setQRData(){
    setState(() {
      qrData = context.read<TokenProvider>().tokens[this.selToken].tokenId + ':' + storageController.instance!.getString('accountAddress')! + ':0';
    });
  }

  void copyQRCode(){
    FlutterClipboard.copy(this.qrData).then((value){
      Get.snackbar('copy_success'.tr, this.qrData,
          colorText: color.foreColor,
          backgroundColor: color.btnSecondaryColor,
          isDismissible: true
      );
    });
  }

  void setAmount(){
    Get.defaultDialog(
      backgroundColor: color.white,
      radius: 7,
      title: '',
      titleStyle: TextStyle(color: color.foreColor, fontSize: 0),
      content: Padding(
        padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, bottom: Get.height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('set_amount'.tr, style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 20)),
            SizedBox(height: 10),
            TextFormField(
              controller: _controller,
              cursorColor: color.foreColor,
              style: TextStyle(color: color.contrastTextColor, fontFamily: Strings.fMedium),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color.isDarkMode ? color.borderColor : color.borderColor)
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color.borderColor)
                ),
                contentPadding: EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 20),
                hintText: '0.0',
                hintStyle: TextStyle(color: color.isDarkMode ? color.lightTextColor : color.lightTextColor, fontFamily: Strings.fRegular),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: (){
                    setState(() {
                      _controller.text = '';
                    });
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    primary: color.btnPrimaryColor,
                    side: BorderSide(color:  color.btnPrimaryColor, width: 2),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Text("cancel".tr, style: TextStyle(color:  color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                  ),
                ),
                ElevatedButton(
                  child: Text('ok'.tr),
                  onPressed: () {
                    setState(() {
                      this.qrData = context.read<TokenProvider>().tokens[this.selToken].tokenId + ':' + storageController.instance!.getString('accountAddress')! + ':' + _controller.text;
                      _controller.text = '';
                    });
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    onSurface: color.btnPrimaryColor,
                    primary: color.btnPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    textStyle: TextStyle(color: Colors.white, fontSize: 14, fontFamily: Strings.fSemiBold)
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void shareQRCode() async{
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(pngBytes);
    Share.shareFiles(['${tempDir.path}/image.png'], text: 'recipient_address'.tr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: Get.height * 0.06),
        decoration: BoxDecoration(
          color: color.white,
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(LineIcons.arrowLeft, color: color.textColor, size: 30),
                  ),
                  Text('receive'.tr + ' ' + context.read<TokenProvider>().tokens[this.selToken].name,
                    style: TextStyle(color: color.foreColor, fontFamily: Strings.fMedium, fontSize: 18)
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: Text('tap_words'.tr, style: TextStyle(color: color.textColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                  ),
                  SizedBox(height: Get.height * 0.03),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: Get.width * 0.12),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/qr-back.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: RepaintBoundary(
                              key:globalKey,
                              child: QrImage(
                                data: this.qrData,
                                version: QrVersions.auto,
                                gapless: true,
                                foregroundColor: color.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1, ),
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
                    child: Text(storageController.instance!.getString('accountAddress')!, style: TextStyle(color: color.contrastTextColor), textAlign: TextAlign.center),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      border: Border.all(color: color.borderColor, width: 2),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15, vertical: 20),
              color: color.contrastColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularButton(
                    title: 'copy'.tr,
                    url: 'copy-icon.png',
                    onPressed: copyQRCode
                  ),
                  CircularButton(
                    title: 'set_amount'.tr,
                    url: 'amount-icon.png',
                    onPressed: setAmount
                  ),
                  CircularButton(
                    title: 'share'.tr,
                    url: 'share-icon.png',
                    onPressed: shareQRCode
                  ),
                ]
              )
            )
          ]
        )
      )
    );
  }
}
