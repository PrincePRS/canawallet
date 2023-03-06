import 'package:cancoin_wallet/component/setting_components.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {

  bool tp = false;

  void togglePincodeState(){
    if(context.read<ParamsProvider>().pinCode == '') Get.toNamed(PageNames.createPinCode);
    else Get.toNamed(PageNames.removePinCode);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      this.tp = context.read<ParamsProvider>().askTransaction;
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
            fit: BoxFit.cover,
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
                      Text('security'.tr,
                         style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 20)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SettingItemButton(
              leftWidget: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text('pincode'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 16)),
              ),
              rightWidget: GestureDetector(
                onTap: (){
                  this.togglePincodeState();
                },
                child: Image.asset(context.watch<ParamsProvider>().pinCode != '' ? 'assets/images/switch-on.png' : 'assets/images/switch-off.png'),
              ),
              onPressed: (){
                this.togglePincodeState();
              }
            ),
            SizedBox(height: Get.height * 0.025),
          ],
        ),
      )
    );
  }
}
