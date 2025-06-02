import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/bottom_nav.dart';
import 'bantuan_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'saran_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
    SaranScreen(),
    BantuanScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onNavTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      // Haptic feedback untuk memberikan respon tactile
      HapticFeedback.lightImpact();

      // Animasi halus untuk transisi halaman
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Trigger animasi untuk efek visual
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (_selectedIndex != index) {
                setState(() {
                  _selectedIndex = index;
                });
                HapticFeedback.selectionClick();
              }
            },
            children: _pages.map((page) {
              return Transform.scale(
                scale: 1.0 - (_animationController.value * 0.02),
                child: page,
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNav(
          currentIndex: _selectedIndex,
          onTap: _onNavTapped,
        ),
      ),
      // Floating overlay untuk transisi yang lebih smooth
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
