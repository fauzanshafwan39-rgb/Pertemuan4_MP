import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:simple_alert_dialog/simple_alert_dialog.dart';

class BerandaPage extends StatefulWidget {
  final Function(Map<String, String>) onSave;
  final VoidCallback onDelete;
  final bool showForm;
  final Function(bool) onToggleForm;
  final Map<String, String> userData;

  const BerandaPage({
    super.key,
    required this.onSave,
    required this.onDelete,
    required this.showForm,
    required this.onToggleForm,
    required this.userData,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  // Controller dipisah agar tidak duplikat saat build ulang
  final Map<String, TextEditingController> _controllers = {
    'nama': TextEditingController(),
    'lokasi': TextEditingController(),
    'jabatan': TextEditingController(),
    'profesi': TextEditingController(),
    'email': TextEditingController(),
    'hp': TextEditingController(),
    'tentang': TextEditingController(),
    'interests': TextEditingController(), // TAMBAHKAN CONTROLLER INTERESTS
  };

  @override
  void initState() {
    super.initState();
    _fillData();
  }

  void _fillData() {
    widget.userData.forEach((key, value) {
      if (_controllers.containsKey(key)) {
        _controllers[key]!.text = value;
      }
    });
  }

  @override
  void didUpdateWidget(covariant BerandaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika data dihapus dari main.dart, kosongkan form
    if (widget.userData.isEmpty && oldWidget.userData.isNotEmpty) {
      _controllers.forEach((key, value) => value.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Beranda", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildActionButtons(),
            const SizedBox(height: 25),
            if (widget.showForm) _buildSmoothForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: Column(
        children: [
          _customButton("Buka Form Input", Colors.green, Icons.edit_note, () {
            widget.onToggleForm(true);
            CherryToast.info(title: const Text("Form telah siap")).show(context);
          }),
          const SizedBox(height: 12),
          _customButton("Hapus Data", Colors.redAccent, Icons.delete_sweep, () {
            SimpleAlertDialog.show(
              context,
              assetImagepath: AnimatedImage.warning,
              buttonsColor: Colors.redAccent,
              title: AlertTitleText("Hapus?"),
              content: AlertContentText("Semua data profil akan direset."),
              onConfirmButtonPressed: (ctx) {
                widget.onDelete();
                Navigator.pop(ctx);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSmoothForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text("Informasi Profil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _inputField(_controllers['nama']!, "Nama Lengkap", Icons.person_outline),
          _inputField(_controllers['lokasi']!, "Lokasi", Icons.map_outlined),
          _inputField(_controllers['jabatan']!, "Jabatan", Icons.work_outline),
          _inputField(_controllers['profesi']!, "Profesi", Icons.psychology_outlined),
          _inputField(_controllers['email']!, "Email", Icons.email_outlined),
          _inputField(_controllers['hp']!, "Nomor HP", Icons.phone_android_outlined),
          
          // INPUT BARU: SKILLS & INTERESTS
          _inputField(_controllers['interests']!, "Skills & Interests (Pisah dengan koma)", Icons.star_border_rounded),
          
          _inputField(_controllers['tentang']!, "Tentang Saya", Icons.info_outline, maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              widget.onSave({
                'nama': _controllers['nama']!.text,
                'lokasi': _controllers['lokasi']!.text,
                'jabatan': _controllers['jabatan']!.text,
                'profesi': _controllers['profesi']!.text,
                'email': _controllers['email']!.text,
                'hp': _controllers['hp']!.text,
                'interests': _controllers['interests']!.text, // DATA IKUT DISIMPAN
                'tentang': _controllers['tentang']!.text,
              });
              CherryToast.success(title: const Text("Data tersimpan!")).show(context);
            },
            child: const Text("Simpan Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF0F4FF),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _customButton(String text, Color color, IconData icon, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((key, value) => value.dispose());
    super.dispose();
  }
}