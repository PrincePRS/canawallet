import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancoin_wallet/component/setting_components.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fitHeight,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.05, horizontal: Get.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('notification'.tr, style: TextStyle(fontSize: 28, fontFamily: Strings.fBold, color: color.foreColor)),
                      GestureDetector(
                        onTap: (){
                          sqliteController.clearNotification();
                          context.read<TokenProvider>().clearAlerts();
                        },
                        child: Text('Clear'.tr, style: TextStyle(
                          fontFamily: Strings.fSemiBold,
                          fontSize: 19,
                          color: color.btnPrimaryColor,
                          decoration: TextDecoration.underline
                        )),
                      )
                    ],
                  ),
                ),
                context.read<TokenProvider>().alerts.length == 0 ? Center(
                  child: Text('Empty Data',
                    style: TextStyle(fontFamily: Strings.fSemiBold, fontSize: 16),
                  )
                ) : Column(
                  children: List.generate(context.watch<TokenProvider>().alerts.length, (index) => Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: SettingItemButton(
                        leftWidget: Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                  imageUrl: context.watch<TokenProvider>().alerts[index].logo,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Image.asset('assets/images/coin.png')
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(context.read<TokenProvider>().alerts[index].time, style: TextStyle(color: color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fMedium)),
                                    Text(context.read<TokenProvider>().alerts[index].title, style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
                                  ],
                                )
                              )
                            ],
                          ),
                        ),
                        rightWidget: GestureDetector(
                          child: Icon(
                            Icons.delete_forever,
                            size: 26,
                            color: color.isDarkMode ? color.textColor : color.textColor
                          ),
                          onTap: (){
                            sqliteController.deleteNotification(context.read<TokenProvider>().alerts[index].id!);
                            context.read<TokenProvider>().deleteAlert(index);
                          },
                        ),
                        onPressed: () async {
                          if(context.read<TokenProvider>().alerts[index].title == 'transaction_complete'.tr){
                            String url = Strings.txUrls[context.read<TokenProvider>().curNetwork] + context.read<TokenProvider>().alerts[index].value;
                            await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
                          }
                        }
                      )
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
