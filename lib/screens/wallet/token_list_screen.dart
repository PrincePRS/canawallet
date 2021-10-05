import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancoin_wallet/component/common_button.dart';
import 'package:cancoin_wallet/component/common_textfield.dart';
import 'package:cancoin_wallet/component/setting_components.dart';
import 'package:cancoin_wallet/constants/page_names.dart';
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
import 'package:line_icons/line_icons.dart';
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.07),
        decoration: BoxDecoration(
          color: color.white,
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: Get.height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(LineIcons.arrowLeft, color: color.textColor, size: 30),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(
                      controller: _controller,
                      hint: 'search_tokens'.tr,
                      onChange: (value){
                        this.tokens = [];
                        for(var i = 0; i < context.read<TokenProvider>().allTokens.length; i ++){
                          setState(() {
                            if(value == '' || context.read<TokenProvider>().allTokens[i].symbol.toLowerCase().contains(value.toLowerCase()))
                              this.tokens.add(context.read<TokenProvider>().allTokens[i]);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: (){
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
                          padding: EdgeInsets.only(top: Get.height * 0.07, left: Get.width * 0.05, right: Get.width * 0.05),
                          decoration: BoxDecoration(
                            color: color.white,
                            image: DecorationImage(
                              image: AssetImage("assets/images/background.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: sz.height * 1,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only( bottom: Get.height * 0.05),
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
                                        Text('add_custom_token'.tr,
                                            style: TextStyle(color: color.foreColor, fontFamily: Strings.fMedium, fontSize: 18)
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        String result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> QRCodeReaderPage()));
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
                                      child: Image.asset('assets/images/scan.png'),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: sz.height * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SettingItemButton(
                                      leftWidget: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(9.0),
                                            child: Image.asset(
                                              'assets/images/wallet-icon.png',
                                              fit: BoxFit.cover,
                                              width: 30,
                                              height: 30
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('network'.tr, style: TextStyle(color: color.foreColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
                                              Text(Chains.chains[context.watch<TokenProvider>().network].symbol, style: TextStyle(color: color.btnPrimaryColor, fontSize: 14, fontFamily: Strings.fRegular))
                                            ]
                                          ),
                                        ],
                                      ),
                                      rightWidget: Icon(Icons.arrow_forward_ios_outlined, size: 26, color: color.isDarkMode ? color.foreColor : color.foreColor),
                                      onPressed: (){
                                        Get.defaultDialog(
                                          backgroundColor: color.btnSecondaryColor,
                                          title: '', // 'select_network'.tr,
                                          titleStyle: TextStyle(fontSize: 0),
                                          radius: 7,
                                          content: Padding(
                                            padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, bottom: Get.height * 0.03),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Text('select_network'.tr, style: TextStyle(color: color.foreColor, fontFamily: Strings.fSemiBold, fontSize: 18)),
                                                SizedBox(height: 10),
                                                Container(
                                                  height: sz.height * 0.4,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: List.generate(Chains.chains.length, (idx){
                                                        return ModalNetworkItem(
                                                          url: Chains.chains[idx].logo,
                                                          name: Chains.chains[idx].symbol,
                                                          selected: context.read<TokenProvider>().network == idx,
                                                          onPressed: () async{
                                                            context.read<TokenProvider>().setNetwork(idx);
                                                            Get.back();
                                                          },
                                                        );
                                                      })
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          )
                                        );
                                      }
                                    ),
                                    SizedBox(height: Get.height * 0.03),
                                    CustomTextField(
                                      controller: _addressController,
                                      hint: 'contract_address'.tr,
                                      keyType: 1,
                                      onChange: (value){
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
                                    ),
                                    SizedBox(height: Get.height * 0.03),
                                    CustomTextField(
                                      controller: _nameController,
                                      hint: 'name'.tr,
                                      keyType: 1,
                                      enabled: false,
                                    ),
                                    SizedBox(height: Get.height * 0.03),
                                    CustomTextField(
                                      controller: _symbolController,
                                      hint: 'symbol'.tr,
                                      keyType: 1,
                                      enabled: false,
                                    ),
                                    SizedBox(height: Get.height * 0.03),
                                    CustomTextField(
                                      controller: _decimalController,
                                      hint: 'decimals'.tr,
                                    ),
                                    SizedBox(height: Get.height * 0.03),
                                    PrimaryButton(
                                      title: 'add_token'.tr,
                                      isActive: context.watch<ParamsProvider>().isActive,
                                      onPressed: () async{
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
                                      }
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.add_box_outlined, color: color.textColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(this.tokens.length, (index){
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 7),
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
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
                                Expanded(child: Text(this.tokens[index].name, overflow: TextOverflow.ellipsis , style: TextStyle(color: color.foreColor, fontSize: 16, fontFamily: Strings.fSemiBold))),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              for(var i = 0; i < context.read<TokenProvider>().allTokens.length; i ++){
                                if(context.read<TokenProvider>().allTokens[i].name == this.tokens[index].name)  context.read<TokenProvider>().toggleActive(i);
                              }
                              setState(() {
                                this.tokens[index].isActive = this.tokens[index].isActive;
                              });
                            },
                            child: Image.asset(this.tokens[index].isActive ? 'assets/images/switch-on.png' : 'assets/images/switch-off.png'),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: color.white,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: color.borderColor, width: 2),
                      ),
                    );
                  })
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}