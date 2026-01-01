import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:news_now/views/widget_tree.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ensures layout respects system UI (notch/status bar)
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Column(
          children: [
            // ====== TOP HALF ======
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(300),
                    bottomLeft: Radius.circular(300),
                  ),
                ),
                child: ClipRRect(
                  child: Lottie.asset('assets/lotties/GlobalNews.json'),
                ),
              ),
            ),
            SizedBox(height: 10),
            // ====== BOTTOM HALF ======
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(300),
                    topRight: Radius.circular(300),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              'News',
                              style: TextStyle(
                                fontSize: 80,
                                letterSpacing: 10,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Now!',
                              style: GoogleFonts.rubik(
                                fontSize: 80,
                                letterSpacing: 10,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100.0),
                      ElevatedButton.icon(
                        label: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 40,
                        ),

                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WidgetTree(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 60.0),
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        icon: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
