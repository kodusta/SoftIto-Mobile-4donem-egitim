// Zindan ve Eşya (crafting) sistemi

extension AltinFormatUzantisi on int {
  //sayıyı formatlı altın metnine çevir
  String get toAltinKese => "${this} Altın";
}

extension AgirlikFormatuzantisi on double {
  //Ağırlık Kg olarak göster
  String get toAgirlikKg => "${this.toStringAsFixed(1)} kg";
}

// eşyaların nadirlik dereceleri
enum EsyaNadirligi { yaygin, nadir, destansi, efsanevi }

//genel zindan hata sınıfları
class ZindanException implements Exception {
  final String hataKodu;
  final String mesaj;
  final DateTime zaman = DateTime.now();

  ZindanException(this.hataKodu, this.mesaj);

  @override
  String toString() => "[$hataKodu] $mesaj ($zaman)";
}

//çanta ağırlık aşıldığında hata kodu
class CandataYerYorException extends ZindanException {
  CandataYerYorException(double asim)
    : super(
        "ERR_BAG_FULL",
        "Çanta Kapasitesi $asim kg Aşıldı.Eşyayı Alamazsınız",
      );
}

//Yetersiz altın durumunda hata
class YetersizAltinException extends ZindanException {
  YetersizAltinException(int eksik)
    : super("ERR_NO_GOLD", "Bu işlem için $eksik altın daha gerekiyor");
}
//---------------
// Mixler
//---------------

//parçalanıp büyü tozuna dönüşebilen eşyalar
mixin ParcalanabilrYetisi {
  void tozaDonustur(String esyaAdi) {
    print("Demirci $esyaAdi parçalandı ve 5 adet 'Mavi büyü tozu' elde edildi");
  }
}

//rün basılarak extra güç kazandıran eşyalar
mixin RuneBasmaYetisi {
  void runKusa(String runeTuru) {
    print("Rüm Büyüsü : Eşyaya '$runeTuru' rünü mühürlendi.(+15 Büyü hasarı)");
  }
}

//----------------
//Eşya/item modeli
//----------------

class Esya with ParcalanabilrYetisi, RuneBasmaYetisi {
  final String id;
  final String ad;
  final double agirlik;
  final EsyaNadirligi nadirlik;
  final String? aciklama;
  bool efsunlumu;

  Esya({
    required this.id,
    required this.ad,
    required this.agirlik,
    required this.nadirlik,
    this.aciklama,
    this.efsunlumu = false,
  });
  Esya.kucukCanIskiri()
    : id = "POT-001",
      ad = "Küçük Şifa İksiri",
      agirlik = 0.5,
      nadirlik = EsyaNadirligi.yaygin,
      aciklama = "İçildiğinde anında 30 can yeniler",
      efsunlumu = false;

  // records
  ({String etiket, double carpan, int satisFiyati}) degerlemeYap() {
    final (etiket, carpan, bazFiyat) = switch (nadirlik) {
      EsyaNadirligi.yaygin => ("Yaygın", 1.0, 50),
      EsyaNadirligi.nadir => ("Nadir", 1.5, 200),
      EsyaNadirligi.destansi => ("Destansı", 2.5, 750),
      EsyaNadirligi.efsanevi when efsunlumu => ("Kadim Efsanevi", 5.0, 3000),
      EsyaNadirligi.efsanevi => ("Efsanevi", 4.0, 2000),
    };
    return (
      etiket: etiket,
      carpan: carpan,
      satisFiyati: (bazFiyat * carpan).toInt(),
    );
  }
}

//Oyuncunun Çantası
class OyuncuCantasi {
  final String sahipAdi;
  final double maxAgirlikKapasitesi;
  final List<Esya> _esyalar = [];
  int _altin = 500;

  OyuncuCantasi({required this.sahipAdi, this.maxAgirlikKapasitesi = 25.0});

  int get altin => _altin;

  // altın harcama metodu
  void altinHarca(int miktar) {
    if (miktar > _altin) {
      throw YetersizAltinException(miktar - _altin);
    }
    _altin -= miktar;
    print(
      "[Ticaret]: $miktar altın harcandı.Kalan Cüzdan: ${_altin.toAltinKese}",
    );
  }

