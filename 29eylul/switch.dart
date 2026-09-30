enum OlaySeviyesi { info, warning, error, critical }

String alarmKanaliniBelirle(OlaySeviyesi seviye, int tekarSayisi) {
  return switch (seviye) {
    OlaySeviyesi.info => "dev-logs",
    OlaySeviyesi.warning => "dev-warning",
    OlaySeviyesi.error when tekarSayisi >= 5 =>
      "Sms veya Email (mükerrer hata)",
    OlaySeviyesi.error => "Email:dev@site.com",
    OlaySeviyesi.critical => "ACİL DURUM: Kriz odası otomatik node kapanışı",
  };
}

String httpKoduYorumlar(int kod) {
  return switch (kod) {
    >= 200 && < 300 => "2xx Başarılı İstek",
    >= 400 && < 500 => "4xx İstenci Hatası (client error)",
    >= 500 && < 600 => "5xx Sunucu Hatası (internal server error)",
    _               => "Tanımsız Hata kodu",
  };
}

void main(){
  print("Switch Exporessions");
  print("Warning Kanalı              :${alarmKanaliniBelirle(OlaySeviyesi.warning, 1)}");
  print("Tekil Error Kanalı              :${alarmKanaliniBelirle(OlaySeviyesi.error, 2)}");
  print("5 kez Tekrarlanan Error Kanalı              :${alarmKanaliniBelirle(OlaySeviyesi.error, 5)}");
  print("Kritik  Kanalı              :${alarmKanaliniBelirle(OlaySeviyesi.critical, 1)}");

  print("HTTP 204 :   ${httpKoduYorumlar(204)}");
  print("HTTP 404 :   ${httpKoduYorumlar(404)}");
  print("HTTP 502 :   ${httpKoduYorumlar(502)}");


}
