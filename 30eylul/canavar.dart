abstract class Canavar {
  void kukre();
}

class KurtCanavari extends Canavar {
  @override
  void kukre() {
    print(" Avuuuu! Kurt uludu.");
  }
}

class EjderhaCanavari extends Canavar {
  @override
  void kukre() {
    print(" ROAAAR! Ejderha yeri göğü inletti.");
  }
}

void main() {
  final canavarlar = [KurtCanavari(), EjderhaCanavari()];
  for (var c in canavarlar) {
    c.kukre();
  }
}
