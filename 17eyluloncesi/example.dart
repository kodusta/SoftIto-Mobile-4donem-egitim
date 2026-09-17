// KÖTÜ KOD
void p(List u){
    for (var i =0; i < u.length; i++){
        if(u[i].a >18 && u[i].s=="A"){
            print('User: ' + u[i].n + " can vote");
        }
    }
}


//Clean Kod
class Customer{
    final String name;
    final int age;
    final bool isActive;
    final double basketTotal;

    Customer({required this.name,required this.age,required this.isActive,required this.basketTotal});

    bool get canVote => age >= 18;
    double get discount => basketTotal * 0.15;
}

void processCustomers(List<Customer> customers){
    for (final customer in customers){
        if(customer.canVote && customer.isActive){
            print('USer vb.')
        }
    }
}


// SRP İHLALI (god class hem veri turuyor hem db yazıyor hem epos gonderıyor hem log oluşturuyor)

class UserManager{
    void registerUser(String email,String password){
        //1.Validasyon yap
        //2.SQL/Firebase kaydet
        //3.SMTO üzerinden hoş geldin maili at
        //4.Hata olursa log yaz
    }
}

// SRP UYUMLU KODLAR
class UserValidator{bool isValid(String email,String password)=>true;}
class UserReposity{ void saveToDatebase(User user){/db işlemleri/}}
class EmailService{ void sendWelcomeEmail(String email){/Mail işlemleri/}}
class LoggerService{ void log(String message{ /log işlemleri/})}

//Open / Close Principle (Gelişmeye Açık / Değişime Kapalı)

// Soyut Arayüz
abstract class PaymentMethod{
    void pay(double amount);
}


class CreditCardPayment implements PaymentMethod{
    @override void pay(double amount)=> print('$amount TL KREDİ KARTI İLE ÖDEME ALINDI');
}

class ApplePayPayment implements PaymentMethod{
    @override void pay(double amount)=>print('$amount TL APPLE PAY İLE ÖDENDİ');
}


class Rectangle{
    double width = 0;
    double height = 0;

    void setWidth(double w)=>width=w;
    void setHeight(double h)=>height=h;
    double get area =>width * height;
}
// LİSKIV İHLAHLI
class Square extends Rectangle{
    @override void setWidth(double w){width=w; height=w}// kare olduğu için boyu eşitlendi
    @override void setHeight(double h){width=h; height=h}// kare olduğu için boyu eşitlendi

}

// test fonksiyonu
void testRectangle(Rectangle r){
    r.setWidth(5);
    r.setHeight(4);
    //üst sınıf kuralına göre alan 5*4=20 olmalıdır
    // parametre olarak square gönderilirse 4*4=16
    //beklenen davranış bozuldu! LISKOV İHLALI
    assert(r.area==20);
}


// ŞİŞKİN ARAYÜZ
abstract class SmartDevice{
    void printDocument();
    void scanDocument();
    void sendFax();
}

//Normal bir ev yazıcısı (fax öekemez)
class BasicPrintir implements SmartDevice{
    @override void printDocument()=>print('Yazdırılıyor');
    @override void scanDocument()=>print('Taranıyor');
    @override void sendFax()=>throw UnimlementedError('fax özelliğim yok');//ISP İHLALI
}

// ISP UYUMLU 
abstract class Printer{ void printDocument();}
abstract class Scanner{void scanDocument();}
abstract class FaxMachine(void sendFax();)

class BasicPrintirClean implements Printer,Scanner{
     @override void printDocument()=>print('Yazdırılıyor');
    @override void scanDocument()=>print('Taranıyor');
}



abstract class AuthRemote{
    Future<String> login (String email,String password);
}

class FirebaseAuthService implements AuthRemote{
    @override Future<String> login(String email,String password) async=>"MOCKTOKEN_SUCCESS";
}

class LoginViewModel{
    final AuthRemote authSource;
    LoginViewModel({required this.authSource});

    Future<void> handleLogin(String email,String pass) async{
        final token=await authSource.login(email,pass);
        print('giriş başarılı: $token');
    }
}