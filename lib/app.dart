import 'package:cancoin_wallet/screens/setting/account_screen.dart';
import 'package:cancoin_wallet/screens/wallet/buy_screen.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/controller/Localization_Controller.dart';
import 'package:cancoin_wallet/controller/storageController.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:cancoin_wallet/screens/banner_screen.dart';
import 'package:cancoin_wallet/screens/create_wallet/backup_screen.dart';
import 'package:cancoin_wallet/screens/qrreader_screen.dart';
import 'package:cancoin_wallet/screens/setting/theme_screen.dart';
import 'package:cancoin_wallet/screens/setting/walletconnect_screen.dart';
import 'package:cancoin_wallet/screens/wallet/sign_screen.dart';
import 'package:cancoin_wallet/screens/wallet/token_list_screen.dart';
import 'package:cancoin_wallet/screens/wallet/transaction_screen.dart';
import 'package:cancoin_wallet/screens/wallet/transfer_form_screen.dart';
import 'package:cancoin_wallet/screens/dashboard_screen.dart';
import 'package:cancoin_wallet/screens/create_wallet/qr_info_screen.dart';
import 'package:cancoin_wallet/screens/create_wallet/randphrase_screen.dart';
import 'package:cancoin_wallet/screens/create_wallet/recover_screen.dart';
import 'package:cancoin_wallet/screens/create_wallet/successwallet_screen.dart';
import 'package:cancoin_wallet/screens/create_wallet/verifyphrase_screen.dart';
import 'package:cancoin_wallet/screens/wallet/receive_screen.dart';
import 'package:cancoin_wallet/screens/setting/create_password_screen.dart';
import 'package:cancoin_wallet/screens/setting/guard_screen.dart';
import 'package:cancoin_wallet/screens/setting/language_screen.dart';
import 'package:cancoin_wallet/screens/setting/remove_password_screen.dart';
import 'package:cancoin_wallet/screens/setting/security_screen.dart';
import 'package:cancoin_wallet/screens/setting/setting_screen.dart';
import 'package:cancoin_wallet/screens/splash_screen.dart';
import 'package:cancoin_wallet/screens/wallet/token_send_screen.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  ThemeData DarKTheme = ThemeData(
    primaryColor: Color(0xff010E46),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TokenProvider>(create: (context) => TokenProvider()),
        ChangeNotifierProvider<ParamsProvider>(create: (context) => ParamsProvider())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.APP_NAME,
        initialRoute: '/',
        getPages: [
          GetPage(name: PageNames.init, page: () => LoadingScreen()),
          GetPage(name: PageNames.board, page: () => BoardScreen()),
          GetPage(name: PageNames.recover, page: () => RecoverScreen()),
          GetPage(name: PageNames.randphrase, page: () => RandPhraseScreen()),
          GetPage(name: PageNames.verifyphrase, page: () => VerifyPhraseScreen()),
          GetPage(name: PageNames.successwallet, page: () => SuccessWalletScreen()),
          GetPage(name: PageNames.qrinfo, page: () => QRInfoScreen()),
          GetPage(name: PageNames.dashbaord, page: () => DashboardScreen()),
          GetPage(name: PageNames.backup, page: () => BackupScreen()),
          GetPage(name: PageNames.qrreader, page: () => QRCodeReaderPage()),
          GetPage(name: PageNames.sendToken, page: () => SendTokenScreen()),
          GetPage(name: PageNames.transferForm, page: () => TransferFormScreen()),
          GetPage(name: PageNames.receive, page: () => ReceiveScreen()),
          GetPage(name: PageNames.setting, page: () => SettingScreen()),
          GetPage(name: PageNames.language, page: () => LanguageScreen()),
          GetPage(name: PageNames.theme, page: () => ThemeScreen()),
          GetPage(name: PageNames.security, page: () => SecurityScreen()),
          GetPage(name: PageNames.guard, page: () => GuardScreen()),
          GetPage(name: PageNames.createPinCode, page: () => CreatePasswordScreen()),
          GetPage(name: PageNames.removePinCode, page: () => RemovePasswordScreen()),
          GetPage(name: PageNames.signTx, page: () => SignTransactionScreen()),
          GetPage(name: PageNames.tokenList, page: () => TokenListScreen()),
          GetPage(name: PageNames.walletconnect, page: () => WalletConnectScreen()),
          GetPage(name: PageNames.buy, page: () => BuyScreen()),
          GetPage(name: PageNames.txInfo, page: () => TransactionScreen()),
          GetPage(name: PageNames.walletAccount, page: () => AccountScreen())
        ],
        locale: LocalizationController.locale,
        fallbackLocale: LocalizationController.fallbackLocale,
        translations: LocalizationController(),
      ),
    );
  }
}
