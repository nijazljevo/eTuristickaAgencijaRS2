
import 'package:eturistickaagencija_admin/providers/base_provider.dart';


import '../models/hotel.dart';

class HotelProvider extends BaseProvider<Hotel>{
  HotelProvider():super("Hoteli");

  @override
  Hotel fromJson(data) {
    // TODO: implement fromJson
    return Hotel.fromJson(data);
  }
   Future<bool> checkDuplicate(String naziv) async {
    try {
      var result = await get(filter: {"naziv": naziv});
      return result.result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}