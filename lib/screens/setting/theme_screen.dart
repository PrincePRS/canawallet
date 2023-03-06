import 'package:cancoin_wallet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/controller/Localization_Controller.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/model/utils.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {

  int? theme;

  setLanguage(String newLang){
    LocalizationController().changeLocale(newLang);
    storageController.instance!.setString('lang', newLang);
    Get.back();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.theme = storageController.instance!.getInt('theme');
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
              fit: BoxFit.fitHeight,
            ),
          ),
          child: SingleChildScrollView(
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
                      children: [
                        Icon(Icons.arrow_back_outlined, size: 30, color: color.foreColor),
                        Text('  ' + 'theme'.tr, style: TextStyle(fontSize: 20, fontFamily: Strings.fSemiBold, color: color.foreColor))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                  child: Text('select_theme'.tr, style: TextStyle(fontSize: 14, fontFamily: Strings.fSemiBold, color: color.contrastTextColor)),
                ),
                OutlinedButton(
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
                          Text('dark_mode'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 6),
                        alignment: Alignment.topCenter,
                        width: Get.width * 0.1,
                        child: InkWell(
                          onTap: () {
                            color.themeSwitcher(ThemeSwitchMode.dark);
                            storageController.instance!.setInt('theme', 1);
                            setState(() {
                              this.theme = 1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: this.theme == 1 ? color.btnPrimaryColor : Colors.transparent,
                              border: Border.all(color: color.btnPrimaryColor, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: this.theme == 1 ? Icon(Icons.check, size: 17.0, color: Colors.white) : Icon(null, size: 17.0),
                          )
                        )
                      )
                    ]
                  ),
                  onPressed: () async{
                  },
                  style: ElevatedButton.styleFrom(
                    primary: color.white,
                    side: BorderSide(color: color.borderColor, width: 3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15)
                  ),
                ),
                SizedBox(height: Get.height * 0.025),
                OutlinedButton(
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
                          Text('light_mode'.tr, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                        ]
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 6),
                        alignment: Alignment.topCenter,
                        width: Get.width * 0.1,
                        child: InkWell(
                          onTap: () {
                            color.themeSwitcher(ThemeSwitchMode.light);
                            storageController.instance!.setInt('theme', 0);
                            setState(() {
                              this.theme = 0;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: this.theme == 0 ? color.btnPrimaryColor : Colors.transparent,
                              border: Border.all(color: color.btnPrimaryColor, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: this.theme == 0 ? Icon(Icons.check, size: 17.0, color: Colors.white) : Icon(null, size: 17.0),
                          )
                        )
                      )
                    ]
                  ),
                  onPressed: () async{
                  },
                  style: ElevatedButton.styleFrom(
                    primary: color.white,
                    side: BorderSide(color: color.borderColor, width: 3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15)
                  )
                )
              ]
            )
          )
        )
      );
    });
  }
}
