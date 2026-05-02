import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RadiobuttonPage extends StatefulWidget {
  const RadiobuttonPage({super.key});

  @override
  _RadiobuttonPageState createState() => _RadiobuttonPageState();
}

class _RadiobuttonPageState extends State<RadiobuttonPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();

  String? _selectedGender;
  String? _selectedJob;
  String? _selectedWorkType;

  // Palette Warna Modern
  final Color primaryColor = const Color(0xFF6366F1); 
  final Color accentColor = const Color(0xFF818CF8);

  final List<Map<String, dynamic>> _jobOptions = [
    {'value': 'Admin', 'icon': Icons.support_agent, 'color': Color(0xFF3B82F6)},
    {'value': 'Guru', 'icon': Icons.school, 'color': Color(0xFF10B981)},
    {'value': 'Programmer', 'icon': Icons.code, 'color': Color(0xFF6366F1)},
    {'value': 'Pengusaha', 'icon': Icons.business, 'color': Color(0xFFF59E0B)},
    {'value': 'Desainer', 'icon': Icons.design_services, 'color': Color(0xFFEC4899)},
  ];

  final List<Map<String, dynamic>> _workTypeOptions = [
    {'value': 'Full Time', 'desc': 'Prioritas Utama', 'icon': Icons.timer},
    {'value': 'Part Time', 'desc': 'Fleksibel', 'icon': Icons.shutter_speed},
    {'value': 'Freelance', 'desc': 'Remote-ready', 'icon': Icons.laptop_mac},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Career Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Informasi Pribadi", Icons.person_outline),
              _buildCard([
                _buildTextField(_namaController, "Nama Lengkap", Icons.person),
                const SizedBox(height: 16),
                _buildTextField(_umurController, "Umur", Icons.cake, isNumber: true),
              ]),

              const SizedBox(height: 24),
              _buildSectionHeader("Profesi", Icons.work_outline),
              _buildJobGrid(),

              const SizedBox(height: 24),
              _buildSectionHeader("Tipe Pekerjaan", Icons.bolt_outlined),
              _buildWorkTypeSelector(),

              const SizedBox(height: 40),
              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("SIMPAN DATA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (v) => v!.isEmpty ? "$label wajib diisi" : null,
    );
  }

  Widget _buildJobGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _jobOptions.map((job) {
        bool isSelected = _selectedJob == job['value'];
        return GestureDetector(
          onTap: () => setState(() => _selectedJob = job['value']),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? job['color'] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? job['color'] : Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(job['icon'], size: 18, color: isSelected ? Colors.white : job['color']),
                const SizedBox(width: 8),
                Text(job['value'], style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkTypeSelector() {
    return Column(
      children: _workTypeOptions.map((type) {
        bool isSelected = _selectedWorkType == type['value'];
        return GestureDetector(
          onTap: () => setState(() => _selectedWorkType = type['value']),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(type['icon'], color: isSelected ? primaryColor : Colors.grey),
                const SizedBox(width: 12),
                Expanded(child: Text(type['value'], style: const TextStyle(fontWeight: FontWeight.bold))),
                Radio<String>(
                  value: type['value'],
                  groupValue: _selectedWorkType,
                  activeColor: primaryColor,
                  onChanged: (v) => setState(() => _selectedWorkType = v),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- LOGIC SIMPAN & TAMPILAN MODAL (SESUAI GAMBAR) ---

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedJob == null || _selectedWorkType == null) {
        Fluttertoast.showToast(msg: "Lengkapi semua pilihan!", gravity: ToastGravity.CENTER);
        return;
      }

      // MODAL BOTTOM SHEET SESUAI GAMBAR USER
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis handle atas
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 24),
              
              // Icon Check Hijau
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF4CAF50),
                child: Icon(Icons.check, color: Colors.white, size: 45),
              ),
              const SizedBox(height: 20),
              
              // Teks Berhasil
              const Text("Data Berhasil Disimpan", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 30),
              
              // Ringkasan Data (Row Align Left & Right)
              _buildSummaryRow("Nama", _namaController.text),
              _buildSummaryRow("Profesi", _selectedJob!),
              _buildSummaryRow("Tipe", _selectedWorkType!),
              
              const SizedBox(height: 40),
              
              // Tombol Selesai
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Selesai", style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }
}