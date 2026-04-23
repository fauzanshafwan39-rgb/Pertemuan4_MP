import 'package:flutter/material.dart';
import 'detail_materi_page.dart'; // Pastikan import ini ada

class ListPertemuanPage extends StatelessWidget {
  const ListPertemuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data list materi kamu
    final List<Map<String, String>> materi = [
      {"judul": "Pertemuan 1", "sub": "Pengenalan Android", "desc": "Mempelajari dasar-dasar Android Studio dan arsitektur mobile apps."},
      {"judul": "Pertemuan 2", "sub": "Widget & Button", "desc": "Eksperimen dengan berbagai widget UI seperti Row, Column, dan Button."},
      {"judul": "Pertemuan 3", "sub": "Activity & Intent", "desc": "Belajar cara berpindah halaman dan membawa data antar screen."},
      {"judul": "Pertemuan 4", "sub": "Toast & AlertDialog", "desc": "Implementasi notifikasi popup dan dialog konfirmasi user."},
      {"judul": "Pertemuan 5", "sub": "ListView", "desc": "Menampilkan data dinamis dalam bentuk daftar yang bisa di-scroll."},
      {"judul": "Pertemuan 6", "sub": "Checkbox", "desc": "Mengelola input pilihan ganda untuk form aplikasi."},
      {"judul": "Pertemuan 7", "sub": "Radio Button", "desc": "Implementasi pilihan tunggal menggunakan widget Radio."},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Daftar Materi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: materi.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.book_outlined, color: Colors.blueAccent),
              ),
              title: Text(materi[index]['judul']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(materi[index]['sub']!),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              onTap: () {
                // Navigasi masuk ke detail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMateriPage(
                      judul: materi[index]['judul']!,
                      sub: materi[index]['sub']!,
                      deskripsi: materi[index]['desc']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}