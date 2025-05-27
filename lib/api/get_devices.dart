import 'package:streamio_mobile/models/device.dart';
import 'package:streamio_mobile/utils/dio.dart';

Future<List<Device>> fetchDevices() async {
  final response = await dio.get('http://localhost:3000/api/devices');

  if (response.statusCode == 200) {
    final List<dynamic> devicesJson = response.data['data'];
    return devicesJson.map((json) => Device.fromJson(json)).toList();
  } else {
    throw Exception('Erreur lors du chargement des produits');
  }
}
