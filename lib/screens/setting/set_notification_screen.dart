import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/component/common_textfield.dart';
import 'package:cancoin_wallet/component/setting_components.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/provider/notification_provider.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SetNotificationScreen extends StatefulWidget {
  const SetNotificationScreen({Key? key}) : super(key: key);

  @override
  _SetNotificationScreenState createState() => _SetNotificationScreenState();
}

class _SetNotificationScreenState extends State<SetNotificationScreen> {

  bool tp = false;
  TextEditingController limitController = TextEditingController();

  void toggleTransactionAlert(){
    context.read<NotificationProvider>().toggleTransactionAlert();
  }

  bool isNumeric(String string) {
    if (string.isEmpty) {
      return false;
    }
    final number = num.tryParse(string);
    if (number == null) {
      return false;
    }
    return true;
  }

  void togglePriceAlert(){
    context.read<NotificationProvider>().togglePriceAlert();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      limitController.text = context.read<NotificationProvider>().limitValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: Get.height * 0.05),
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
                      Text('notification'.tr,
                        style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 20)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text('join_community'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                    ),
                    SettingItemButton(
                      leftWidget: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9.0),
                            child: Image.asset(
                                'assets/images/alert-icon.png',
                                fit: BoxFit.cover,
                                width: 35,
                                height: 35
                            ),
                          ),
                          SizedBox(width: 15, height: 50),
                          Text('Transaction Alerts'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                        ],
                      ),
                      rightWidget: GestureDetector(
                        onTap: (){
                          this.toggleTransactionAlert();
                          storageController.instance!.setBool('transactionAlert', context.read<NotificationProvider>().tAlert);
                        },
                        child: Image.asset(context.watch<NotificationProvider>().tAlert ? 'assets/images/switch-on.png' : 'assets/images/switch-off.png'),
                      ),
                      onPressed: (){}
                    ),
                    SizedBox(height: Get.height * 0.03),
                    SettingItemButton(
                      leftWidget: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9.0),
                            child: Image.asset(
                              'assets/images/alert-icon.png',
                              fit: BoxFit.cover,
                              width: 35,
                              height: 35
                            ),
                          ),
                          SizedBox(width: 15, height: 50),
                          Text('Price Alerts'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                        ],
                      ),
                      rightWidget: GestureDetector(
                        onTap: (){
                          this.togglePriceAlert();
                          storageController.instance!.setBool('priceAlert', context.read<NotificationProvider>().pAlert);
                        },
                        child: Image.asset(context.watch<NotificationProvider>().pAlert ? 'assets/images/switch-on.png' : 'assets/images/switch-off.png'),
                      ),
                      onPressed: (){}
                    ),
                    context.watch<NotificationProvider>().pAlert ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('Set a stop-loss/take-profit alert, when:'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                    ) : Container(),
                    context.watch<NotificationProvider>().pAlert ?  CustomTextField(
                      controller: limitController,
                      keyType: 0,
                      hint: 'Price Increase/Decrease By '.tr,
                      suffix: SuffixTextButton(
                        title: '(+/-) %'.tr,
                        onPressed: (){
                        },
                      ),
                      onChange: (value){
                        if(!isNumeric(limitController.text)){
                          return;
                        }
                        context.read<NotificationProvider>().setLimitValue(double.parse(limitController.text));
                        storageController.instance!.setDouble('limitValue', double.parse(limitController.text));
                        context.read<TokenProvider>().updateTokenStates();
                        sqliteController.updateAllState();
                      },
                    ) : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
