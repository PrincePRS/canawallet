import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/constants/chains.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WalletToken extends StatefulWidget {
  const WalletToken({Key? key}) : super(key: key);
  @override
  _WalletTokenState createState() => _WalletTokenState();
}

class _WalletTokenState extends State<WalletToken> {

  bool isNumeric(String s) {
    try{
      double.parse(s);
      return true;
    }catch(ex){
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text("\$ " + context.watch<TokenProvider>().totalBalance.toString(), style: TextStyle(color: color.btnPrimaryColor, fontSize: 38, fontFamily: Strings.fBold)),
          SizedBox(height: 5),
          Text("My Wallet", style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold)),
          SizedBox(height: 10),
          OutlinedButton(
            onPressed: () async {
              Get.defaultDialog(
                backgroundColor: color.isDarkMode ? color.btnSecondaryColor : color.white,
                title: '', // 'select_network'.tr,
                titleStyle: TextStyle(fontSize: 0),
                radius: 7,
                content: Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, bottom: Get.height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('select_network'.tr, style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 18)),
                          GestureDetector(
                            onTap: (){
                              Get.back();
                              Get.toNamed(PageNames.tokenList);
                            },
                            child: Image.asset('assets/images/tokens.png'),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: Get.height * 0.4,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(Chains.chains.length, (idx){
                              return ModalNetworkItem(
                                url: Chains.chains[idx].logo,
                                name: Chains.chains[idx].symbol,
                                selected: context.read<TokenProvider>().curNetwork == idx,
                                onPressed: () async{
                                  context.read<TokenProvider>().changeNetwork(idx);
                                  Get.back();
                                },
                              );
                            }
                           )
                          ),
                        ),
                      ),
                    ],
                  )
                )
              );
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              side: BorderSide(color:  Color(0x99000000), width: 2),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            child: Text(Chains.chains[context.watch<TokenProvider>().curNetwork].symbol, style: TextStyle(color: color.textColor, fontSize: 14, fontFamily: Strings.fRegular),overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            height: 2,
            color: color.borderColor,
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.15, right: Get.width * 0.15, bottom: Get.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: color.btnPrimaryColor,
                        child: InkWell(
                          key: Key('sendBtn'),
                          onTap: ()async{
                            Get.defaultDialog(
                                backgroundColor: color.btnSecondaryColor,
                                title: '',
                                titleStyle: TextStyle(fontSize: 0),
                                radius: 7,
                                content: Padding(
                                    padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, bottom: Get.height * 0.03),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text('select_token'.tr, style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 18)),
                                        SizedBox(height: 10),
                                        Container(
                                          height: Get.height * 0.45,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                                children: List.generate(context.read<TokenProvider>().allTokens.length + 1, (idx){
                                                  if(idx == 0) return Container();
                                                  // if(idx == 0) return Padding(
                                                  //   padding: EdgeInsets.symmetric(vertical: 7),
                                                  //   child: OutlinedButton(
                                                  //     key: Key('sendToken' + idx.toString()),
                                                  //     child: Row(
                                                  //       children: [
                                                  //         Row(
                                                  //           children: [
                                                  //             Container(
                                                  //               padding: EdgeInsets.all(11),
                                                  //               // child: Icon(transactions[index].isSent ? Icons.upload_sharp : Icons.download_sharp, size: 26, color: color.btnPrimaryColor),
                                                  //               child: Image.asset('assets/images/scan.png'),
                                                  //               decoration: BoxDecoration(
                                                  //                   color: color.white,
                                                  //                   borderRadius: BorderRadius.circular(30)
                                                  //               ),
                                                  //             ),
                                                  //             Text('QR SCAN', style: TextStyle(color: color.foreColor, fontSize: 14, fontFamily: Strings.fMedium)),
                                                  //           ],
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //     onPressed: () async{
                                                  //       Get.back();
                                                  //       String result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> QRCodeReaderPage()));
                                                  //       List<String> splits = result.split(':');
                                                  //       if(splits.length != 3 || !isNumeric(splits[2]) || !Strings.Address_Reg.hasMatch(splits[1])){
                                                  //         Get.snackbar('QRCode Format Error'.tr, result,
                                                  //             colorText: color.foreColor,
                                                  //             backgroundColor: color.btnSecondaryColor,
                                                  //             isDismissible: true
                                                  //         );
                                                  //         return;
                                                  //       }
                                                  //
                                                  //       for(var i = 0; i < context.read<TokenProvider>().allTokens.length; i ++){
                                                  //         if(splits[0] == context.read<TokenProvider>().allTokens[i].tokenId){
                                                  //           context.read<TokenProvider>().changeNetwork(context.read<TokenProvider>().allTokens[i].chainId);
                                                  //           break;
                                                  //         }
                                                  //       }
                                                  //       for(var i = 0; i < context.read<TokenProvider>().tokens.length; i ++){
                                                  //         if(splits[0] == context.read<TokenProvider>().tokens[i].tokenId){
                                                  //           context.read<ParamsProvider>().setTokenId(i);
                                                  //           context.read<ParamsProvider>().setReceiver(splits[1]);
                                                  //           context.read<ParamsProvider>().setAmount(splits[2]);
                                                  //           // Get.back();
                                                  //           Get.toNamed(PageNames.transferForm);
                                                  //           return;
                                                  //         }
                                                  //       }
                                                  //
                                                  //       Get.snackbar('Undefined Token'.tr, 'Please add token, first',
                                                  //           colorText: color.foreColor,
                                                  //           backgroundColor: color.btnSecondaryColor,
                                                  //           isDismissible: true
                                                  //       );
                                                  //
                                                  //     },
                                                  //     style: OutlinedButton.styleFrom(
                                                  //       onSurface: Colors.brown,
                                                  //       primary: color.borderColor,
                                                  //       side: BorderSide(color:  color.borderColor, width: 2),
                                                  //       padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                                                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                                  //       textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  //     ),
                                                  //   ),
                                                  // );
                                                  return ModalTokenItem(
                                                    url: context.read<TokenProvider>().allTokens[idx - 1].logo,
                                                    name: context.read<TokenProvider>().allTokens[idx - 1].name,
                                                    onPressed: (){
                                                      context.read<TokenProvider>().changeNetwork(context.read<TokenProvider>().allTokens[idx - 1].chainId);
                                                      for(var i = 0; i < context.read<TokenProvider>().tokens.length; i ++){
                                                        if(context.read<TokenProvider>().tokens[i].tokenId == context.read<TokenProvider>().allTokens[idx - 1].tokenId){
                                                          context.read<ParamsProvider>().setTokenId(i);
                                                          break;
                                                        }
                                                      }
                                                      context.read<ParamsProvider>().setAmount('');
                                                      Get.back();
                                                      Get.toNamed(PageNames.transferForm);
                                                    }
                                                  );
                                                })
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset('assets/images/send-icon.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('send'.tr, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                  ],
                ),
                Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: color.btnPrimaryColor,
                        child: InkWell(
                          onTap: (){
                            Get.defaultDialog(
                              backgroundColor: color.btnSecondaryColor,
                              title: '',
                              titleStyle: TextStyle(fontSize: 0),
                              content: Padding(
                                padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, bottom: Get.height * 0.03),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text('select_token'.tr, style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 18)),
                                    SizedBox(height: 10),
                                    Container(
                                      height: Get.height * 0.45,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: List.generate(context.read<TokenProvider>().allTokens.length, (idx){
                                            return ModalTokenItem(
                                              url: context.read<TokenProvider>().allTokens[idx].logo,
                                              name: context.read<TokenProvider>().allTokens[idx].name,
                                              onPressed: () async{
                                                context.read<TokenProvider>().changeNetwork(context.read<TokenProvider>().allTokens[idx].chainId);
                                                for(var i = 0; i < context.read<TokenProvider>().tokens.length; i ++){
                                                  if(context.read<TokenProvider>().tokens[i].tokenId == context.read<TokenProvider>().allTokens[idx].tokenId){
                                                    context.read<ParamsProvider>().setTokenId(i);
                                                    break;
                                                  }
                                                }
                                                Get.back();
                                                Get.toNamed(PageNames.receive);
                                              }
                                            );
                                          })
                                        )
                                      )
                                    )
                                  ]
                                )
                              )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset('assets/images/receive-icon.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('receive'.tr, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                  ],
                ),
                Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: color.btnPrimaryColor,
                        child: InkWell(
                          onTap: (){
                            Get.toNamed(PageNames.buy);

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset('assets/images/buy-icon.png')
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('buy'.tr, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, top: 15),
            alignment: Alignment.centerLeft,
            color: color.contrastColor,
            child: Text('My Wallet', style: TextStyle(color: color.lightTextColor, fontFamily: Strings.fSemiBold, fontSize: 14))
          ),
          Expanded(
            child: context.watch<TokenProvider>().tokens.length == 0 ? Container(color: color.contrastColor, child: CircularProgressIndicator())
                : Container(
              color: color.contrastColor,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
                children: List.generate(context.watch<TokenProvider>().tokens.length, (index){
                  if(!context.watch<TokenProvider>().tokens[index].isActive) return Container();
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: OutlinedButton(
                      onPressed: (){
                        context.read<ParamsProvider>().setTokenId(index);
                        Get.toNamed(PageNames.sendToken);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                  imageUrl: context.read<TokenProvider>().tokens[index].logo,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Image.asset('assets/images/coin.png'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(context.read<TokenProvider>().tokens[index].name, overflow: TextOverflow.ellipsis,  style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold), ),
                                  context.watch<TokenProvider>().curNetwork != 2 ? Row(
                                    children: [
                                      Text("\$" + context.watch<TokenProvider>().tokens[index].price.toString() , style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 12, fontFamily: Strings.fRegular)),
                                      SizedBox(height: 20),
                                      Text((context.watch<TokenProvider>().tokens[index].change > 0 ? '  +' : '  ') + context.watch<TokenProvider>().tokens[index].change.toString() + "%", style: TextStyle(color: context.watch<TokenProvider>().tokens[index].change > 0 ? color.btnPrimaryColor : color.warn, fontSize: 12, fontFamily: Strings.fRegular))
                                    ]
                                  ) : Container()
                                ]
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text( context.read<TokenProvider>().tokens[index].balance.toString() + ' ' + context.read<TokenProvider>().tokens[index].symbol.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 18, fontFamily: Strings.fSemiBold),
                              textAlign: TextAlign.right,
                            )
                          )
                        ]
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        primary: color.contrastColor,
                        onSurface: Colors.green,
                        side: BorderSide(color: color.backColor, width: 0),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                    ),
                  );
                }),
              ),
            )
          )
        ]
      )
    );
  }
}