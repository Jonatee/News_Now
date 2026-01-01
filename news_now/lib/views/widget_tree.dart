import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_now/data/notifiers.dart';
import 'package:news_now/views/pages/home_page.dart';
import 'package:news_now/views/pages/profile_page.dart';
import 'package:news_now/views/widgets/navbar_actionmode_widget.dart';
import 'package:news_now/views/widgets/navbar_widget.dart';

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
      appBar: AppBar(
        title: Text('News Now!', style: GoogleFonts.arsenal(fontSize: 40)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.menu_book_outlined),
        actions: const [NavbarActionModeWidget()],
      ),

      // attach scroll controller to body
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

      // hide bottom nav on scroll
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        offset: _isNavVisible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _isNavVisible ? 1 : 0,
          child: const NavbarWidget(),
        ),
      ),
    );
  }
}
