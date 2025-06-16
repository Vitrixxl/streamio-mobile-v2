class Device {
  late String id;
  late String name;
  late int amount;
  late String type;
  late int price;
  late DateTime createdAt;

  Device({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.price,
    required this.createdAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json["amount"] as int,
      type: json["type"] as String,
      price: json["price"] as int,
      createdAt: DateTime.parse(json["createdAt"] as String),
    );
  }
  Map<String, dynamic> toObj() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
