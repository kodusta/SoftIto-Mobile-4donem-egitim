SOLİD HATALARI
1-Single Responsibility Principle 

 class SiparisYoneticisi implements ISiparisIslemleri {

 }

 abstract class ISiparisIslemleri {
  void siparisKaydet(String orderId, double tutar);
  void odemeYap(String tip, double tutar);
  void kargoGonder(String orderId, String adres);
  void mailGonder(String email, String mesaj);
  void smsGonder(String tel, String mesaj);
  void faturaYazdir(String orderId);
}
burada SiparisYoneticisi sınıfı çok fazla sorumluluğu aynı anda üstleniyor. Bu durum SRP ihlalidir.
Çünkü örneğin mail gönderme sisteminde bir değişiklik olduğunda SiparisYoneticisi sınıfının değiştirilmesi gerekir
ÇÖZÜM ? = SORUMLULUKLAR FARKLI SINIFLARA AYRILABİLİR . 
SiparisServisi, OdemeServisi, KargoServisi

2-Open Closed Principle -OCP
Halihazırda olan özellikleri korumalı ve değişikliğe izin vermelidir. Davranışını değiştiriyor ve yeni özellikler kazanabiliyor olmalı.
@override
  void odemeYap(String tip, double tutar) {
    if (tip == "KREDI_KARTI") {
      print("$tutar TL Kredi kartindan POS ile cekildi.");
    } else if (tip == "HAVALE") {
      print("$tutar TL Havale kontrol edildi.");
    } else if (tip == "KAPIDA_ODEME") {
      print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
    } else if (tip == "CRYPTO") {
      print("$tutar TL USDT transferi onaylandi.");
    } else {
      print("Gecersiz odeme yontemi");
    }
  }

  -Yeni bir ödeme yöntemi eklemek istersek, else if eklememiz gerekiyor yani mevcut sınıfın kodunu değiştiriyor oluruz. Bu OCP 'ye aykırıdır.
  ÇÖZÜM ? = Ödeme yöntemlerini ayrı sınıflara ayırabiliriz. Yeni bir ödeme yöntemi eklediğimizde SiparisYöneticisi sınıfı içerisindeki kodu değiştirmek yerine yeni bir sınıf ekleyebiliriz.

  3-Liskov Substition Principle -LSP
  nesne yönelimli programlamada alt sınıfların, programın çalışmasını bozmadan üst sınıfların yerine geçebilmesi gerektiğini savunan bir tasarım kuralıdır.
   class Urun {
  ...
  
  double kargoUcretiHesapla() {
    return 29.90;
  }
}
class DijitalUrun extends Urun {
  ...
  
  @override
  double kargoUcretiHesapla() {
    throw Exception("Dijital urunlerde kargo hesaplanamaz!");
  }
} 
 
 DijitalUrun sınıfı Urun sınıfından kalıtım almıştır , fakat Urun sınıfının kargo ücreti hesaplanabiliyorken , DijitalUrun kargo ücreti hesaplanmıyor ve exception fırlatıyor.
 ÇÖZÜM? = Kargo davranışını bütün ürünlerin ortak özelliği olmaktan çıkarmalıyız.
 abstract class IKargoluUrun {
  double kargoUcretiHesapla();
}
class FizikselUrun extends Urun implements IKargoluUrun {
  ...
}
class DijitalUrun extends Urun {
  ...
}

4-Interface Segregation Principle -ISP
Bir sınıf, ihtiyaç duymadığı metotları implement etmeye zorlanmamalıdır. 
abstract class ISiparisIslemleri {
  void siparisKaydet(...);
  void odemeYap(...);
  void kargoGonder(...);
  void mailGonder(...);
  void smsGonder(...);
  void faturaYazdir(...);
}
BURADA BİRBİRİNDEN FARKLI SORUMLULUKLAR BİR ARADA.
ÇÖZÜM?= Büyük interface'i daha küçük interface'lere ayırabiliriz
abstract class ISiparisRepository {
  void siparisKaydet(...);
}

abstract class IOdemeServisi {
  void odemeYap(...);
}

abstract class IKargoServisi {
  void kargoGonder(...);
}

abstract class IMailServisi {
  void mailGonder(...);
}

abstract class ISmsServisi {
  void smsGonder(...);
}

abstract class IFaturaServisi {
  void faturaYazdir(...);
}

5-Dependency Inversion Principle -DIP
Üst seviye modüller, alt seviye modüllere doğrudan bağımlı olmamalıdır. Her ikisi de abstraction'a bağlı olmalıdır.
class SiparisYoneticisi implements ISiparisIslemleri {
  SqliteVeritabani db = SqliteVeritabani();
  SmtpMailServisi mailci = SmtpMailServisi();
  NetgsmSmsServisi smsci = NetgsmSmsServisi();
} Burada SiparisYoneticisi doğrudan
SqliteVeritabani
SmtpMailServisi
NetgsmSmsServisi sınıflarına bağımlı.
ÇÖZÜM ?= SOMUT SINIFLAR YERİNE ABSTRACTİON KULLANABİLİRİZ.

abstract class IVeritabani {
  void kaydet(String sql);
}

abstract class IMailServisi {
  void mailAt(String to, String body);
}

abstract class ISmsServisi {
  void smsYolla(String gsm, String text);
}
Bağımlılıkları constuructor üzerinden verebiliriz
class SiparisYoneticisi {
  final IVeritabani db;
  final IMailServisi mailci;
  final ISmsServisi smsci;

  SiparisYoneticisi(
    this.db,
    this.mailci,
    this.smsci,
  );
}