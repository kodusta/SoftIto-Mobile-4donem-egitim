
class SoapBankService {
  String getBalanceXml() => "<bakiye>5000</bakiye>";
}


class BankXmlAdapter {
  final SoapBankService soapService;

  BankXmlAdapter(this.soapService);

  Map<String, dynamic> getBalanceJson() {
    String xml = soapService.getBalanceXml();

   
    String sayi = xml.replaceAll("<bakiye>", "").replaceAll("</bakiye>", "");

    return {"balance": int.parse(sayi)};
  }
}


void main() {
  var adapter = BankXmlAdapter(SoapBankService());
  print(adapter.getBalanceJson()); // {balance: 5000}
}