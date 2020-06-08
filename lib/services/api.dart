import 'package:yourpage/shared/constants.dart';
import 'package:http/http.dart' as http;

class Api {
  Future toggleFollow(authUserId, otherUserId, action) async {
    var url = '$api/api/toggleFollow/$authUserId/$otherUserId/$action';
    print(url);
    return await http.post(url);
  }
}
