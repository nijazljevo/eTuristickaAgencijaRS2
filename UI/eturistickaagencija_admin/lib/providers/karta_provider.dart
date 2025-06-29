
import 'package:eturistickaagencija_admin/providers/base_provider.dart';

import '../models/karta.dart';

class KartaProvider extends BaseProvider<Karta>{
  KartaProvider():super("Karte");

  @override
  Karta fromJson(data) {
    // TODO: implement fromJson
    return Karta.fromJson(data);
  }

}