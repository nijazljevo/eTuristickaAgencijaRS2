
import 'package:eturistickaagencija_admin/models/uloga.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';


class UlogaProvider extends BaseProvider<Uloga>{
  UlogaProvider():super("Uloge");

  @override
  Uloga fromJson(data) {
    // TODO: implement fromJson
    return Uloga.fromJson(data);
  }
}