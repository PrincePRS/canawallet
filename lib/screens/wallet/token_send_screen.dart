import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/screens/wallet/wallet_tokens.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/model/transaction_info.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:cancoin_wallet/screens/wallet/chart_screen.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SendTokenScreen extends StatefulWidget {
  const SendTokenScreen({Key? key}) : super(key: key);

  @override
  _SendTokenScreenState createState() => _SendTokenScreenState();
}

class _SendTokenScreenState extends State<SendTokenScreen> with TickerProviderStateMixin{
  int selToken = 0;
  List<String> btnNames = ['1H', '1D', '1W', '1M', '1Y'];
  String address = '';

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<TransactionInfo> transactions = [];

  void getTransactions() async{
    if(context.read<TokenProvider>().curNetwork < 3){
      address = await web3Controller.getAddress();
      Response result;
      if(context.read<TokenProvider>().tokens[this.selToken].address == ''){
        result = await connectController.getTransactionList(Strings.explorers[context.read<TokenProvider>().curNetwork] + 'module=account&action=txlist&address=' + address + '&startblock=0&endblock=999999999&sort=asc');
      }else{
        result = await connectController.getTransactionList(Strings.explorers[context.read<TokenProvider>().curNetwork] + 'module=account&action=tokentx&address=' + address + '&startblock=0&endblock=999999999&sort=asc');
      }
      var body = result.body;
      if(body == null) return;
      List<dynamic> res = body['result'];
      List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      res.forEach((element) {
        DateTime t = DateTime.fromMillisecondsSinceEpoch(int.parse(element['timeStamp']) * 1000);
        this.transactions.add(TransactionInfo.fromMap({
          'hash': element['hash'],
          'isSent': element['from'] == address,
          'receiver': element['from'] == address ? element['to'] : element['from'],
          'status': 1,
          'nonce' : int.parse(element['nonce']),
          'fee' : double.parse(((BigInt.parse(element['gasUsed']) / BigInt.from(10).pow(10)).toDouble() / 100000000.0).toString()),
          'value': double.parse(((BigInt.parse(element['value']) / BigInt.from(10).pow(10)).toDouble() / 100000000.0).toString()),
          'date' :  months[t.month - 1] + ' ' + t.day.toString() + ', ' + t.year.toString()
        }));
        setState(() {
          this.transactions = this.transactions;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.selToken = context.read<ParamsProvider>().selTokenId;
      getTransactions();
    });
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: Get.height * 0.07),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: Get.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Get.back();
                            },
                            child: Icon(LineIcons.arrowLeft, color: color.textColor, size: 30),
                          ),
                          SizedBox(width: 15),
                          Text(context.read<TokenProvider>().tokens[this.selToken].name,
                            style: TextStyle(color: color.foreColor, fontFamily: Strings.fMedium, fontSize: 18)
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: (){
                          AnimationController _animController = BottomSheet.createAnimationController(this);
                          _animController.duration = Duration(milliseconds: 500);
                          showModalBottomSheet(
                            transitionAnimationController: _animController,
                            isScrollControlled:true,
                            enableDrag: false,
                            isDismissible: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            barrierColor: color.backColor.withOpacity(0.2),
                            context: context,
                            builder: (context) => ChartScreen()
                          );
                        },
                        icon: FaIcon(FontAwesomeIcons.chartLine), color: color.textColor,
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(35.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                    imageUrl: context.watch<TokenProvider>().tokens[this.selToken].logo,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset('assets/images/coin.png')
                  )
                ),
                SizedBox(height: 20),
                Text(context.watch<TokenProvider>().tokens[this.selToken].balance.toString() + ' ' + context.read<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(),
                  style: TextStyle(color: color.btnPrimaryColor, fontSize: 28, fontFamily: Strings.fSemiBold)
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
                      CircularButton(
                        title: 'send'.tr,
                        url: 'send-icon.png',
                        onPressed: (){
                          context.read<ParamsProvider>().setAmount('');
                          Get.toNamed(PageNames.transferForm);
                        }
                      ),
                      CircularButton(
                        title: 'receive'.tr,
                        url: 'receive-icon.png',
                        onPressed: (){
                          Get.toNamed(PageNames.receive);
                        }
                      ),
                      CircularButton(
                        title: 'buy'.tr,
                        url: 'buy-icon.png',
                        onPressed: (){}
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, top: 15),
                    alignment: Alignment.centerLeft,
                    color: color.contrastColor,
                    child: Text('My Transactions', style: TextStyle(color: color.lightTextColor, fontFamily: Strings.fSemiBold, fontSize: 14))
                ),
                Expanded(
                  child: context.watch<TokenProvider>().tokens.length == 0 ? Container(color: color.contrastColor, child: CircularProgressIndicator())
                      : Container(
                    color: color.contrastColor,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.01),
                      children: List.generate(this.transactions.length, (index){
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: OutlinedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(11),
                                          // child: Icon(transactions[index].isSent ? Icons.upload_sharp : Icons.download_sharp, size: 26, color: color.btnPrimaryColor),
                                          child: Image.asset(transactions[index].isSent ? 'assets/images/bsend-icon.png' : 'assets/images/breceive-icon.png'),
                                          decoration: BoxDecoration(
                                            color: color.white,
                                            borderRadius: BorderRadius.circular(30)
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(this.transactions[index].date, overflow: TextOverflow.ellipsis, style: TextStyle(color: color.contrastTextColor, fontSize: 16, fontFamily: Strings.fMedium)),
                                              SizedBox(height: Get.height * 0.01,),
                                              Row(
                                                children: [
                                                  Text(transactions[index].isSent ?  'To: ' : 'From: ', overflow: TextOverflow.ellipsis, style: TextStyle(color: color.contrastTextColor, fontSize: 12, fontFamily: Strings.fRegular)),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(this.transactions[index].receiver, overflow: TextOverflow.ellipsis, style: TextStyle(color: color.contrastTextColor, fontSize: 14))
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width * 0.25,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(transactions[index].isSent ? '-' : '+', style: TextStyle(color: this.transactions[index].isSent ? color.warn : color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                                      Expanded(
                                        child: Text(this.transactions[index].value.toString() + context.read<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: this.transactions[index].isSent ? color.warn : color.btnPrimaryColor, fontSize: 18)
                                        )
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                            onPressed: () async {
                              context.read<ParamsProvider>().setTransaction(this.transactions[index]);
                              Get.toNamed(PageNames.txInfo);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              primary: color.contrastColor,
                              onSurface: Colors.green,
                              side: BorderSide(color: color.backColor, width: 0),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                            ),
                          )
                        );
                      }),
                    ),
                  )
                )
              ],
            ),
          )
      );
    });
  }
}

