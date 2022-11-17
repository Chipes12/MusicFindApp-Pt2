import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var API_TOKEN = dotenv.env["API_TOKEN"];

class AudDAPIRepository {
  Future<dynamic> postToAudd(audioBinary){
    return post(Uri.parse("https://api.audd.io/"), body: {
          'api_token': API_TOKEN,
          'return': 'spotify,apple_music',
          'audio': audioBinary,
        });
  }
}