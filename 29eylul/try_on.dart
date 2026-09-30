class Cloud implements Exception {
  final String hataKodu;
  final String mesaj;
  final DateTime zaman = DateTime.now();

  Cloud(this.hataKodu, this.mesaj);

  @override
  String toString() => "[$hataKodu] $mesaj ($zaman)";
}

class CpuOverload extends Cloud {
  final double mevcutCpu;
  final double limit;

  CpuOverload({required this.mevcutCpu, required this.limit})
    : super(
        "Err_cpu_overload",
        "Cpu kullanımı eşik limitini ($limit) aştı: $mevcutCpu%",
      );
}

class NodeUnavaiable extends Cloud {
  final String nodeId;
  NodeUnavaiable(this.nodeId)
    : super("Err_node_ofline", "Yanıt vermiyor: $nodeId");
}

void podKaynagiTahsisEt(
  String podAdi,
  double talepEdilenCpu,
  double sistemKalanCpu,
) {
  if (talepEdilenCpu <= 0) {
    throw Cloud(
      "Err_invalid_param",
      "Talep Edilen cpu pozitif bir değer olmalıdır.",
    );
  }
  if (talepEdilenCpu > sistemKalanCpu) {
    throw CpuOverload(
      mevcutCpu: 100 - sistemKalanCpu + talepEdilenCpu,
      limit: 100.0,
    );
  }

  print(
    "Pod [$podAdi] başarıyla tahsis edildi:Kalan boş cpu: ${sistemKalanCpu - talepEdilenCpu}%",
  );
}

void main() {
  print("Yönetim Paneli");
  // başarılı tahsis
  try {
    podKaynagiTahsisEt("ingress-controller", 15.0, 40.0);
  } catch (e) {
    print("Hata: $e");
  }

  // Cpu Aşım Hatası Yakalama
  try {
    podKaynagiTahsisEt("ai-training-pd", 10.0, 20.0);
  } on CpuOverload catch (e) {
    print("Cpu hatası yakalandı");
    print("Hata kodu: ${e.hataKodu}");
    print("Mesaj: ${e.mesaj}");
    print("Aksiyon: Otomatik Aws Açma isteği Gönderildi");
  } on Cloud catch (e) {
    print("Bulut hatası: ${e.mesaj}");
  } catch (e) {
    print("Bilinmedik Sistem Hatasi $e");
  } finally {
    print("Pod tahsis günlüğü kapatıldı.");
  }
}
