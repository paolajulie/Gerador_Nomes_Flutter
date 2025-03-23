import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SavedNamesScreen extends StatefulWidget {
  const SavedNamesScreen({Key? key}) : super(key: key);

  @override
  _SavedNamesScreenState createState() => _SavedNamesScreenState();
}

class _SavedNamesScreenState extends State<SavedNamesScreen> {
  final databaseRef = FirebaseDatabase.instance.ref().child("saved_names");
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nomes Salvos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force refresh
              setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("Nenhum nome salvo"));
          }

          // Convertendo dados do Firebase
          Map<dynamic, dynamic> savedNames = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<MapEntry<dynamic, dynamic>> entries = savedNames.entries.toList();
          
          // Ordenando por timestamp, se disponível
          entries.sort((a, b) {
            int timestampA = a.value["timestamp"] ?? 0;
            int timestampB = b.value["timestamp"] ?? 0;
            return timestampB.compareTo(timestampA); // Ordem decrescente
          });

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              String name = entries[index].value["name"].toString();
              String key = entries[index].key.toString();
              
              return ListTile(
                title: Text(name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await databaseRef.child(key).remove();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nome removido com sucesso!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao remover: $e')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}