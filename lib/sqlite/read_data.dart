import 'package:flutter/material.dart';
import 'package:ppbl/sqlite/connection.dart';
import 'package:ppbl/sqlite/saham.dart';

Future<List<Saham>> fetchSaham() async {
  final db = await openMyDatabase();

  final maps = await db.query('saham');

  return List.generate(maps.length, (i) {
    return Saham.fromMap(maps[i]);
  });
}

class ReadData extends StatefulWidget {
  const ReadData({super.key});

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  List<Saham> futureSaham = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Saham")),
      body: Center(
        child: FutureBuilder(
          future: fetchSaham(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              futureSaham = snapshot.data!;
            } else {
              return const Center(child: Text("Tidak ada data"));
            }

            return ListView.builder(
              itemCount: futureSaham.length,
              itemBuilder: (context, index) {
                final saham = futureSaham[index];
                return ListTile(
                  title: Text(saham.ticker),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Open : ${saham.open}"),
                      Text("High : ${saham.high}"),
                      Text("Last : ${saham.last}"),
                      Text(
                        "Change : ${saham.change}%",
                        style: TextStyle(
                          color: (saham.change) < 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
