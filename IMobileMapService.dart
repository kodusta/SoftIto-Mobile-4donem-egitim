// 1. Bizim Kendi Mobil Uygulamamızın İstediği Standart Sözleşme:
abstract class IMobileMapService {
  void renderLocation(double latitude, double longitude);
}

// 2. Eski / Harici 3. Parti Kütüphane (Örn: Legacy Google Maps SDK):
// Bu kütüphane bizim metodumuzu tanımaz, kendine has metotları vardır:
class ThirdPartyGoogleMapsSdk {
  void showPointOnMap({required double lat, required double lng, String? pinTitle}) {
    print(" Google Maps SDK: [$lat, $lng] koordinatına pin bırakıldı.");
  }
}

// 3. Adapter Sınıfı: İki uyumsuz yapıyı buluşturan sihirli köprü!
class GoogleMapsAdapter implements IMobileMapService {
  final ThirdPartyGoogleMapsSdk _googleSdk;

  GoogleMapsAdapter(this._googleSdk);

  @override
  void renderLocation(double latitude, double longitude) {
    // Kendi standardımızı harici SDK'nın istediği biçime dönüştürüyoruz:
    _googleSdk.showPointOnMap(lat: latitude, lng: longitude, pinTitle: "Mevcut Konum");
  }
}

// Yarın Google Maps pahalı geldi, Mapbox'a geçeceğiz:
class ThirdPartyMapboxSdk {
  void drawCoordinate(String coordinateString) {
    print(" Mapbox SDK: '$coordinateString' koordinatı çizildi.");
  }
}

class MapboxAdapter implements IMobileMapService {
  final ThirdPartyMapboxSdk _mapboxSdk;
  MapboxAdapter(this._mapboxSdk);

  @override
  void renderLocation(double latitude, double longitude) {
    _mapboxSdk.drawCoordinate("$latitude,$longitude");
  }
}