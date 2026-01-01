// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:news_now/data/notifiers.dart';
// import 'package:news_now/views/pages/home_page.dart';
// import 'package:news_now/views/pages/profile_page.dart';
// import 'package:news_now/views/widgets/navbar_actionmode_widget.dart';
// import 'package:news_now/views/widgets/navbar_widget.dart';

// List<Widget> pages = [const HomePage(), const ProfilePage()];

// class WidgetTree extends StatefulWidget {
//   const WidgetTree({super.key});

//   @override
//   State<WidgetTree> createState() => _WidgetTreeState();
// }

// class _WidgetTreeState extends State<WidgetTree> {
//   final ScrollController _scrollController = ScrollController();
//   bool _isNavVisible = true;

//   @override
//   void initState() {
//     super.initState();

//     _scrollController.addListener(() {
//       if (_scrollController.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         if (_isNavVisible) setState(() => _isNavVisible = false);
//       } else if (_scrollController.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         if (!_isNavVisible) setState(() => _isNavVisible = true);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       appBar: AppBar(
//         title: Text('News Now!', style: GoogleFonts.arsenal(fontSize: 40)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: const Icon(Icons.menu_book_outlined),
//         actions: const [NavbarActionModeWidget()],
//       ),

//       // attach scroll controller to body
//       body: ValueListenableBuilder(
//         valueListenable: selectedPageNotifier,
//         builder: (context, selectedPage, child) {
//           return NotificationListener<UserScrollNotification>(
//             onNotification: (notification) {
//               if (notification.direction == ScrollDirection.reverse &&
//                   _isNavVisible) {
//                 setState(() => _isNavVisible = false);
//               } else if (notification.direction == ScrollDirection.forward &&
//                   !_isNavVisible) {
//                 setState(() => _isNavVisible = true);
//               }
//               return false;
//             },
//             child: pages.elementAt(selectedPage),
//           );
//         },
//       ),

//       // hide bottom nav on scroll
//       bottomNavigationBar: AnimatedSlide(
//         duration: const Duration(milliseconds: 250),
//         offset: _isNavVisible ? Offset.zero : const Offset(0, 1.5),
//         child: AnimatedOpacity(
//           duration: const Duration(milliseconds: 250),
//           opacity: _isNavVisible ? 1 : 0,
//           child: const NavbarWidget(),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_now/data/notifiers.dart';
import 'package:news_now/views/pages/home_page.dart';
import 'package:news_now/views/pages/profile_page.dart';

List<Widget> pages = [const HomePage(), const ProfilePage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isNavVisible) setState(() => _isNavVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isNavVisible) setState(() => _isNavVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFF0F1115),

      // Modern Header matching HTML design
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1115).withOpacity(0.95),
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade900, width: 0.5),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo and Title
                  Row(
                    children: [
                      const Icon(
                        Icons.newspaper,
                        color: Color(0xFFDC2626),
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'News ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Now',
                              style: TextStyle(color: Color(0xFFDC2626)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Profile Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.transparent, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDJkvicwzeIRB9P-rwISUEsFAbzvKtsGnXOisLR0bnSSk_z6UhZsm3sNlDvnCYM-aCf6_iDlx8ymwX_efQcNB1-O20OCvMT05f7M1E0LpNpWsDNn4jWh4eMyVsKq1PMdBNdO79tI5zhOPk6zTMToqNQa3jkvHSvGsBoPz_STCvEfSvWjqC0cSnNF_2itqGwJ5fW1Si7H5ThtXzLygsxOCsMh2Ou0ng_Vs7REBp6YsMd_kGgRMkUiDPbBWPzWNDiFQC4o7pFwzFC8yI',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Body with page navigation
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.reverse &&
                  _isNavVisible) {
                setState(() => _isNavVisible = false);
              } else if (notification.direction == ScrollDirection.forward &&
                  !_isNavVisible) {
                setState(() => _isNavVisible = true);
              }
              return false;
            },
            child: pages.elementAt(selectedPage),
          );
        },
      ),

      // Modern Bottom Navigation matching HTML design
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        offset: _isNavVisible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _isNavVisible ? 1 : 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF181A20),
              border: Border(
                top: BorderSide(color: Colors.grey.shade900, width: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 64,
                child: ValueListenableBuilder(
                  valueListenable: selectedPageNotifier,
                  builder: (context, selectedPage, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          icon: Icons.home,
                          label: 'Home',
                          index: 0,
                          isSelected: selectedPage == 0,
                        ),
                        _buildNavItem(
                          icon: Icons.bookmark_border,
                          label: 'Saved',
                          index: 1,
                          isSelected: selectedPage == 1,
                        ),
                        _buildNavItem(
                          icon: Icons.search,
                          label: 'Search',
                          index: 2,
                          isSelected: selectedPage == 2,
                        ),
                        _buildNavItem(
                          icon: Icons.person_outline,
                          label: 'Profile',
                          index: 3,
                          isSelected: selectedPage == 3,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (index < pages.length) {
          selectedPageNotifier.value = index;
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator line at top
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 3,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFDC2626)
                    : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),

            // Icon
            Icon(
              isSelected ? _getFilledIcon(icon) : icon,
              color: isSelected
                  ? const Color(0xFFDC2626)
                  : Colors.grey.shade500,
              size: 24,
            ),

            const SizedBox(height: 4),

            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFDC2626)
                    : Colors.grey.shade500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get filled version of icons for selected state
  IconData _getFilledIcon(IconData icon) {
    if (icon == Icons.home) return Icons.home;
    if (icon == Icons.bookmark_border) return Icons.bookmark;
    if (icon == Icons.search) return Icons.search;
    if (icon == Icons.person_outline) return Icons.person;
    return icon;
  }
}

// Dark Mode Notifier (if not already in your notifiers.dart)
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(true);

// Selected Page Notifier (should already be in your notifiers.dart)
// final ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);
