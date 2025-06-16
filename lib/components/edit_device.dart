import 'package:flutter/material.dart';
import 'package:streamio_mobile/models/device.dart';
import 'package:streamio_mobile/service/http_service.dart';

class EditDevice extends StatefulWidget {
  final void Function(Device updatedDevice)? onUpdate;
  final Device? device;
  const EditDevice({super.key, this.device, this.onUpdate});

  @override
  State<EditDevice> createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _currentType;
  String? _errorMessage;
  final _types = ["micro", "camera", "casque"];

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      _nameController.text = widget.device!.name;
      _priceController.text = widget.device!.price.toString();
      _amountController.text = widget.device!.amount.toString();
      _currentType = widget.device!.type;
    }
  }

  bool checkInputs() {
    return !(_nameController.text == "" ||
        _priceController.text == "" ||
        _amountController.text == "" ||
        _currentType == "");
  }

  void edit() async {
    if (!checkInputs()) {
      setState(() {
        _errorMessage = "Veuillez remplir tous les champs";
      });
      return;
    }
    final Device updatedDevice = Device(
      id: widget.device != null ? widget.device!.id : "",
      name: _nameController.text,
      amount: int.parse(_amountController.text),
      type: _currentType!,
      price: int.parse(_priceController.text),
      createdAt: widget.device?.createdAt ?? DateTime.now(),
    );

    if (widget.device != null) {
      final resp = await HttpService.dio.put(
        "/api/devices",
        data: updatedDevice.toObj(),
      );
      print(resp);
    } else {
      final resp = await HttpService.dio.post(
        "/api/devices",
        data: updatedDevice.toObj(),
      );
      print(resp);
    }

    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedDevice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ajouter un appareil',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Nom de l\'appareil',
              border: OutlineInputBorder(),
            ),
            controller: _nameController,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Prix',
              border: OutlineInputBorder(),
            ),

            keyboardType: TextInputType.number,
            controller: _priceController,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Quantité',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            controller: _amountController,
          ),
          DropdownButtonFormField(
            hint: Text("Type d'appareil"),

            value: _currentType,
            items: _types.map((String type) {
              return DropdownMenuItem<String>(value: type, child: Text(type));
            }).toList(),

            onChanged: (String? type) {
              setState(() {
                _currentType = type;
              });
            },
          ),

          if (_errorMessage != null)
            Center(
              child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  edit();
                  // Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: widget.device != null
                    ? Text("Modifier")
                    : Text("Ajouter"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
