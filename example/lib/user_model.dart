//Created on http://app.quicktype.io/

class UserModel {
  final String id;
  final DateTime? createdAt;
  final String name;
  final String avatar;

  UserModel(
      {required this.id,
      required this.createdAt,
      required this.name,
      required this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String,
      avatar: json['avatar'] as String,
    );
  }

  static List<UserModel> fromJsonList(List<dynamic> list) {
    return list
        .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is UserModel && other.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode;
}
