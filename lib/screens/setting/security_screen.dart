import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
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
      backgroundColor: color.borderColor,
      appBar: AppBar(
        title: Text('security'.tr),
        backgroundColor: color.backColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('pincode'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 16)),
                    Switch(
                      value: context.watch<ParamsProvider>().pinCode != '',
                      onChanged: (value) {
                        this.togglePincodeState();
                      },
                      activeTrackColor: color.isDarkMode ? color.white : color.backColor,
                      activeColor: color.foreColor,
                    ),
                  ],
                ),
                onPressed: () async{
                },
                style: ElevatedButton.styleFrom(
                  onSurface: Colors.brown,
                  primary: color.btnSecondaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  elevation: 5.0
                ),
              ),
              SizedBox(height: Get.height * 0.025),
              context.watch<ParamsProvider>().pinCode == '' ? Container() : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.025),
                  Text('join_community'.tr, style: TextStyle(color: color.foreColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: Get.height * 0.025),
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('transaction_sign'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 16)),
                        Switch(
                          value: this.tp,
                          onChanged: (value) {
                            setState(() {
                              this.tp = value;
                            });
                            context.read<ParamsProvider>().setAskTransaction(value);
                            storageController.instance!.setBool('askTransaction', value);
                          },
                          activeTrackColor: color.isDarkMode ? color.white : color.backColor,
                          activeColor: color.foreColor,
                        ),
                      ],
                    ),
                    onPressed: () async{
                    },
                    style: ElevatedButton.styleFrom(
                      onSurface: Colors.brown,
                      primary: color.btnSecondaryColor,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      elevation: 5.0
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
