import 'package:cancoin_wallet/component/setting_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fitHeight,
            ),
          ),
          padding: EdgeInsets.only(top: Get.height * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.03, horizontal: Get.width * 0.05),
                  child: Text('setting'.tr, style: TextStyle(fontSize: 30, fontFamily: Strings.fBold, color: color.foreColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9.0),
                              child: Image.asset(
                                'assets/images/wallet-icon.png',
                                fit: BoxFit.cover,
                                width: 35,
                                height: 35
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('wallet_account'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                                Text('My Wallet', style: TextStyle(color: color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fRegular))
                              ]
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor)
                      ],
                    ),
                    onPressed: () async{
                      Get.toNamed(PageNames.walletAccount);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: color.white,
                      side: BorderSide(color: color.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9.0),
                              child: Image.asset(
                                'assets/images/theme-icon.png',
                                fit: BoxFit.cover,
                                width: 35,
                                height: 35
                              ),
                            ),
                            SizedBox(width: 15),
                            Text('theme'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor)
                      ],
                    ),
                    onPressed: () async{
                      Get.toNamed(PageNames.theme);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: color.white,
                      side: BorderSide(color: color.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9.0),
                              child: Image.asset(
                                'assets/images/language-icon.png',
                                fit: BoxFit.cover,
                                width: 35,
                                height: 35
                              ),
                            ),
                            SizedBox(width: 15),
                            Text('language'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor)
                      ],
                    ),
                    onPressed: () async{
                      Get.toNamed(PageNames.language);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: color.white,
                      side: BorderSide(color: color.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: SettingItemButton(
                    leftWidget: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9.0),
                          child: Image.asset(
                            'assets/images/security-icon.png',
                            fit: BoxFit.cover,
                            width: 35,
                            height: 35
                          ),
                        ),
                        SizedBox(width: 15),
                        Text('security'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                      ],
                    ),
                    rightWidget: Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor),
                    onPressed: (){
                      Get.toNamed(PageNames.security);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: SettingItemButton(
                    leftWidget: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9.0),
                          child: Image.asset(
                              'assets/images/bell-icon.png',
                              fit: BoxFit.cover,
                              width: 35,
                              height: 35
                          ),
                        ),
                        SizedBox(width: 15),
                        Text('notification'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                      ],
                    ),
                    rightWidget: Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor),
                    onPressed: (){
                      Get.toNamed(PageNames.setNotification);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                  child: OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9.0),
                              child: Image.asset(
                                'assets/images/walletconnect-icon.png',
                                fit: BoxFit.cover,
                                width: 35,
                                height: 35
                              ),
                            ),
                            SizedBox(width: 15),
                            Text('walletconnect'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor)
                      ],
                    ),
                    onPressed: () async{
                      String uri = '';
                      if(context.read<ParamsProvider>().connected == false && context.read<ParamsProvider>().walletconnectUrl == '') {
                        uri = await Get.toNamed(PageNames.qrreader);
                        if(!uri.contains('wc:') || !uri.contains('?bridge=https') || !uri.contains('&key=') || !uri.contains('wc:')){
                          Get.snackbar('error'.tr, 'URI Error'.tr,
                            colorText: color.foreColor,
                            backgroundColor: color.btnSecondaryColor,
                            isDismissible: true
                          );
                        }
                        uri = uri.substring(3);
                        int indexSplit = uri.indexOf('?bridge=https');
                        context.read<ParamsProvider>().setWalletConnectUrl(Strings.walletConnectServer + uri.substring(0, indexSplit));
                        uri = uri.substring(indexSplit + 13);
                        indexSplit = uri.indexOf('&key=');
                        context.read<ParamsProvider>().setWalletConnectUrl(context.read<ParamsProvider>().walletconnectUrl! + '/' + uri.substring(0, indexSplit));
                        uri = uri.substring(indexSplit + 5);
                        context.read<ParamsProvider>().setWalletConnectUrl(context.read<ParamsProvider>().walletconnectUrl! + '/' + uri);
                        context.read<ParamsProvider>().setWalletConnectUrl(context.read<ParamsProvider>().walletconnectUrl! + '/' + storageController.instance!.getString('privateKey')!);
                      }
                      else uri = context.read<ParamsProvider>().walletconnectUrl!;

                     // await canLaunch(context.read<ParamsProvider>().walletconnectUrl!) ? await launch(context.read<ParamsProvider>().walletconnectUrl!) : throw 'Could not launch ';
                      Get.toNamed(PageNames.walletconnect);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: color.white,
                      side: BorderSide(color: color.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
                    )
                  ),
                ),
                Container(
                  color: color.contrastColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: Get.width * 0.05),
                        child: Text('join_community'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, left: Get.width * 0.05, right: Get.width * 0.05),
                        child: OutlinedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(9.0),
                                    child: Image.asset(
                                      'assets/images/help-icon.png',
                                      fit: BoxFit.cover,
                                      width: 35,
                                      height: 35
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text('help_center'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor)
                            ],
                          ),
                          onPressed: () async{
                            await canLaunch(Strings.helpUrl) ? await launch(Strings.helpUrl) : throw 'Could not launch ';
                          },
                          style: ElevatedButton.styleFrom(
                            primary: color.white,
                            side: BorderSide(color: color.borderColor, width: 3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

