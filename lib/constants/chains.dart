import 'package:cancoin_wallet/model/chain_info.dart';

class Chains{
  Chains._();
  static  List<ChainInfo> chains = [
    ChainInfo.fromMap({'id': 0, 'name': 'ethereum', 'symbol': 'Ethereum', 'logo': 'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png', 'chainId': 1 }),
    ChainInfo.fromMap({'id': 1, 'name': 'binance-smart-chain', 'symbol': 'Binance Smart Chain', 'logo': 'https://assets.coingecko.com/coins/images/825/small/binance-coin-logo.png?1547034615', 'chainId': 56 }),
    // ChainInfo.fromMap({'id': 2, 'name': 'tron', 'symbol': 'TRON', 'logo': 'https://assets.coingecko.com/coins/images/1094/small/tron-logo.png?1547035066', 'chainId': 56 }),
    ChainInfo.fromMap({'id': 2, 'name': 'xdai', 'symbol': 'xDAI', 'logo': 'https://s2.coinmarketcap.com/static/img/coins/64x64/5601.png', 'chainId':100})
  ];
}