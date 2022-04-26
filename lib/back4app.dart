import 'package:parse_server_sdk/parse_server_sdk.dart';

class Back4App {
  static Future<void> initParse() async {
    const keyApplicationId = 'EH0JPm1vBfGPyuCH1IIouAyGHmEiz421KDFpJx1j';
    const keyClientKey = 'whH5qamO8GpiDgfGmTaj6fBzJA5HEfS5xbayLapK';
    const keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);
  }
}
