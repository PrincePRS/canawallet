import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:coingecko_dart/dataClasses/contracts/ContractToken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/chains.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/model/token_info.dart';
import 'package:cancoin_wallet/provider/params_controller.dart';
import 'package:cancoin_wallet/provider/token_provider.dart';
import 'package:cancoin_wallet/screens/qrreader_screen.dart';
import 'package:provider/provider.dart';

class TokenListScreen extends StatefulWidget {
  const TokenListScreen({Key? key}) : super(key: key);

  @override
  _TokenListScreenState createState() => _TokenListScreenState();
}

class _TokenListScreenState extends State<TokenListScreen> with TickerProviderStateMixin {

  TextEditingController _controller = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _symbolController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _decimalController = TextEditingController();
  String image = '';
  String tokenId = '';

  bool status = false;
  List<TokenInfo> tokens = [];
  int curNetwork = 0;

  void findContractToken(BuildContext context) async {
    try{
      if(context.read<TokenProvider>().network == 2){
        Response res = await connectController.getXTokenInfo(_addressController.text);
        print(res.statusCode);
        if(res.statusCode == 200){
          setState(() {
            var result = res.body;
            _nameController.text = result['result']['name'];
            _symbolController.text = result['result']['symbol'];
            this.image = '';
            // this.tokenId = contractToken.data.id;
            _decimalController.text = result['result']['decimals'];
            context.read<ParamsProvider>().setIsActive(true);
          });
        }
        return;
      }
      CoinGeckoResult<ContractToken>? contractToken = await coinGeckoApi.getContractTokenData(
        contract_address: _addressController.text,
        id: Chains.chains[context.read<TokenProvider>().network].name
      );

      setState(() {
        _nameController.text = contractToken.data.name;
        _symbolController.text = contractToken.data.symbol;
        this.image = contractToken.data.json['image']['small'];
        this.tokenId = contractToken.data.id;
        _decimalController.text = '18';
        context.read<ParamsProvider>().setIsActive(true);
      });
    }catch(ex){
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      initFields();
      setInitData();
    });
  }

  void setInitData() {
    curNetwork = context.read<TokenProvider>().curNetwork;
    // web3Controller.changeNetwork(0);
  }

  @override
  void dispose() {
    // web3Controller.changeNetwork(curNetwork);
    super.dispose();
  }

  initFields(){
    setState(() {
      this.tokens = context.read<TokenProvider>().allTokens;
      _addressController.text = '';
      _nameController.text = '';
      _symbolController.text = '';
      _decimalController.text = '';
      context.read<ParamsProvider>().setIsActive(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.borderColor,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          cursorColor: color.foreColor,
          keyboardType: TextInputType.text,
          style: TextStyle(color: color.white),
          textAlign: TextAlign.left,
          onChanged: (value){
            this.tokens = [];
            for(var i = 0; i < context.read<TokenProvider>().allTokens.length; i ++){
              setState(() {
                if(value == '' || context.read<TokenProvider>().allTokens[i].symbol.toLowerCase().contains(value.toLowerCase()))
                  this.tokens.add(context.read<TokenProvider>().allTokens[i]);
              });
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.only(bottom: 5, top: 5, right: 15),
            hintText: 'search_tokens'.tr,
            hintStyle: TextStyle(color : Color(0x55FFFFFF))
          ),
        ),
        backgroundColor: color.backColor,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Get.width * 0.05),
            child: IconButton(
              onPressed: (){
                Size sz = Get.size;
                this.initFields();
                this.setInitData();
                AnimationController _animController = BottomSheet.createAnimationController(this);
                _animController.duration = Duration(milliseconds: 800);
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
                  builder: (context) => Container(
                    decoration: BoxDecoration(
                      color: color.borderColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)
                      )
                    ),
                    height: sz.height * 0.95,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: sz.height * 0.02),
                          color: color.backColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                            children: [
                              IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back),
                                color: color.white,
                              ),
                              Text('add_custom_token'.tr, style: TextStyle(fontSize: 20, color: color.white)),
                              IconButton(   // -----------------------------------------------------------------------------------------------
                                onPressed: () async {
                                  String result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> QRCodeReaderPage()));
                                  // String result = await Get.toNamed(PageNames.qrreader);
                                  result = result.replaceAll('ethereum:', '');
                                  this.initFields();
                                  setState((){
                                    _addressController.text = result;
                                  });
                                  if(!Strings.Address_Reg.hasMatch(result)){
                                    return;
                                  }
                                  findContractToken(context);
                                },
                                icon: Icon(Icons.qr_code_scanner), color: color.white, iconSize: 25
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: sz.width * 0.06, vertical: sz.height * 0.05),
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
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('network'.tr, style: TextStyle(color: color.contrastTextColor, fontSize: 16)),
                                    TextButton(
                                      onPressed: (){
                                        Get.defaultDialog(
                                          backgroundColor: color.btnSecondaryColor,
                                          title: 'Select Network'.tr,
                                          titleStyle: TextStyle(color: color.foreColor),
                                          content: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: 8),
                                            child: Container(
                                              height: sz.height * 0.45,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: List.generate(Chains.chains.length, (idx){
                                                    return Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 7),
                                                      child: ElevatedButton(
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(9.0),
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                    child: CachedNetworkImage(
                                                                      fit: BoxFit.cover,
                                                                      width: 40,
                                                                      height: 40,
                                                                      imageUrl: Chains.chains[idx].logo,
                                                                      placeholder: (context, url) => CircularProgressIndicator(),
                                                                      errorWidget: (context, url, error) => Image.asset('assets/images/coin.png'),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 15),
                                                                Container(
                                                                  width: sz.width * 0.35,
                                                                  child: Text(Chains.chains[idx].symbol, style: TextStyle(color: color.white, fontSize: 16))
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        onPressed: () async{
                                                          context.read<TokenProvider>().setNetwork(idx);
                                                          // web3Controller.changeNetwork(idx);
                                                          Get.back();
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          onSurface: Colors.brown,
                                                          primary: color.backColor,
                                                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                ),
                                              ),
                                            )
                                          )
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width: sz.width * 0.5,
                                        child: Text(Chains.chains[context.watch<TokenProvider>().network].symbol + '  >', textAlign: TextAlign.end, style: TextStyle(color: color.foreColor, fontSize: 16), overflow: TextOverflow.ellipsis)
                                      )
                                    )
                                  ],
                                ),
                                TextFormField(
                                  controller: _addressController,
                                  cursorColor: color.foreColor,
                                  style: TextStyle(color: color.contrastTextColor),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) async{  // ----------------------------------------------------------------------------------------
                                    if(!Strings.Address_Reg.hasMatch(value)) {
                                      setState(() {
                                        context.read<ParamsProvider>().setIsActive(false);
                                        this._symbolController.text = '';
                                        this._nameController.text = '';
                                      });
                                      return;
                                    }
                                    findContractToken(context);
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.isDarkMode ? color.foreColor : color.backColor)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.contrastTextColor)
                                    ),
                                    contentPadding: EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 15),
                                    hintText: 'contract_address'.tr,
                                    hintStyle: TextStyle(color: color.isDarkMode ? Color(0x55FFFFFF) : Color(0xFFB0B0B0)),
                                    suffixIcon: OutlinedButton(  // ------------------------------------------------------------------------ change
                                      onPressed: (){
                                        this.initFields();
                                        FlutterClipboard.paste().then((txt) async{
                                          setState(() {
                                            this._addressController.text = txt;
                                          });
                                          if(!Strings.Address_Reg.hasMatch(txt)) return;
                                          findContractToken(context);
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.white,
                                        side: BorderSide(color: Colors.transparent, width: 0),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 0),
                                        child: Text('paste'.tr, style: TextStyle(color: color.foreColor, fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.03),
                                TextFormField(
                                  controller: _nameController,
                                  cursorColor: color.foreColor,
                                  style: TextStyle(color: color.contrastTextColor),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.isDarkMode ? color.foreColor : color.backColor)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.contrastTextColor)
                                    ),
                                    contentPadding: EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 20),
                                    hintText: 'name'.tr,
                                    hintStyle: TextStyle(color: color.isDarkMode ? Color(0x55FFFFFF) : Color(0xFFB0B0B0)),
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.03),
                                TextFormField(
                                  controller: _symbolController,
                                  cursorColor: color.foreColor,
                                  style: TextStyle(color: color.contrastTextColor),
                                  keyboardType: TextInputType.number,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.isDarkMode ? color.foreColor : color.backColor)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.contrastTextColor)
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.contrastTextColor)
                                    ),
                                    contentPadding: EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 20),
                                    hintText: 'symbol'.tr,
                                    hintStyle: TextStyle(color: color.isDarkMode ? Color(0x55FFFFFF) : Color(0xFFB0B0B0)),
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.03),
                                TextFormField(
                                  controller: _decimalController,
                                  cursorColor: color.foreColor,
                                  style: TextStyle(color: color.white),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.isDarkMode ? color.foreColor : color.backColor)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.contrastTextColor)
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: color.contrastTextColor)
                                    ),
                                    contentPadding: EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 20),
                                    hintText: 'decimals'.tr,
                                    hintStyle: TextStyle(color: color.isDarkMode ? Color(0x55FFFFFF) : Color(0xFFB0B0B0)),
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.03),
                                ElevatedButton(
                                  child: Text('add_token'.tr),
                                  onPressed: !context.watch<ParamsProvider>().isActive ? null : () async{
                                    if(_nameController.text == '' || _symbolController.text == '' || _addressController.text == '') {
                                      Get.snackbar('Error'.tr, "Failed to get token information",
                                        colorText: color.foreColor,
                                        backgroundColor: color.btnSecondaryColor,
                                        isDismissible: true
                                      );
                                    }
                                    TokenInfo t = TokenInfo.fromMap({
                                      'logo': this.image,
                                      'name': _nameController.text,
                                      'address': _addressController.text,
                                      'symbol': _symbolController.text,
                                      'tokenId': this.tokenId,
                                      'chainId': context.read<TokenProvider>().network,
                                      'isActive': 0
                                    });
                                    bool isNew = await sqliteController.insertTokenData(t);
                                    if(isNew) {
                                      context.read<TokenProvider>().addToken(t);
                                      if(context.read<TokenProvider>().curNetwork == context.read<TokenProvider>().network) this.tokens.add(t);
                                      setState(() {
                                        this.tokens = this.tokens;
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    onSurface: Colors.brown,
                                    primary: color.foreColor,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add_circle_outline), color: color.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(this.tokens.length, (index){
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                imageUrl: this.tokens[index].logo,
                                errorWidget: (context, url, error) => Image.asset('assets/images/coin.png'),
                                placeholder: (context, url) => CircularProgressIndicator()
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(this.tokens[index].name, style: TextStyle(color: color.contrastTextColor, fontSize: 16)),
                        ],
                      ),
                      Switch(
                        value: this.tokens[index].isActive,
                        onChanged: (value) {
                          for(var i = 0; i < context.read<TokenProvider>().allTokens.length; i ++){
                            if(context.read<TokenProvider>().allTokens[i].name == this.tokens[index].name)  context.read<TokenProvider>().toggleActive(i);
                          }
                          setState(() {
                            this.tokens[index].isActive = this.tokens[index].isActive;
                          });
                        },
                        activeTrackColor: color.isDarkMode ? color.white : color.backColor,
                        activeColor: color.foreColor,
                      )
                    ],
                  ),
                  onPressed: () async{},
                  style: ElevatedButton.styleFrom(
                    onSurface: Colors.brown,
                    primary: color.btnSecondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    elevation: 5.0,
                    shadowColor: color.black
                  ),
                ),
              );
            })
          ),
        ),
      ),
    );
  }
}