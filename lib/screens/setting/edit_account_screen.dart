import 'dart:async';
import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/component/common_textfield.dart';
import 'package:cancoin_wallet/provider/wallet_provider.dart';
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

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {

  final GlobalKey<FormState> transferFormKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  int selAccount = 0;
  String address = '';
  bool isLoading = false;
  bool isDelActive = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.selAccount = context.read<ParamsProvider>().editAccount;
      setState(() {
        this.nameController.text = context.read<WalletProvider>().wallets[this.selAccount].name;
        this.address = context.read<WalletProvider>().wallets[this.selAccount].address;
        if(context.read<WalletProvider>().wallets.length == 1 || context.read<WalletProvider>().wallets[this.selAccount].privateKey == storageController.instance!.getString('privateKey')){
          this.isDelActive = false;
        }
      });
    });
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
            fit: BoxFit.cover
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
                      Text('Wallet'.tr,
                          style: TextStyle(color: color.foreColor, fontFamily: Strings.fMedium, fontSize: 18)
                      )
                    ],
                  ),
                  this.isDelActive ? GestureDetector(
                    onTap: () async {
                      await sqliteController.deleteWallet(address);
                      context.read<WalletProvider>().deleteWallet(address);
                      Get.back();
                    },
                    child: Icon(Icons.delete_outline_outlined, size: 30, color: color.textColor),
                  ) : Container()
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: nameController,
                    keyType: 1,
                    hint: 'Name'.tr,
                    onChange: (value) async{
                      await sqliteController.updateWalletName(address, nameController.text);
                      context.read<WalletProvider>().updateWalletName(address, nameController.text);
                    },
                  ),
                  SizedBox(height: Get.height * 0.05),
                  OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9.0),
                                child: Image.asset(
                                  'assets/images/copy-address.png',
                                  fit: BoxFit.cover,
                                  width: 30,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Copy Address'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                                    Text(address,
                                      style: TextStyle(color: color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fRegular),
                                      overflow: TextOverflow.ellipsis
                                    )
                                  ]
                                )
                              )
                            ]
                          )
                        )
                      ]
                    ),
                    onPressed: (){
                      FlutterClipboard.copy(address).then((value){
                        Get.snackbar('Copied Successfully', address,
                            colorText: color.foreColor,
                            backgroundColor: color.btnSecondaryColor,
                            isDismissible: true
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: color.white,
                      side: BorderSide(color: color.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                    ),
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }

  @override
  void dispose() async{
    print('****************************************');

    nameController.dispose();
    super.dispose();
  }
}