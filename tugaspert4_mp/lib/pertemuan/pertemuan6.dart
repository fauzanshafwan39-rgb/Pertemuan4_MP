import 'package:flutter/material.dart';

class CheckboxPage extends StatefulWidget {
  // 1. TAMBAHKAN CONSTRUCTOR CONST DI SINI
  const CheckboxPage({super.key}); 

  @override
  _CheckboxPageState createState() => _CheckboxPageState();
}

// 2. DISAMAKAN NAMANYA AGAR STANDAR FLUTTER
class _CheckboxPageState extends State<CheckboxPage> {
  // Form controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  
  // Checkbox states
  bool _isCheckedSyarat = false;
  String _errorText = '';
  
  // Hobby checkboxes
  final Map<String, bool> _hobbies = {
    'Membaca': false,
    'Olahraga': false,
    'Musik': false,
    'Game': false,
    'Traveling': false,
  };
  
  // Form validation errors
  String _namaError = '';
  String _nimError = '';
  String _kelasError = '';
  String _hobbyError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.lightGreenAccent,
          title: const Text(
            'Form dengan Checkbox',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Data Diri',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama Lengkap',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            errorText: _namaError.isNotEmpty ? _namaError : null,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nimController,
                          decoration: InputDecoration(
                            labelText: 'NIM',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            errorText: _nimError.isNotEmpty ? _nimError : null,
                            prefixIcon: const Icon(Icons.numbers),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _kelasController,
                          decoration: InputDecoration(
                            labelText: 'Kelas',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            errorText: _kelasError.isNotEmpty ? _kelasError : null,
                            prefixIcon: const Icon(Icons.class_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Hobi Section
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hobi (Pilih minimal 1)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 3,
                          children: _hobbies.keys.map((hobby) {
                            return CheckboxListTile(
                              title: Text(hobby, style: const TextStyle(fontSize: 14)),
                              value: _hobbies[hobby],
                              onChanged: (bool? value) {
                                setState(() {
                                  _hobbies[hobby] = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }).toList(),
                        ),
                        if (_hobbyError.isNotEmpty)
                          Text(_hobbyError, style: const TextStyle(color: Colors.red, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text('Saya menyetujui syarat & ketentuan', style: TextStyle(fontSize: 13)),
                  value: _isCheckedSyarat,
                  onChanged: (bool? value) => setState(() => _isCheckedSyarat = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (_errorText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(_errorText, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _validateAndSubmit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('DAFTAR SEKARANG'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
  
  void _validateAndSubmit(BuildContext context) {
    setState(() {
      _namaError = _namaController.text.isEmpty ? 'Nama wajib diisi' : '';
      _nimError = _nimController.text.length < 8 ? 'NIM minimal 8 digit' : '';
      _kelasError = _kelasController.text.isEmpty ? 'Kelas wajib diisi' : '';
      _hobbyError = !_hobbies.values.any((element) => element) ? 'Pilih minimal 1 hobi' : '';
      _errorText = !_isCheckedSyarat ? 'Setujui syarat & ketentuan' : '';

      if (_namaError.isEmpty && _nimError.isEmpty && _kelasError.isEmpty && _hobbyError.isEmpty && _isCheckedSyarat) {
         showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Berhasil"),
            content: const Text("Data pendaftaran telah diterima."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _kelasController.dispose();
    super.dispose();
  }
}