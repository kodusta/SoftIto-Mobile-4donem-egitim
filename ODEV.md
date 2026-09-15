##GÖREV-1 MOBİL AKIŞ ŞEMASI 
![KahveGo Mobil Akış Şeması](Kahve_Siparisi_mobil_akis.png)

##GÖREV2-REST API Uç Noktası (Endpoint) & JSON Tasarımı
1-1. Sipariş Oluşturma Endpoint'i
HTTP Metodu: POST

URL: /api/v1/siparisler

Header:
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
Request Body (JSON):
{
  "urunler": [
    {
      "urun_id": 101,
      "ad": "Latte",
      "boyut": "Grande",
      "adet": 2,
      "birim_fiyat": 65.00
    },
    {
      "urun_id": 204,
      "ad": "Americano",
      "boyut": "Venti",
      "adet": 1,
      "birim_fiyat": 55.00
    }
  ],
  "toplam_tutar": 185.00,
  "odeme_yontemi": "CUZDAN"
}
HTTP Durum Kodları:

Başarılı Sonuç: 201 Created

Kullanıcı Giriş Yapmamışsa (Token Geçersiz/Eksik): 401 Unauthorized

Yetersiz Bakiye Durumunda (Alternatif): 400 Bad Request veya 422 Unprocessable Entity
2-Cüzdan Bakiye Sorgulama Endpoint'i
HTTP Metodu: GET

URL: /api/v1/kullanici/bakiye
Header:
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Response Body (JSON):
{
  "kullanici_id": 4821,
  "bakiye": 185.50,
  "para_birimi": "TRY",
  "guncellenme_tarihi": "2026-09-15T17:02:00Z"
}
HTTP Durum Kodu:

Sunucuda Beklenmeyen Hata Oluşursa: 500 Internal Server Error
Mülakat Sorusu: POST isteği idempotent değildir her çağrıldığında yeni kayıt oluşturur. GET defalarca çağrılsada aynı sonucu döndürür.

##GÖREV-3 Clean Code & SOLID Prensip Teşhisi
1-SRP İHLALİ 
KahveSiparisYoneticisi sınıfı sepet hesaplama, indirim uygulama, kredi kartından ödeme alma, veritabanına kayıt yapma ve müşteriye SMS gönderme gibi birden fazla farklı sorumluluğu aynı anda üstlenmiştir. SRP ye göre bu sınıf sorumluluklarına göre daha küçük sınıflara ayrılmalıdır.
2-OCP İHLALİ 
indirimHesapla fonksiyonunda if - else  koduna Doktor eklendiğinde mevcut kod değişmesi gerekecek bu da sııfın değiştiği anlamına gelir . OCP de sınıfa yeni özellikler eklenebilir fakat mevcut kod değiştirilmemelidir.

