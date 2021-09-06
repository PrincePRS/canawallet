import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      appBar: AppBar(
        title: Text('receive'.tr + ' ' + context.read<TokenProvider>().tokens[this.selToken].name),
        backgroundColor: color.backColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.size.width * 0.1, vertical: Get.size.height * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.05),
              color: color.btnSecondaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: color.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: RepaintBoundary(
                        key:globalKey,
                        child: QrImage(
                          data: this.qrData,
                          version: QrVersions.auto,
                          size: Get.width * 0.6,
                          gapless: true,
                          foregroundColor: color.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
                    child: Text(storageController.instance!.getString('accountAddress')!, style: TextStyle(color: color.contrastTextColor), textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text('send_only1'.tr + context.read<TokenProvider>().tokens[this.selToken].name + ' ' + 'send_only2'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: color.white))
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Color(0x44FFFFFF),
                          child: InkWell(
                            onTap: ()async{
                              FlutterClipboard.copy(this.qrData).then((value){
                                Get.snackbar('copy_success'.tr, this.qrData,
                                  colorText: color.foreColor,
                                  backgroundColor: color.btnSecondaryColor,
                                  isDismissible: true
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Icon(Icons.copy, size: 20, color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('copy'.tr, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.white)),
                    ],
                  ),
                  Column(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Color(0x44FFFFFF),
                          child: InkWell(
                            onTap: (){
                              Get.defaultDialog(
                                backgroundColor: color.btnSecondaryColor,
                                title: 'set_amount'.tr,
                                titleStyle: TextStyle(color: color.foreColor),
                                content: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: 8),
                                  child: TextField(
                                    controller: _controller,
                                    cursorColor: color.foreColor,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: color.contrastTextColor),
                                    minLines: 1,
                                    onChanged: (value){

                                    },
                                    decoration: InputDecoration(),
                                  ),
                                ),
                                confirm: Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: ElevatedButton(
                                    child:  Text('ok'.tr),
                                    onPressed: () {
                                      setState(() {
                                        this.qrData = context.read<TokenProvider>().tokens[this.selToken].tokenId + ':' + storageController.instance!.getString('accountAddress')! + ':' + _controller.text;
                                        _controller.text = '';
                                      });
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: color.foreColor,
                                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                    ),
                                  ),
                                ),
                                cancel: OutlinedButton(
                                  onPressed: (){
                                    setState(() {
                                      _controller.text = '';
                                    });
                                    Get.back();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    primary: color.contrastTextColor,
                                    side: BorderSide(color: Colors.white, width: 1),
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                                    // backgroundColor: Colors.teal,
                                  ),
                                  child: Text('cancel'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 16)),
                                )
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Icon(Icons.push_pin, size: 20, color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('set_amount'.tr, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.white, fontSize: 14))
                    ]
                  ),
                  Column(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Color(0x44FFFFFF),
                          child: InkWell(
                            onTap: () async{
                              RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                              var image = await boundary.toImage();
                              ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
                              Uint8List pngBytes = byteData!.buffer.asUint8List();
                              final tempDir = await getTemporaryDirectory();
                              final file = await new File('${tempDir.path}/image.png').create();
                              await file.writeAsBytes(pngBytes);
                              Share.shareFiles(['${tempDir.path}/image.png'], text: 'recipient_address'.tr);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Icon(Icons.share, size: 20, color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('share'.tr, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.white, fontSize: 14)),
                    ]
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}
