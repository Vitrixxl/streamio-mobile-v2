import 'package:flutter/material.dart';
import 'package:streamio_mobile/api/get_devices.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Chargement
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}')); // Erreur
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune donnée trouvée')); // Vide
          } else {
            final items = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                children: items.map((item) {
                  return Container(
                    width: 200,
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
                                return Icon(
                                  Icons.image,
                                  size:
                                      constraints.maxWidth *
                                      0.6, // 60% de la largeur disponible
                                  color: Colors.orange,
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
                                  child: Text(
                                    item.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Text(
                                  "${item.price.toString()} €",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.type,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                                Text(
                                  "Qt - ${item.amount.toString()}",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeviceModal(context);
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

void _showAddDeviceModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ajouter un appareil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nom de l\'appareil',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Prix',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logique pour sauvegarder
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Ajouter'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
