void main() {
  final bool isProduction = true;
  final Set<String> temelServisler = {
    "api-gateway",
    "auth-service",
    "api-gateway", // Yinelenen eleman Set bunu otomatik siler!
  };

  final List<String> nihaiDagitimKumesi = [
    ...temelServisler,
    if (isProduction) "vault-secret-manager",
  ];

  print("Dağıtım Kümesi: $nihaiDagitimKumesi");
}