class Device {
  final String id;
  final String name;
  final int amount;
  final String type;
  final int price;
  final DateTime createdAt;

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
}
