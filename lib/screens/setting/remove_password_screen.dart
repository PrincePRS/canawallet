import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/screens/setting/security_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class RemovePasswordScreen extends StatefulWidget {
  const RemovePasswordScreen({Key? key}) : super(key: key);

  @override
  _RemovePasswordScreenState createState() => _RemovePasswordScreenState();
}

class _RemovePasswordScreenState extends State<RemovePasswordScreen> {

  TextEditingController pincodeController = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.backColor,
      body: Padding(
        padding: EdgeInsets.only(left: Get.width * 0.07, right: Get.width * 0.07, top: Get.height * 0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/locked-circle.png', width: 250, height: 250, fit: BoxFit.cover),
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
                autoDismissKeyboard: true,
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
                  if(v == context.read<ParamsProvider>().pinCode){
                    context.read<ParamsProvider>().setPinCode('');
                    storageController.instance!.remove('pinCode');
                    Get.back();
                  }else{
                    errorController.add(ErrorAnimationType.shake);
                    setState(() {
                      pincodeController.text = '';
                    });
                    Get.snackbar('Warning!', "Wrong Password",
                      colorText: color.foreColor,
                      backgroundColor: color.btnSecondaryColor,
                      isDismissible: true
                    );
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
