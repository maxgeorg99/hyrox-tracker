import 'package:flutter/material.dart';
import 'package:hyrox_tracker/category.dart';
import 'package:hyrox_tracker/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Category _selectedOption;

  @override
  void initState() {
    super.initState();
    _loadCurrentCategory();
  }

  void _loadCurrentCategory() async {
    final currentCategory = dbHelper.category;
    setState(() {
      _selectedOption = currentCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.yellow[700],
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'SETTINGS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Category:',
                        style: TextStyle(
                          color: Colors.yellow[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildRadioListTile(Category.menOpen, 'Men Open'),
                      _buildRadioListTile(Category.menPro, 'Men Pro'),
                      _buildRadioListTile(Category.womenOpen, 'Women Open'),
                      _buildRadioListTile(Category.womenPro, 'Women Pro'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await dbHelper.saveCategory(_selectedOption);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Settings saved')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.yellow[700],
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioListTile(Category category, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      child: RadioListTile<Category>(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        value: category,
        groupValue: _selectedOption,
        onChanged: (Category? value) {
          if (value != null) {
            setState(() {
              _selectedOption = value;
            });
          }
        },
        activeColor: Colors.yellow[700],
      ),
    );
  }
}
