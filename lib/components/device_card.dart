import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:streamio_mobile/models/device.dart';
import 'package:streamio_mobile/service/http_service.dart';
import 'package:streamio_mobile/utils/dio.dart';

import 'edit_device.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final void Function() onDelete;
  const DeviceCard({super.key, required this.device, required this.onDelete});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late Device _device;
  void changeQt(String op) async {
    final newAmount = op == "-" ? _device.amount - 1 : _device.amount + 1;
    final resp = await HttpService.dio.put(
      "/api/devices",
      data: {
        "id": _device.id,
        "name": _device.name,
        "price": _device.price,
        "amount": newAmount,
        "type": _device.type,
      },
    );
    if (resp.statusCode != 200) {
      return;
    }
    setState(() {
      _device.amount = newAmount;
    });
  }

  @override
  void initState() {
    super.initState();
    _device = widget.device;
  }

  void onUpdate(Device device) {
    setState(() {
      _device = device;
    });
  }

  void delete() async {
    await HttpService.dio.delete(
      "/api/devices",
      data: {"deviceId": widget.device.id},
    );
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),

        border: Border.all(width: 1, color: Colors.orange),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0, // Ratio 1:1
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Image.network(
                    "http://localhost:3000/" + _device.image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image,
                      size:
                          constraints.maxWidth *
                          0.6, // 60% de la largeur disponible
                      color: Colors.orange,
                    ),
                  );
                },
              ),
            ),
          ),
          Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(_device.name, style: TextStyle(fontSize: 18)),
                  ),
                  Text(
                    "${_device.price.toString()} €",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Text(
                      _device.type,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Text(
                    "Qt - ${_device.amount.toString()}",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    spacing: 4,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,

                        child: ElevatedButton(
                          onPressed: () {
                            changeQt("+");
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(left: 0, right: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Set the radius here
                            ),
                          ),
                          child: Text("+", style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,

                        child: ElevatedButton(
                          onPressed: () {
                            changeQt("-");
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(left: 0, right: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Set the radius here
                            ),
                          ),
                          child: Text("-", style: TextStyle(fontSize: 24)),
                        ),
                      ),
                    ],
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    spacing: 4,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,

                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => EditDevice(
                                device: _device,
                                onUpdate: (device) => onUpdate(device),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(left: 0, right: 0),
                            backgroundColor: Color(0xFF151515),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Set the radius here
                            ),
                          ),
                          child: Icon(Icons.edit_square),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,

                        child: ElevatedButton(
                          onPressed: delete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.only(left: 0, right: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Set the radius here
                            ),
                          ),
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
