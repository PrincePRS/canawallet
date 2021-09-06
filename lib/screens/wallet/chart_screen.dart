import 'package:coingecko_dart/dataClasses/coins/CoinDataPoint.dart';
import 'package:coingecko_dart/dataClasses/coins/FullCoin.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:provider/provider.dart';
import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:cancoin_wallet/constants/chains.dart';


class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int selToken = 0;
  int setId = 0;
  bool isLoading = false;

  double minX = 0;
  double maxX = 11;
  double minY = 0;
  double maxY = 6;

  double marketCap = 0;
  double volume24 = 0;
  double circularSupply = 0;
  double totalSupply = 0;

  List<FlSpot> spots = [];

  List<String> btnNames = ['1H', '1D', '1W', '1M', '1Y'];
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  void getPriceData() async {
    setState(() {
      this.isLoading = true;
    });
    DateTime to = DateTime.now();
    DateTime from = to;
    int step = 1;
    if(this.setId == 0){
      from = new DateTime(from.year, from.month, from.day, from.hour - 1, from.minute, from.second);
    }else if(this.setId == 1){
      from = new DateTime(from.year, from.month, from.day - 1, from.hour, from.minute, from.second);
    }else if(this.setId == 2){
      from = new DateTime(from.year, from.month, from.day - 7, from.hour - 1, from.minute, from.second);
    }else if(this.setId == 3){
      from = new DateTime(from.year, from.month - 1, from.day, from.hour - 1, from.minute, from.second);
    }else if(this.setId == 4){
      from = new DateTime(from.year - 1, from.month, from.day, from.hour - 1, from.minute, from.second);
    }

    CoinGeckoResult<List<CoinDataPoint>> result;
    if(context.read<TokenProvider>().tokens[this.selToken].address == ''){
      result = await coinGeckoApi.getCoinMarketChartRanged(id: context.read<TokenProvider>().tokens[this.selToken].tokenId, vsCurrency: 'usd', from: from, to: to);
    }else{
      result = await coinGeckoApi.getContractMarketChartRanged(id: Chains.chains[context.read<TokenProvider>().curNetwork].name, contract_address: context.read<TokenProvider>().tokens[this.selToken].address, vsCurrency: 'usd', from: from, to: to);
    }

    if(result.data.length > 600) step = 3;
    else if(result.data.length > 300) step = 2;

    this.spots = [];
    int id = 0;

    this.minY = 10000000;
    this.maxY = 0;
    for(var i = 0; i < result.data.length; i += step){
      if(this.minY > result.data[i].price!) this.minY = result.data[i].price!;
      if(this.maxY < result.data[i].price!) this.maxY = result.data[i].price!;
      int decimalNo = 6;
      if(result.data[i].price! > 100) decimalNo = 2;
      else if(result.data[i].price! > 10) decimalNo = 4;
      this.spots.add(FlSpot(id.toDouble(), double.parse(result.data[i].price!.toStringAsFixed(decimalNo)) ));
      id ++;
    };
    this.maxX = id - 1;
    setState(() {
      this.spots = this.spots;
      this.minY = this.minY;
      this.maxY = this.maxY;
      this.maxX = this.maxX;
      this.isLoading = false;
    });
  }

  void getMarketInfo() async{
    CoinGeckoResult<List<FullCoin>> result;
    result = await coinGeckoApi.getCoinMarkets(vsCurrency: 'usd', coinIds: [context.read<TokenProvider>().tokens[this.selToken].tokenId]);
    if(result.data.length > 0){
      FullCoin coin = result.data[0];
      setState(() {
        this.marketCap = coin.marketCap!;
        this.circularSupply = coin.circulatingSupply!;
        this.totalSupply = coin.totalSupply!;
        if(coin.totalSupply! < 0) this.totalSupply = this.circularSupply;
        this.volume24 = coin.totalVolume!;
      });
    }
    // if(context.read<TokenProvider>().tokens[this.selToken].address == ''){
    //   // result = await coinGeckoApi.getCoinMarkets(coinIds: context.read<TokenProvider>().tokens[this.selToken].tokenId, vsCurrency: 'usd', from: from, to: to);
    //
    // }else{
    //   // result = await coinGeckoApi.getContractMarketChartRanged(id: Chains.chains[context.read<TokenProvider>().curNetwork].name, contract_address: context.read<TokenProvider>().tokens[this.selToken].address, vsCurrency: 'usd', from: from, to: to);
    //   result = await coinGeckoApi.
    // }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_){
      this.selToken = context.read<ParamsProvider>().selTokenId;
      getPriceData();
      getMarketInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.borderColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24)
        )
      ),
      height: Get.height * 0.95,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: Get.height * 0.02),
            color: color.backColor,
            child: Stack(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        color: color.white,
                      )
                    ]
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomCenter,
                  child: Text(context.watch<TokenProvider>().tokens[this.selToken].name.toString() + '(' + context.watch<TokenProvider>().tokens[this.selToken].symbol.toUpperCase() + ')', style: TextStyle(fontSize: 20, color: color.white)),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: Get.height * 0.02),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.borderColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3)// changes position of shadow
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          color: Color(0xff232d37)
                        ),
                        child: Column(
                          children: [
                            Center(child: Text('\$' + context.watch<TokenProvider>().tokens[this.selToken].price.toString(), style: TextStyle(color: color.white, fontSize: 30))),
                            AspectRatio(
                              aspectRatio: 1.60,
                              child: Padding(
                                padding: EdgeInsets.only(right: 3.0, left: 3.0, top: 24, bottom: 10),
                                child: this.isLoading ? Center(child: CircularProgressIndicator(color: gradientColors[0])) : LineChart(mainData()),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                  // width: Get.width * 0.7 ,
                                  decoration: BoxDecoration(
                                    color: Color(0xff232d37),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(btnNames.length , (index) => ElevatedButton(
                                      child:  Text(btnNames[index]),
                                      onPressed: () {
                                        setState(() {
                                          this.setId = index;
                                          this.getPriceData();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary:  (index == this.setId) ? (color.isDarkMode ? color.btnSecondaryColor : color.backColor) : Color(0xff232d37),
                                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        elevation: 0
                                      ),
                                    ))
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: Get.height * 0.03),
                        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          color: Color(0xff232d37)
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Market Cap', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child:  Text('\$' + double.parse(this.marketCap.toStringAsFixed(2)).toString(), textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(bottom: 20),
                                height: 1,
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                decoration: BoxDecoration(
                                  color: color.btnSecondaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(1))
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Volume', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child:  Text('\$' + double.parse(this.volume24.toStringAsFixed(2)).toString(), textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(bottom: 20),
                                height: 1,
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                decoration: BoxDecoration(
                                  color: color.btnSecondaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(1))
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Circulating Supply', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child:  Text(double.parse(this.circularSupply.toStringAsFixed(2)).toString() + context.watch<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(bottom: 20),
                                height: 1,
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                decoration: BoxDecoration(
                                  color: color.btnSecondaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(1))
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Supply', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(double.parse(this.totalSupply.toStringAsFixed(2)).toString() + context.watch<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(bottom: Get.height * 0.03),
                      //   padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(7),
                      //     ),
                      //     color: Color(0xff232d37)
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Padding(
                      //         padding: EdgeInsets.only(bottom: 20),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text('Market Cap', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                      //             Expanded(
                      //               child:  Text('\$' + double.parse(this.marketCap.toStringAsFixed(2)).toString(), textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       Container(
                      //           margin: EdgeInsets.only(bottom: 20),
                      //           height: 1,
                      //           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      //           decoration: BoxDecoration(
                      //               color: color.btnSecondaryColor,
                      //               borderRadius: BorderRadius.all(Radius.circular(1))
                      //           )
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.only(bottom: 20),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text('Volume', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                      //             Expanded(
                      //               child:  Text('\$' + double.parse(this.volume24.toStringAsFixed(2)).toString(), textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       Container(
                      //           margin: EdgeInsets.only(bottom: 20),
                      //           height: 1,
                      //           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      //           decoration: BoxDecoration(
                      //               color: color.btnSecondaryColor,
                      //               borderRadius: BorderRadius.all(Radius.circular(1))
                      //           )
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.only(bottom: 20),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text('Circulating Supply', style: TextStyle(color: color.foreColor, fontSize: 16, fontWeight: FontWeight.bold)),
                      //             Expanded(
                      //               child:  Text(double.parse(this.circularSupply.toStringAsFixed(2)).toString() + context.read<TokenProvider>().tokens[this.selToken].symbol.toUpperCase(), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: TextStyle(color: color.white, fontSize: 16)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 0)),
      minX: this.minX,
      maxX: this.maxX,
      minY: this.minY,
      maxY: this.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: this.spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          )
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (dot){
        }
      )
    );
  }
}
