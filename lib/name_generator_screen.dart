import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:faker/faker.dart';
import 'saved_names_screen.dart';

class NameGeneratorScreen extends StatefulWidget {
  const NameGeneratorScreen({Key? key}) : super(key: key);

  @override
  _NameGeneratorScreenState createState() => _NameGeneratorScreenState();
}

class _NameGeneratorScreenState extends State<NameGeneratorScreen> {
  final DatabaseReference _namesRef =
      FirebaseDatabase.instance.ref().child('saved_names');
  final Faker _faker = Faker();
  String _currentName = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateName();
  }

  void _generateName() {
    String firstName = _faker.person.firstName();
    String lastName = _faker.person.lastName();

    setState(() {
      _currentName = '$firstName $lastName';
    });
  }

  Future<void> _saveName() async {
    if (_currentName.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _namesRef.push().set({
        'name': _currentName,
        'timestamp': ServerValue.timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome salvo com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSavedNames() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedNamesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Nomes'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nome Gerado:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _currentName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _generateName,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Gerar Nome'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveName,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Nome'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _navigateToSavedNames,
                icon: const Icon(Icons.list),
                label: const Text('Ver Nomes Salvos'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
