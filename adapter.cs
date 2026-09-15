using System.Text.Json;
using System.Xml.Linq;//xml verisini okumak

public class SoapService
{
    public string GetUserData()
    {
        return """
        <User>
            <Name>Betül</Name>
            <Surname>Çetin</Surname>
            <Transaction>Para Çekme</Transaction>
            <Balance>12500.50</Balance>
        </User>
        """;
    }
}
public interface IJsonService
{
    string GetJsonData();
}

public class XmlToJsonAdapter : IJsonService
{
    private readonly SoapService _soapService;

    public XmlToJsonAdapter(SoapService soapService)
    {
        _soapService = soapService;
    }

    public string GetJsonData()
    {
        string xmlData = _soapService.GetUserData();

        XDocument document = XDocument.Parse(xmlData);

        var user = document.Root;

        var userData = new
        {
            Name = user?.Element("Name")?.Value,
            Surname = user?.Element("Surname")?.Value,
            Transaction = user?.Element("Transaction")?.Value,
            Balance = decimal.Parse(
                user?.Element("Balance")?.Value ?? "0"
            )
        };

        return JsonSerializer.Serialize(userData);
    }
}
public class Program
{
    public static void Main()
    {
        SoapService soapService = new SoapService();
        IJsonService adapter = new XmlToJsonAdapter(soapService);
        string json = adapter.GetJsonData();
        Console.WriteLine(json);
    }
}