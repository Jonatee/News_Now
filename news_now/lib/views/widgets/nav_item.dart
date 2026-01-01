import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_now/data/notifiers.dart';

class NavItem extends StatelessWidget {
  final String title;

  const NavItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: value ? Colors.white : Colors.black,
                letterSpacing: 2,
              ),
            ),
            SizedBox(width: 20),
          ],
        );
      }
    );
  }
}
