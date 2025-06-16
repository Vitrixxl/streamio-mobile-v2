import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  String? _imagePath; // chemin local de l’image

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      _nameController.text = widget.device!.name;
      _priceController.text = widget.device!.price.toString();
      _amountController.text = widget.device!.amount.toString();
      _currentType = widget.device!.type;
      // _imagePath = widget.device!.image; // si tu as ce champ dans Device
    }
  }

  bool checkInputs() {
    return !(_nameController.text == "" ||
        _priceController.text == "" ||
        _amountController.text == "" ||
        _currentType == "" ||
        _imagePath == null ||
        _imagePath == "");
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<String> uploadImage() async {
    if (_imagePath == null) return "";
    print("1");

    final file = File(_imagePath!);
    final fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await HttpService.dio.post(
      "/api/devices/upload",
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode != 200) {
      return "";
    }

    return response.data['filepath'];
  }

  void edit() async {
    if (!checkInputs()) {
      setState(() {
        _errorMessage = "Veuillez remplir tous les champs";
      });
      return;
    }

    final uploadedPath = await uploadImage();

    final Device updatedDevice = Device(
      id: widget.device != null ? widget.device!.id : "",
      name: _nameController.text,
      amount: int.parse(_amountController.text),
      type: _currentType!,
      price: int.parse(_priceController.text),
      createdAt: widget.device?.createdAt ?? DateTime.now(),
      image: uploadedPath,
    );

    if (widget.device != null) {
      final resp = await HttpService.dio.put(
        "/api/devices",
        data: updatedDevice.toObj(),
      );
    } else {
      print(updatedDevice.toObj());
      await HttpService.dio.post("/api/devices", data: updatedDevice.toObj());
    }

    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedDevice);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
            items: _types
                .map(
                  (String type) =>
                      DropdownMenuItem<String>(value: type, child: Text(type)),
                )
                .toList(),
            onChanged: (String? type) {
              setState(() {
                _currentType = type;
              });
            },
          ),

          // Choix d’image
          Row(
            spacing: 12,
            children: [
              if (_imagePath != null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // même que dans BoxDecoration
                    child: Image.file(
                      File(_imagePath!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.image, color: Colors.white, size: 30),
                  onPressed: pickImage,
                  padding: EdgeInsets.all(12), // espace autour de l'icône
                ),
              ),
            ],
          ),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
