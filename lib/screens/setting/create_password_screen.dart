import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/screens/setting/security_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {

  TextEditingController pincodeController = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  String password = '';
  String title = 'enter_passcode'.tr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      body: Padding(
        padding: EdgeInsets.only(left: Get.width * 0.07, right: Get.width * 0.07, top: Get.height * 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(this.title.tr, style: TextStyle(color: color.foreColor, fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: Get.height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: Get.height * 0.04),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: true,
                obscuringWidget: Image.asset('assets/images/king_icon.png', width: 30, height: 30, fit: BoxFit.cover),
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                autoFocus: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  inactiveColor: color.btnSecondaryColor,
                  activeFillColor: color.foreColor,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: color.backColor,
                enableActiveFill: false,
                errorAnimationController: errorController,
                controller: pincodeController,
                onCompleted: (v) {
                  if(this.password == ''){
                    setState(() {
                      this.title = 'reenter_passcode'.tr;
                      this.password = v;
                      this.pincodeController.text = '';
                    });
                  }else{
                    if(this.password == pincodeController.text){
                      context.read<ParamsProvider>().setPinCode(this.password);
                      storageController.instance!.setString('pinCode', this.password);
                      Get.back();
                    }else{
                      errorController.add(ErrorAnimationType.shake);
                      setState(() {
                        this.pincodeController.text = '';
                      });
                      Get.snackbar('Incorrect Pincode', 'Try Again',
                        colorText: color.foreColor,
                        backgroundColor: color.btnSecondaryColor,
                        isDismissible: true
                      );
                    }
                  }
                },
                onChanged: (value) {
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
