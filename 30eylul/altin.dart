class OyuncuKasasi {
  final String oyuncuAdi;
  int _altinMiktari = 0;
  OyuncuKasasi({required this.oyuncuAdi});
  int get altinMiktari => _altinMiktari;
  set altinEkle(int miktar) {
    if (miktar <= 0) {
      print("Geçersiz miktar! Sıfır veya negatif altın eklenemez.");
    } else {
      _altinMiktari += miktar;
      print(
        "$oyuncuAdi kasasına +$miktar altın eklendi. Toplam: $_altinMiktari",
      );
    }
  }
}

void main() {
  final kasa = OyuncuKasasi(oyuncuAdi: "Ahmet Eroğlu");
  kasa.altinEkle = 150;
  kasa.altinEkle = -50;
}
