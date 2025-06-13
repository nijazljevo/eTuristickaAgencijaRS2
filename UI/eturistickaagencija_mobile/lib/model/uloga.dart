class Uloga {
 final int? id;
 final String? naziv;

  Uloga({
    this.id,
    this.naziv,
  });

  factory Uloga.fromJson(Map<String, dynamic> json) {
    return Uloga(
      id: json['id'],
      naziv: json['naziv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'naziv': naziv,
    };
  }
}
