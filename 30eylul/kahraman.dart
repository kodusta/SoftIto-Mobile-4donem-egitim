class Kahraman {
  final String ad;
  final String sinif;
  int seviye;
  double saldiriGucu;
  bool hayattaMi;

  Kahraman({
    required this.ad,
    required this.sinif,
    this.seviye = 1,
    this.saldiriGucu = 50.0,
    this.hayattaMi = true,
  });
  Kahraman.acemi({required this.ad})
    : sinif = "Çırak Savaşçı",
      seviye = 1,
      saldiriGucu = 25.0,
      hayattaMi = true;

  factory Kahraman.fromSaveJson(Map<String, dynamic> json) {
    return Kahraman(
      ad: json["ad"] as String,
      sinif: json["sinif"] as String,
      seviye: json["seviye"] as int,
      saldiriGucu: (json["hasar"] as num).toDouble(),
      hayattaMi: json["hayatta"] as bool,
    );
  }

  void kartiYazdir() {
    print(
      "[$sinif] $ad | Seviye: $seviye | Güç: $saldiriGucu | Durum: ${hayattaMi ? 'Canlı' : 'Ruh Halinde'}",
    );
  }
}

void main() {
  print("Karakter Üretimi");

  final sampiyon = Kahraman(
    ad: "Tuba Aydın",
    sinif: "Şövalye",
    seviye: 10,
    saldiriGucu: 120.0,
  );
  sampiyon.kartiYazdir();

  final caylak = Kahraman.acemi(ad: "Furkan Çalışkan");
  caylak.kartiYazdir();

  final Map<String, dynamic> jsondanGelenKarakter = {
    "ad": "Alaaddin",
    "sinif": "Ak Büyücü",
    "seviye": 50,
    "hasar": 350.5,
    "hayatta": true,
  };
  final efsane = Kahraman.fromSaveJson(jsondanGelenKarakter);
  efsane.kartiYazdir();
}
