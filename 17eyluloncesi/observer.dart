// 1. Observer Arayüzü (Abone Sözleşmesi)
abstract class OrderObserver {
  void onOrderStatusChanged(String orderId, String newStatus);
}

// 2. Subject Sınıfı (Sipariş Takip Merkezi - Yayıncı)
class OrderTrackerSubject {
  final List<OrderObserver> _subscribers = [];

  void subscribe(OrderObserver observer) {
    _subscribers.add(observer);
    print(" Yeni bir dinleyici abone oldu: ${observer.runtimeType}");
  }

  void unsubscribe(OrderObserver observer) {
    _subscribers.remove(observer);
    print(" Dinleyici abonelikten çıktı: ${observer.runtimeType}");
  }

  // Tüm aboneleri tek hamlede haberdar et!
  void updateStatus(String orderId, String status) {
    print("\n [SİSTEM BİLDİRİMİ]: Sipariş ($orderId) durumu değişti -> $status");
    for (final observer in _subscribers) {
      observer.onOrderStatusChanged(orderId, status);
    }
  }
}

// 3. Somut Gözlemciler (Farklı Ekranlar / Servisler)
class CustomerMobileAppUi implements OrderObserver {
  @override
  void onOrderStatusChanged(String orderId, String newStatus) {
    print(" [Müşteri Mobil UI]: Ekranda yeşil bildirim rozeti yandı: '$newStatus'");
  }
}

class WarehouseLogisticsService implements OrderObserver {
  @override
  void onOrderStatusChanged(String orderId, String newStatus) {
    if (newStatus == "HAZIRLANIYOR") {
      print(" [Depo Robotu]: Paketleme bandı çalıştırıldı ($orderId).");
    }
  }
}

class SmsGatewayDispatcher implements OrderObserver {
  @override
  void onOrderStatusChanged(String orderId, String newStatus) {
    print(" [SMS Servisi]: Müşteriye SMS atıldı: Siparişiniz $newStatus.");
  }
}

void main() {
  final tracker = OrderTrackerSubject();
  final mobileUi = CustomerMobileAppUi();
  final warehouse = WarehouseLogisticsService();
  final sms = SmsGatewayDispatcher();

  tracker.subscribe(mobileUi);
  tracker.subscribe(warehouse);
  tracker.subscribe(sms);

  tracker.updateStatus("ORD-101", "HAZIRLANIYOR");
  tracker.updateStatus("ORD-101", "KARGODA");
}