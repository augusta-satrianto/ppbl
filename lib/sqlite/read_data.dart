import 'package:flutter/material.dart';
import 'package:ppbl/sqlite/connection.dart';
import 'package:ppbl/sqlite/saham.dart';

import 'form_edit.dart';

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
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: futureSaham.length,
              itemBuilder: (context, index) {
                final saham = futureSaham[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    final db = await openMyDatabase();
                    await db.delete(
                      'saham',
                      where: 'tickerid = ?',
                      whereArgs: [saham.tickerid],
                    );

                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${saham.ticker} berhasil dihapus"),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormEdit(saham: saham),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
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
                              color:
                                  (saham.change) < 0
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
