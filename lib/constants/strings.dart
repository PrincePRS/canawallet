class Strings{
  Strings._();
  static const String prod = 'prod';
  static const String dev = 'dev';
  static const String APP_NAME = 'King wallet';
  static const String suffixAmount = 'amount-';
  static const String suffixPrice = 'price-';
  static const String suffixChange = 'change-';
  static const String walletConnectServer = 'https://awesome-ramanujan-aec3f9.netlify.app/';
  static const String helpUrl = 'https://www.kingswap.io/about';
  // static const String walletConnectServer = 'http://192.168.1.14:3000/';
  static const List<int> chainIds = [1, 56, 100];
  static const List<String> RPC_URL = [
    'https://mainnet.infura.io/v3/b623e2a5b3354e57b82abc22acd8db0f',
    'https://bsc-dataseed.binance.org/',
    'https://rpc.xdaichain.com/'
  ];
  static const List<String> WS_URL = [
    'wss://mainnet.infura.io/ws/v3/b623e2a5b3354e57b82abc22acd8db0f',
    'wss://mainnet.infura.io/ws/v3/b623e2a5b3354e57b82abc22acd8db0f',
    'wss://rpc.xdaichain.com/wss'
  ];
  static RegExp Address_Reg = RegExp(r'^(0x)?[0-9a-f]{40}', caseSensitive: false);
  static const List<String> explorers = [
    'https://api.etherscan.io/api?apikey=UKJGZVFK7XNHM5ZCEEBWCQTG8CHVDFVM1U&',
    'https://api.bscscan.com/api?apikey=BUDZP4K9UWNQT1625NTTYH2TM32RCIEGHW&',
    'https://blockscout.com/xdai/mainnet/api?'
  ];
  static const txUrls = [
    'https://etherscan.io/tx/',
    'https://bscscan.com/tx/',
    'https://blockscout.com/xdai/mainnet/tx/'
  ];

  // fonts
  static const String fBold = 'Poppins Bold';
  static const String fSemiBold = 'Poppins SemiBold';
  static const String fMedium = 'Poppins Medium';
  static const String fRegular = 'Poppins Regular';
}