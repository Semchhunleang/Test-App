import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// =============================
        /// 1. Background base color
        /// =============================
        Container(
          height: 60, // same as navbar height
          decoration: const BoxDecoration(
            color: Colors.white, // or your background color
          ),
        ),

        /// =============================
        /// 2. Snow overlay
        /// =============================
        Positioned.fill(
          child: Image.asset(
            'assets/images/snow-overlay-button.png',
            fit: BoxFit.cover,
          ),
        ),

        /// =============================
        /// 3. Real BottomNavigationBar
        /// =============================
        BottomNavigationBar(
          backgroundColor: Colors.transparent, // IMPORTANT
          elevation: 0, // remove shadow
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/navbar/home_nav_icon.png',
                height: 24,
                color: currentIndex == 0 ? primaryColor : null,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/home/attendance_icon.png',
                height: 24,
                color: currentIndex == 1 ? primaryColor : null,
              ),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/navbar/setting_nav_icon.png',
                height: 24,
                color: currentIndex == 2 ? primaryColor : null,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ],
    );
  }
}
