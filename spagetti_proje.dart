// ============================================================
// PRODUCT
// ============================================================

abstract class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);
}

// Sadece kargolanabilen ürünler bu interface'i kullanır.
abstract class IKargoluUrun {
  double kargoUcretiHesapla();
}

class FizikselUrun extends Urun implements IKargoluUrun {
  FizikselUrun(
    String id,
    String ad,
    double fiyat,
    int stok,
  ) : super(id, ad, fiyat, stok, "FIZIKSEL");

  @override
  double kargoUcretiHesapla() {
    return 29.90;
  }
}

class DijitalUrun extends Urun {
  DijitalUrun(
    String id,
    String ad,
    double fiyat,
    int stok,
  ) : super(id, ad, fiyat, stok, "DIJITAL");
}

// ============================================================
// PAYMENT
// ============================================================

abstract class IOdemeYontemi {
  void odemeYap(double tutar);
}

class KrediKartiOdeme implements IOdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Kredi kartindan POS ile cekildi.");
  }
}

class HavaleOdeme implements IOdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Havale kontrol edildi.");
  }
}

class KapidaOdeme implements IOdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print(
      "$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).",
    );
  }
}

class CryptoOdeme implements IOdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL USDT transferi onaylandi.");
  }
}

// ============================================================
// DATABASE
// ============================================================

abstract class ISiparisRepository {
  void siparisKaydet(String orderId, double tutar);
}

class SqliteVeritabani implements ISiparisRepository {
  @override
  void siparisKaydet(String orderId, double tutar) {
    print(
      "DB calistirildi: INSERT INTO siparisler VALUES ('$orderId', $tutar)",
    );
  }
}

// ============================================================
// MAIL
// ============================================================

abstract class IMailServisi {
  void mailGonder(String email, String mesaj);
}

class SmtpMailServisi implements IMailServisi {
  @override
  void mailGonder(String email, String mesaj) {
    print("SMTP Mail gonderildi: $email");
  }
}

// ============================================================
// SMS
// ============================================================

abstract class ISmsServisi {
  void smsGonder(String telefon, String mesaj);
}

class NetgsmSmsServisi implements ISmsServisi {
  @override
  void smsGonder(String telefon, String mesaj) {
    print("SMS iletildi: $telefon");
  }
}

// ============================================================
// SHIPPING
// ============================================================

abstract class IKargoServisi {
  void kargoGonder(String orderId, String adres);
}

class MngKargoServisi implements IKargoServisi {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }
}

// ============================================================
// INVOICE
// ============================================================

abstract class IFaturaServisi {
  void faturaYazdir(String orderId);
}

class PdfFaturaServisi implements IFaturaServisi {
  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }
}

// ============================================================
// DISCOUNT
// ============================================================

abstract class IIndirim {
  double uygula(double toplam);
}

class Indirim10 implements IIndirim {
  @override
  double uygula(double toplam) {
    return toplam * 0.90;
  }
}

class Yaz20Indirimi implements IIndirim {
  @override
  double uygula(double toplam) {
    return toplam * 0.80;
  }
}

class Sepette50Indirimi implements IIndirim {
  @override
  double uygula(double toplam) {
    return toplam - 50;
  }
}

// ============================================================
// ORDER SERVICE
// ============================================================

class SiparisYoneticisi {
  final ISiparisRepository siparisRepository;
  final IOdemeYontemi odemeYontemi;
  final IMailServisi mailServisi;
  final ISmsServisi smsServisi;
  final IKargoServisi kargoServisi;
  final IFaturaServisi faturaServisi;

  SiparisYoneticisi({
    required this.siparisRepository,
    required this.odemeYontemi,
    required this.mailServisi,
    required this.smsServisi,
    required this.kargoServisi,
    required this.faturaServisi,
  });

  void siparisTamamla(
    String orderId,
    List<Urun> sepet,
    String musteriAdi,
    String email,
    String tel,
    String adres,
    String kuponKodu,
  ) {
    double toplam = _toplamHesapla(sepet);

    if (toplam < 0) {
      return;
    }

    toplam = _indirimUygula(toplam, kuponKodu);

    double sonTutar = _kdvEkle(toplam);

    odemeYontemi.odemeYap(sonTutar);

    siparisRepository.siparisKaydet(
      orderId,
      sonTutar,
    );

    faturaServisi.faturaYazdir(orderId);

    mailServisi.mailGonder(
      email,
      "Sayin $musteriAdi, siparisiniz alindi. "
          "Tutar: $sonTutar TL",
    );

    smsServisi.smsGonder(
      tel,
      "Siparisiniz onaylandi: $orderId",
    );

    kargoServisi.kargoGonder(
      orderId,
      adres,
    );
  }

double _toplamHesapla(List<Urun> sepet) {
  double toplam = 0;

  for (var urun in sepet) {
    if (urun.stok <= 0) {
      print("Hata: ${urun.ad} tukenmis!");
      return -1;
    }

    toplam += urun.fiyat;

    if (urun is IKargoluUrun) {
      final kargoluUrun = urun as IKargoluUrun;
      toplam += kargoluUrun.kargoUcretiHesapla();
    }

    urun.stok--;
  }

  return toplam;
}

  double _indirimUygula(
    double toplam,
    String kuponKodu,
  ) {
    switch (kuponKodu) {
      case "INDIRIM10":
        return Indirim10().uygula(toplam);

      case "YAZ20":
        return Yaz20Indirimi().uygula(toplam);

      case "SEPETTE50":
        return Sepette50Indirimi().uygula(toplam);

      default:
        return toplam;
    }
  }

  double _kdvEkle(double toplam) {
    const double kdvOrani = 0.20;
    return toplam + (toplam * kdvOrani);
  }
}

// ============================================================
// MAIN
// ============================================================

void main() {
  final siparisci = SiparisYoneticisi(
    siparisRepository: SqliteVeritabani(),
    odemeYontemi: KrediKartiOdeme(),
    mailServisi: SmtpMailServisi(),
    smsServisi: NetgsmSmsServisi(),
    kargoServisi: MngKargoServisi(),
    faturaServisi: PdfFaturaServisi(),
  );

  final urun1 = FizikselUrun(
    "1",
    "Kablosuz Mouse",
    450.0,
    5,
  );

  final urun2 = DijitalUrun(
    "2",
    "Flutter Kursu E-Kitap",
    150.0,
    100,
  );

  final sepet = <Urun>[
    urun1,
    urun2,
  ];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    "INDIRIM10",
  );
}
