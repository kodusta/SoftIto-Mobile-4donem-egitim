class CanSistemi {
  final String karakterAdi;
  double _canPuani =
      100.0; // başındaki alt çizgi bu değişkeni GİZLİ olarak kodlar

  CanSistemi({required this.karakterAdi});

  //getter ile can puanı güvenli dışarıya okutma
  double get canPuani {
    return _canPuani;
  }

  //setter ile can değeri değişirken oyun kurallarını denetleyelim
  set canPuani(double yeniCan) {
    if (yeniCan <= 0.0) {
      _canPuani = 0.0;
      print("$karakterAdi canı tükendi ve yere yığıldı");
    } else if (yeniCan > 100.0) {
      _canPuani = 100.0;
      print("Can tamamen dolu(Maksimum 100 HP)");
    } else {
      _canPuani = yeniCan;
    }
  }

  bool get hayattaMi {
    return _canPuani > 0.0;
  }
}

void main() {
  print("Can barı Güvenlik Sistemi");

  final savasciCani = CanSistemi(karakterAdi: "Meltem Demir");
  print("Başlangıç Canı         : HP ${savasciCani.canPuani}");
  print("35 Hasar Alındı");
  savasciCani.canPuani = 65.0;
  print("Kalan Can              : HP ${savasciCani.canPuani}");
  print("200 can veren iksir içildi");
  savasciCani.canPuani = 200.0;
  print("Sabitlenen Can         : HP ${savasciCani.canPuani}");
  print("Ölümcül Darbe Aldı");
  savasciCani.canPuani = -50.0;
  print("Nihani Can             : HP ${savasciCani.canPuani}");
  print(
    "Savaşçı Hayatta mı?    : ${savasciCani.hayattaMi ? 'Evet' : 'Hayır (Öldü)'}",
  );
}
