class Rezervacije {
  final int? id;
  int hotelId;
  int korisnikId;
  DateTime datumRezervacije;
  DateTime checkIn;
  DateTime checkOut;
  int brojOsoba;
  String tipSobe;
  bool otkazana;
  double cijena;

  Rezervacije({
    this.id,
    required this.hotelId,
    required this.korisnikId,
    required this.datumRezervacije,
    required this.checkIn,
    required this.checkOut,
    required this.brojOsoba,
    required this.tipSobe,
    required this.otkazana,
    required this.cijena,
  });
  factory Rezervacije.fromJson(Map<String, dynamic> json) {
    return Rezervacije(
      id: json['id'],
      korisnikId: json['korisnikId'],
      hotelId: json['hotelId'],
      otkazana: json['otkazana'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      brojOsoba: json['brojOsoba'],
      tipSobe: json['tipSobe'],
      cijena: json['cijena'],
      datumRezervacije: DateTime.parse(json['datumRezervacije']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'korisnikId': korisnikId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'brojOsoba': brojOsoba,
      'tipSobe': tipSobe,
      'datumRezervacije': datumRezervacije.toIso8601String(),
      'otkazana': otkazana,
      'cijena': cijena,
    };
  }
}
