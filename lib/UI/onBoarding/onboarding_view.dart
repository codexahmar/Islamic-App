import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/UI/onBoarding/onboarding_items.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Bottom Bar/bottombar_class.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      int nextPageIndex = pageController.page!.toInt();
      if (nextPageIndex != _currentPageIndex) {
        setState(() {
          _currentPageIndex = nextPageIndex;
        });
      }
      if (pageController.page!.toInt() == controller.items.length - 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbar()),
        );
      }
    });
  }

  void _handleNextButton() {
    if (pageController.page!.toInt() == controller.items.length - 1) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbar()),
        );
      });
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          controller.items[_currentPageIndex].title,
          style: TextStyle(
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_currentPageIndex != controller.items.length - 1)
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavbar(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Center(
                  child: Text(
                    "Skip",
                    style: TextStyle(fontSize: screenWidth * 0.045),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: controller.items.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        controller.items[index].image,
                        width: double.infinity,
                        height: screenHeight * 0.568, // Responsive height
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      SmoothPageIndicator(
                        controller: pageController,
                        count: controller.items.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: const Color(0xff282D0D),
                          dotColor: Colors.grey,
                          dotHeight: screenWidth * 0.025, // Responsive dot size
                          dotWidth: screenWidth * 0.025, // Responsive dot size
                          expansionFactor: 4,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        controller.items[index].description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15, // Responsive font size
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            GestureDetector(
              onTap: _handleNextButton,
              child: InkWell(
                onTap: _handleNextButton,
                child: Container(
                  width: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF00653A),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045, // Responsive font size
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
