import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class GuardScreen extends StatefulWidget {
  const GuardScreen({Key? key}) : super(key: key);

  @override
  _GuardScreenState createState() => _GuardScreenState();
}

class _GuardScreenState extends State<GuardScreen> {

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
            Image.asset('assets/images/banner4.png', width: 250, height: 250, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: Get.height * 0.04),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: true,
                obscuringWidget: Image.asset('assets/images/splash-logo.png', width: 30, height: 30, fit: BoxFit.cover),
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                autoFocus: true,
                autoDismissKeyboard: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  inactiveColor: color.borderColor,
                  activeColor: color.btnPrimaryColor,
                  selectedColor: color.contrastTextColor,
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
                    Get.off(context.read<ParamsProvider>().nextPage);
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
