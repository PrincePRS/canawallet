import 'package:cancoin_wallet/component/setting_components.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/credentials.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.05),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fitHeight
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
                child: GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_back_outlined, size: 30, color: color.foreColor),
                          Text('  ' + 'Wallets'.tr, style: TextStyle(fontSize: 20, fontFamily: Strings.fSemiBold, color: color.foreColor))
                      ]),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(PageNames.board);
                        },
                        child: Icon(Icons.add_box_outlined, color: color.textColor)
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: Get.width * 0.05),
                child: Text('Current Account'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
              ),
              Column(
                children: List.generate(context.read<WalletProvider>().wallets.length,
                  (index) => context.read<WalletProvider>().wallets[index].privateKey != storageController.instance!.getString('privateKey') ? Container()
                : AccountItemButton(
                    name: context.watch<WalletProvider>().wallets[index].name == '' ? 'My Wallet' : context.watch<WalletProvider>().wallets[index].name,
                    address: context.watch<WalletProvider>().wallets[index].address,
                    onPressed: () async {

                    },
                    onEditTap: (){
                      context.read<ParamsProvider>().setEditAccount(index);
                      Get.toNamed(PageNames.editAccount);
                    },
                  )
                )
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: Get.width * 0.05),
                child: Text('All Accounts'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
              ),
              Column(
                children: List.generate(context.read<WalletProvider>().wallets.length,
                  (index) => context.read<WalletProvider>().wallets[index].privateKey == storageController.instance!.getString('privateKey') ? Container()
                : AccountItemButton(
                    name: context.watch<WalletProvider>().wallets[index].name == '' ? 'My Wallet' : context.watch<WalletProvider>().wallets[index].name,
                    address: context.watch<WalletProvider>().wallets[index].address,
                    onPressed: () async {
                      String privateKey = context.read<WalletProvider>().wallets[index].privateKey;
                      Credentials credentials = EthPrivateKey.fromHex(privateKey);
                      EthereumAddress accountAddress = await credentials.extractAddress();
                      await web3Controller.setCredentials(privateKey);
                      storageController.instance!.setString('privateKey', privateKey);
                      storageController.instance!.setString('accountAddress', accountAddress.toString());
                      Get.toNamed(PageNames.dashbaord);
                    },
                    onEditTap: (){
                      context.read<ParamsProvider>().setEditAccount(index);
                      Get.toNamed(PageNames.editAccount);
                    },
                  )
                )
              )
            ],
          ),
        ),
      );
    });
  }
}