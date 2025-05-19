import 'dart:async';

import 'package:fittrack/presentation/screens/features/club/club_screen.dart';
import 'package:fittrack/presentation/screens/features/individual_training/individual_training_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../data/services/auth_service.dart';
import '../dialogs/error_dialog.dart';
import 'features/page_with_indicators/page_with_indicators_screen.dart';
import 'features/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final Timer _refreshTimer;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _refreshTimer = Timer.periodic(const Duration(minutes: 55), (timer) async {
      try {
        await _authService.refreshTokenIfNeeded();
      } catch (e) {
        ErrorDialog().showErrorDialog(
          context,
          "Упс, помилка :(",
          "У нас виникла помилка оновлення, вибачте за тимчасові незручності",
        );
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  Color _iconColor(int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedIndex == index;

    if (isSelected) {
      return isDark ? Colors.black : Colors.white;
    } else {
      return isDark ? Colors.grey.shade400 : Colors.grey;
    }
  }

  final List<Widget> _pages = [
    const PageWithIndicatorsScreen(),
    const IndividualTrainingScreen(),
    const ClubScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabBorderRadius: 48,
          gap: 6,
          iconSize: 24,
          tabBackgroundColor: Theme.of(context).primaryColor,
          color: _iconColor(-1),
          activeColor: _iconColor(_selectedIndex),
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
          tabs: [
            GButton(
              icon: Icons.circle,
              iconSize: 0,
              leading: SvgPicture.asset(
                "assets/icons/home_page_icon.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(_iconColor(0), BlendMode.srcIn),
              ),
              text: 'Головна',
            ),
            GButton(
              icon: Icons.circle,
              iconSize: 0,
              leading: SvgPicture.asset(
                "assets/icons/training_page_icon.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(_iconColor(1), BlendMode.srcIn),
              ),
              text: 'Тренування',
            ),
            GButton(
              icon: Icons.circle,
              iconSize: 0,
              leading: SvgPicture.asset(
                "assets/icons/gym_page_icon.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(_iconColor(2), BlendMode.srcIn),
              ),
              text: 'Мій клуб',
            ),
            GButton(
              icon: Icons.circle,
              iconSize: 0,
              leading: SvgPicture.asset(
                "assets/icons/profile_page_icon.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(_iconColor(3), BlendMode.srcIn),
              ),
              text: 'Профіль',
            ),
          ],
        ),
      ),
    );
  }
}
