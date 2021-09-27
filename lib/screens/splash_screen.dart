import 'package:cancoin_wallet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/controller/Localization_Controller.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/model/token_info.dart';
import 'package:cancoin_wallet/model/utils.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:cancoin_wallet/screens/banner_screen.dart';
import 'package:cancoin_wallet/screens/dashboard_screen.dart';
import 'package:cancoin_wallet/screens/setting/guard_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:web3dart/web3dart.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  bool isEmpty = true;

  void checkStorage() async{
    await storageController.getInstance();

    // check wallet state

    String? privateKey = storageController.instance!.getString('privateKey');
    if(privateKey != null) {
      setState(() {
        this.isEmpty = false;
      });
      Credentials credentials = EthPrivateKey.fromHex(privateKey);
      credentials.extractAddress().then((value) {
          web3Controller.setCredentials(privateKey);
      });
    }

    // check language state

    String? lang = storageController.instance!.getString('lang');
    if(lang != null) {
      LocalizationController().changeLocale(storageController.instance!.getString('lang')!);
    }

    // check Theme state

    int? theme = storageController.instance!.getInt('theme');
    if(theme != null) {
      if(theme == 0) color.themeSwitcher(ThemeSwitchMode.light);
      else if(theme == 1) color.themeSwitcher(ThemeSwitchMode.dark);
    }else{
      color.themeSwitcher(ThemeSwitchMode.dark);
      storageController.instance!.setInt('theme', 1);
    }

    // check pincode state

    String? code = storageController.instance!.getString('pinCode');
    if(code != null) {
      context.read<ParamsProvider>().setPinCode(code);
      context.read<ParamsProvider>().setNextPage(DashboardScreen());
      // paramsController.setPinCode(code);
      // paramsController.setNextPage(DashboardScreen());
    }

    bool? askTransaction = storageController.instance!.getBool('askTransaction');
    if(askTransaction != null) {
      context.read<ParamsProvider>().setAskTransaction(askTransaction);
      // paramsController.setAskTransaction(askTransaction);
    }else {
      context.read<ParamsProvider>().setAskTransaction(false);
      // paramsController.setAskTransaction(false);
      storageController.instance!.setBool('askTransaction', false);
    }

    //  getTokens

    await sqliteController.open();
    List<TokenInfo> tokens = await sqliteController.getTokenList();
    context.read<TokenProvider>().setAllTokens(tokens);

    int? chain = storageController.instance!.getInt('network');
    if(chain == null){
      storageController.instance!.setInt('network', 0);
    }else{
      if(privateKey != null) context.read<TokenProvider>().changeNetwork(chain);
    }

    context.read<TokenProvider>().startTimer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => checkStorage());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: this.isEmpty ? BoardScreen() : ( context.read<ParamsProvider>().pinCode != '' ? GuardScreen() : DashboardScreen()),
      duration: 7000,
      imageSize: (Get.width * 0.4).round(),
      imageSrc: "assets/images/splash-logo.png",
      text: "TheCanCoin",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        color: color.black,
        fontSize: 30.0,
        fontFamily: Strings.fBold
      ),
      colors: [
        Color(0xffffc048),
        Color(0xffd2b3f5),
        Color(0xffffffff),
        Color(0xff222222)
      ],
      backgroundColor: color.backColor
    );
  }
}