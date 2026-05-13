import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugaspert4_mp/page/beranda_page.dart';
import 'package:tugaspert4_mp/page/profile_page.dart';
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

  // Mengambil data yang tersimpan di memori perangkat
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUser = prefs.getString('user_profile');
    if (savedUser != null) {
      if (mounted) {
        setState(() {
          userData = Map<String, String>.from(json.decode(savedUser));
          isDataSaved = true;
          showForm = true;
        });
      }
    }
  }

  // Fungsi untuk menyimpan data profil
  Future<void> handleSave(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(data));
    if (mounted) {
      setState(() {
        userData = data;
        isDataSaved = true;
      });
    }
  }

  // Fungsi untuk menghapus data profil
  Future<void> handleDelete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
    if (mounted) {
      setState(() {
        userData = {};
        isDataSaved = false;
        showForm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisi halaman yang akan ditampilkan
    final List<Widget> pages = [
      BerandaPage(
        onSave: handleSave,
        onDelete: handleDelete,
        showForm: showForm,
        onToggleForm: (val) => setState(() => showForm = val),
        userData: userData,
      ),
      ProfilePage(userData: userData, isDataSaved: isDataSaved),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Scaffold(
        // IndexedStack menjaga agar scroll position di Beranda tidak hilang
        body: IndexedStack(
          index: currentPage,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SalomonBottomBar(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}