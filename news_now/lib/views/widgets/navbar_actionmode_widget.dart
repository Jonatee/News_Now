import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_now/data/constants.dart';
import 'package:news_now/data/notifiers.dart';

class NavbarActionModeWidget extends StatefulWidget {
  const NavbarActionModeWidget({super.key});

  @override
  State<NavbarActionModeWidget> createState() => _NavbarActionModeWidgetState();
}

class _NavbarActionModeWidgetState extends State<NavbarActionModeWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return IconButton(
          onPressed: () async {
             isDarkModeNotifier.value = !isDarkModeNotifier.value;
            final SharedPreferences prefs =
            await SharedPreferences.getInstance();
            await prefs.setBool(KConstants.themeModekey, isDarkModeNotifier.value);
           
          },
          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        );
      },
    );
  }
}
