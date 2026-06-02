import 'package:flutter/material.dart';
import 'package:plantid/core/theme.dart';
import 'package:plantid/screens/home_screen.dart';
import 'package:plantid/screens/history_screen.dart';

class PlantIDApp extends StatefulWidget {
  const PlantIDApp({super.key});

  @override
  State<PlantIDApp> createState() => _PlantIDAppState();
}

class _PlantIDAppState extends State<PlantIDApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantID',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.textSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.eco),
              activeIcon: Icon(Icons.eco),
              label: 'Identify',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}
