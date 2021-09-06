import 'package:get/get.dart';

class ConnectController extends GetConnect{
  Future<Response> getXTokenInfo(String contract) async{
    return get('https://blockscout.com/xdai/mainnet/api?module=token&action=getToken&contractaddress=' + contract);
  }

  Future<Response> getTransactionList(String url) async{
    return get(url);
  }
}