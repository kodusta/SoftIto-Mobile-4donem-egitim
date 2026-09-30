// dart record ve api durum kontrolü
({String nodeAdi, int statusCode, double latencyMs, bool baglantiBasarili})
sunucuPingAt({required String hedefIp}) {
  final double gecikme = 24.8;
  final int kod = 200;

  return (
    nodeAdi: "edge-router-ist-$hedefIp",
    statusCode: kod,
    latencyMs: gecikme,
    baglantiBasarili: kod == 200,
  );
}

void main() {
  print("Dart Record Kayıtları");
  final probeSonucu = sunucuPingAt(hedefIp: "10.0.1.50");
  print("İp adi           : ${probeSonucu.nodeAdi}");
  print("Http Kodu        : ${probeSonucu.statusCode}");
  print("Geçikme Süresi   : ${probeSonucu.latencyMs} ms");
  print(
    "Ağ Durumu        : ${probeSonucu.baglantiBasarili ? "Stabil" : "Kopuk"}",
  );

  //Tek hamlede Değişkenlere Parçalama
  final (:nodeAdi, :statusCode, :latencyMs, :baglantiBasarili) = probeSonucu;
  print("Değişkenler -> $nodeAdi [Kod: $statusCode,Gecikme: ${latencyMs}ms]");

  final (String podId, int cpuCores, double ramGb) = ("k8s-pod-77x", 8, 32.0);
  print("Pod özeti: $podId | Çekirdek : $cpuCores | Ram : ${ramGb}GB");
}
