import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart'; 
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/controller/Localization_Controller.dart';

import 'package:cancoin_wallet/global.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {

  List<String> images = [];
  List<String> titles = [];
  List<String> subtitles = [];
  int selectedIndex = 0;

  void showLanguageModal(){
    String? lang = storageController.instance!.getString('lang');
    if(lang == null) {
      Get.defaultDialog(
        backgroundColor: color.btnSecondaryColor,
        title: '',
        titleStyle: TextStyle(fontSize: 0),
        barrierDismissible: false,
        radius: 7,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Select Language'.tr, textAlign: TextAlign.center, style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 18)),
              SizedBox(height: 30),
              PrimaryButton(
                title: 'English',
                isActive: true,
                onPressed: () {
                  LocalizationController().changeLocale('English');
                  storageController.instance!.setString('lang', 'English');
                  Get.back();
                }
              ),
              SizedBox(height: 10),
              PrimaryButton(
                title: '汉语',
                isActive: true,
                onPressed: () {
                  LocalizationController().changeLocale('Chinese');
                  storageController.instance!.setString('lang', 'Chinese');
                  Get.back();
                }
              ),
            ],
          )
        )
      );
    }else{

    }
  }

  @override
  void initState() {
    super.initState();
    this.titles = [
      'A Revolution',
      'Private and secure',
      'Buy and keep',
      'Privacy and secure 4'
    ];
    this.subtitles = [
      'within the legal cannabis market is coming',
      'Private keys never leave your device',
      'Private keys never leave your device',
      'Private keys never leave your device 4.'
    ];
    setState(() {
      this.selectedIndex = 0;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) => showLanguageModal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.backColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Swiper(
          loop: false,
          itemBuilder: (BuildContext context,int index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.08),
                Expanded(child: Image.asset('assets/images/banner' + (index + 1).toString() + '.png', fit: BoxFit.contain)),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
                  height: 2,
                  color: color.borderColor
                ),
                index < 3 ?
                  Container(
                    height: Get.height * 0.2,
                    margin: EdgeInsets.only(top: Get.height * 0.08),
                    padding: EdgeInsets.only(left: Get.width * 0.05,right: Get.width * 0.05),
                    child: Column(
                      children: [
                        Text(this.titles[index], style: TextStyle(color: color.btnPrimaryColor, fontSize: 28, fontFamily: Strings.fBold), textAlign: TextAlign.center),
                        SizedBox(height: Get.height * 0.03),
                        Text(this.subtitles[index], style: TextStyle(color: color.textColor, fontSize: 16, fontFamily: Strings.fSemiBold), textAlign: TextAlign.center)
                      ],
                    ),
                  ) :
                  Container(
                    height: Get.height * 0.2,
                    margin: EdgeInsets.only(top: Get.height * 0.08),
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          child: Text('create_wallet'.tr, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: Strings.fSemiBold)),
                          onPressed: () {
                            Get.toNamed(PageNames.recover);
                          },
                          style: ElevatedButton.styleFrom(
                            onSurface: Colors.brown,
                            primary: color.btnPrimaryColor,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                        ),
                        SizedBox(height: Get.height * 0.03),
                        OutlinedButton(
                          onPressed: () async {
                            Get.toNamed(PageNames.backup);
                          },
                          style: OutlinedButton.styleFrom(
                            primary: color.btnPrimaryColor,
                            side: BorderSide(color: color.btnPrimaryColor, width: 1),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                            // backgroundColor: Colors.teal,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                            child: Text('have_wallet'.tr, style: TextStyle(color: color.btnPrimaryColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                          ),
                        )
                      ],
                    ),
                  ),
                Container(color: color.contrastColor, height: Get.height * 0.12)
              ],
            );
          },
          itemCount: 4,
          onIndexChanged: (index){
            setState(() {
              this.selectedIndex = index;
            });
          },
          pagination: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig? config){
              return Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (idx) => Container(
                        margin: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, bottom: Get.height * 0.07),
                        height: 10,
                        width: this.selectedIndex == idx ? 30 : 10,
                        decoration: BoxDecoration(
                          color: this.selectedIndex == idx ? color.btnPrimaryColor : color.borderColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                      )
                    )
                  ),
                ),
              );
            }
          ),
          index: this.selectedIndex,
        ),
      )
    );
  }
}
