import 'package:flutter/material.dart';
import 'package:streamio_mobile/api/get_devices.dart';
import 'package:streamio_mobile/components/device_card.dart';
import 'package:streamio_mobile/components/edit_device.dart';

import '../models/device.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Device> _devices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await fetchDevices();
      setState(() {
        _devices = data;
        _isLoading = false;
      });
    } catch (e, stacktrace) {
      print("Erreur lors du fetch: $e");
      print(stacktrace);
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleUpdate() {
    _fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Erreur : $_error'))
          : _devices.isEmpty
          ? Center(child: Text('Aucune donnée trouvée'))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                children: _devices
                    .map(
                      (item) =>
                          DeviceCard(device: item, onDelete: _handleUpdate),
                    )
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => EditDevice(
              onUpdate: (Device updatedDevice) {
                _handleUpdate(); // Rafraîchir
              },
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
