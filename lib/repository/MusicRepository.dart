import 'package:http/http.dart';

const API_TOKEN = "9ecee196356afc0f58919504b3ed26b5";

class AudDAPIRepository {
  Future<dynamic> postToAudd(audioBinary){
    return post(Uri.parse("https://api.audd.io/"), body: {
          'api_token': API_TOKEN,
          'return': 'spotify,apple_music',
          'audio': audioBinary,
        });
  }
}