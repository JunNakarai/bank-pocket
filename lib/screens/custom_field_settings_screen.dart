import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomFieldSettingsScreen extends StatefulWidget {
  const CustomFieldSettingsScreen({super.key});

  @override
  State<CustomFieldSettingsScreen> createState() =>
      _CustomFieldSettingsScreenState();
}

class _CustomFieldSettingsScreenState extends State<CustomFieldSettingsScreen> {
  final List<String> _customFields = [];

  @override
  void initState() {
    super.initState();
    _loadCustomFields();
  }

  Future<void> _loadCustomFields() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('customFields') ?? [];
    final defaultFields = ['連携アプリ', 'メモ'];

    if (saved == null || saved.isEmpty) {
      await prefs.setStringList('customFields', defaultFields);
      setState(() {
        _customFields.clear();
        _customFields.addAll(defaultFields);
      });
      return;
    }

    setState(() {
      _customFields.clear();
      _customFields.addAll(saved);
    });
  }

  Future<void> _saveCustomFields() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('customFields', _customFields);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Field Settings')),
      body: ListView.builder(
        itemCount: _customFields.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_customFields[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _customFields.removeAt(index);
                });
                _saveCustomFields();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('ADD'),
                content: TextField(controller: controller),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _customFields.add(controller.text);
                      });
                      _saveCustomFields();
                      Navigator.pop(context);
                    },
                    child: const Text('add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
