class UserState {
  final String id;
  final String name;
  final int cartItemCount;
  final bool isPremium;

  const UserState({
    required this.id,
    required this.name,
    required this.cartItemCount,
    required this.isPremium,
  });

  // copyWith: Sadece değişen alanı güncelle, kalanları eskisi gibi kopyala!
  UserState copyWith({
    String? name,
    int? cartItemCount,
    bool? isPremium,
  }) {
    return UserState(
      id: this.id, // ID asla değişmez
      name: name ?? this.name,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

void main() {
  
  final originalUser = UserState(id: "USR-1", name: "Ahmet", cartItemCount: 1, isPremium: false);
  // Kullanıcı sepete ürün eklediğinde:
  final updatedState = originalUser.copyWith(cartItemCount: 1);
  
  print("Eski Durum Sepet: ${originalUser.cartItemCount}"); // 0
  print("Yeni Durum Sepet: ${updatedState.cartItemCount}"); // 1 (İmmutable State güvenliği!)
}