  //çanta ağırlığı hesaplama
  double get mevcutAgirlik => _esyalar.fold(0.0, (acc, e) => acc + e.agirlik);

  //Çantaya Eşya Ekleme
  void esyaEkle(Esya yeniEsya) {
    if (mevcutAgirlik + yeniEsya.agirlik > maxAgirlikKapasitesi) {
      final double asim =
          (mevcutAgirlik + yeniEsya.agirlik) - maxAgirlikKapasitesi;
      throw CandataYerYorException(asim);
    }
    _esyalar.add(yeniEsya);
    print(
      "[Çanta]: '${yeniEsya.ad}' çantaya yerleştirildi (${yeniEsya.agirlik.toAgirlikKg})",
    );
  }

  // sadece değerli eşyaları filtrele
  List<Esya> get degerliEsyalar => _esyalar
      .where(
        (e) =>
            e.nadirlik == EsyaNadirligi.destansi ||
            e.nadirlik == EsyaNadirligi.efsanevi,
      )
      .toList();

  //Çanta Döküm Raporu

  void envanterRaporuBas() {
    print("""

==============================================
Kahraman Envanter Raporu
Sahip:$sahipAdi | Altın: ${_altin.toAltinKese} | Yük: ${mevcutAgirlik.toAgirlikKg}/${maxAgirlikKapasitesi.toAgirlikKg};
==============================================
""");

    for (var esya in _esyalar) {
      final deger = esya.degerlemeYap();
      final aciklamaMetni = esya.aciklama ?? "Özel Nitelik Belirtilmemiş";
      print(
        "${deger.etiket.padRight(20)} | ${esya.ad.padRight(24)} | ${esya.agirlik.toAgirlikKg.padLeft(8)} | Değer: ${deger.satisFiyati.toAltinKese.padLeft(12)}",
      );
      print(" Not: $aciklamaMetni");
    }
    print("Değerli Eşya Sayısı: ${degerliEsyalar.length} Adet");
    print("=======================================");
  }
}

void main() {
  print("Zindan & Envanter Motoru Başlatılıyor....");

  final bool vipUyelik = true;

  //çantamızı oluşturuyoruz

  final canta = OyuncuCantasi(
    sahipAdi: "Elf Okçusu Ayberk",
    maxAgirlikKapasitesi: 20.0,
  );
  final List<Esya> zindanGirisPaketi = [
    Esya.kucukCanIskiri(),
    Esya(
      id: "SWD-101",
      ad: "Gümüş Ejder Kılıcı",
      agirlik: 4.5,
      nadirlik: EsyaNadirligi.destansi,
      aciklama: "Karanlık yaratıklara karşı %25 ek hasar",
      efsunlumu: true,
    ),
    if (vipUyelik)
      Esya(
        id: "RNG-999",
        ad: "Zamanın Sonu yüzüğü",
        agirlik: 0.2,
        nadirlik: EsyaNadirligi.efsanevi,
        aciklama: "Bekleme Sürelerini %20 azaltır",
        efsunlumu: true,
      ),
  ];

  //eşyaları çantaya ekleme
  for (var esya in zindanGirisPaketi) {
    canta.esyaEkle(esya);
  }

  print("Zanaat ve büyü masası");
  final kilic = zindanGirisPaketi[1];
  kilic.runKusa("Kutsal Işık");
  kilic.tozaDonustur(kilic.ad);

  print("Ticaret ve altın harcama");
  try {
    canta.altinHarca(200);
    canta.altinHarca(800);
  } on YetersizAltinException catch (e) {
    print("Hata Yakalandı ${e.mesaj}");
  } catch (e) {
    print("Genel Hata $e");
  }

  //kapasite aşım testi
  print("Çanta Kapasitesi Aşımı");
  try {
    final devKaya = Esya(
      id: "BLD-777",
      ad: "Göktaşı Parçası",
      agirlik: 28.0,
      nadirlik: EsyaNadirligi.yaygin,
    );
    canta.esyaEkle(devKaya);
  } on CandataYerYorException catch (e) {
    print("Aşırı yük Engellendi -> ${e.mesaj}");
  }
  canta.envanterRaporuBas();
}
