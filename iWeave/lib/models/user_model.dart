class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? address;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.address,
    required this.createdAt,
  });

  UserModel copyWith({
    String? name, String? phone, String? avatarUrl, String? address,
  }) {
    return UserModel(
      id: id, email: email, createdAt: createdAt,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'email': email,
    'phone': phone, 'avatarUrl': avatarUrl,
    'address': address, 'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'], name: map['name'], email: map['email'],
    phone: map['phone'], avatarUrl: map['avatarUrl'],
    address: map['address'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
