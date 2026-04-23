import 'dart:convert'; // Untuk encode/decode Map ke String
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugaspert4_mp/page/beranda_page.dart';
import 'package:tugaspert4_mp/page/profile_page.dart';
import 'package:tugaspert4_mp/page/list_pertemuan_page.dart'; // IMPORT HALAMAN BARU
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPage = 0;
  Map<String, String> userData = {};
  bool isDataSaved = false;
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUser = prefs.getString('user_profile');
    if (savedUser != null) {
      setState(() {
        userData = Map<String, String>.from(json.decode(savedUser));
        isDataSaved = true;
        showForm = true;
      });
    }
  }

  Future<void> handleSave(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = data;
      isDataSaved = true;
    });
    await prefs.setString('user_profile', json.encode(data));
  }

  Future<void> handleDelete() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = {};
      isDataSaved = false;
      showForm = false;
    });
    await prefs.remove('user_profile');
  }

  @override
  Widget build(BuildContext context) {
    // TAMBAHKAN HALAMAN LIST KE DALAM ARRAY PAGES
    List<Widget> pages = [
      BerandaPage(
        onSave: handleSave,
        onDelete: handleDelete,
        showForm: showForm,
        onToggleForm: (val) => setState(() => showForm = val),
        userData: userData,
      ),
      ProfilePage(userData: userData, isDataSaved: isDataSaved),
      const ListPertemuanPage(), // <--- HALAMAN LIST BARU DI SINI
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: pages[currentPage],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentPage,
          onTap: (i) => setState(() => currentPage = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_rounded),
              title: const Text("Beranda"),
              selectedColor: Colors.blueAccent,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_rounded),
              title: const Text("Profil"),
              selectedColor: Colors.blueAccent,
            ),
            // TAMBAHKAN ITEM BARU DI BOTTOM BAR
            SalomonBottomBarItem(
              icon: const Icon(Icons.list_alt_rounded),
              title: const Text("List"),
              selectedColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}