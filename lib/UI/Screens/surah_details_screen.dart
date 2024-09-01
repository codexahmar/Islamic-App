import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late PageController _pageController;
  int currentPage = 0;
  late List<int> surahPages;
  int? bookmarkedPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    surahPages = quran.getSurahPages(widget.surahNumber);
    _loadBookmark();
  }

  Future<void> _loadBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedPage = prefs.getInt('bookmark_${widget.surahNumber}');
    });
  }

  Future<void> _bookmarkPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the current page is already bookmarked
    if (bookmarkedPage == currentPage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This page is already bookmarked!"),
        ),
      );
    } else {
      // Bookmark the current page
      await prefs.setInt('bookmark_${widget.surahNumber}', currentPage);
      setState(() {
        bookmarkedPage = currentPage;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Page ${currentPage + 1} bookmarked!',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String surahName = quran.getSurahName(widget.surahNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          surahName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: surahPages.length,
                itemBuilder: (context, index) {
                  int pageNumber = surahPages[index];
                  List<String> verses = quran.getVersesTextByPage(pageNumber);

                  // Calculate the starting verse number for the current page
                  int startVerseNumber = 1;
                  for (int i = 0; i < index; i++) {
                    startVerseNumber +=
                        quran.getVersesTextByPage(surahPages[i]).length;
                  }

                  return ListView.builder(
                    itemCount: verses.length,
                    itemBuilder: (context, verseIndex) {
                      int verseNumber = startVerseNumber + verseIndex;
                      String verseText = verses[verseIndex];
                      String endSymbol = quran.getVerseEndSymbol(verseNumber);

                      bool isSajdah =
                          quran.isSajdahVerse(widget.surahNumber, verseNumber);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: verseText,
                                style: GoogleFonts.amiriQuran(
                                  fontSize: 24,
                                  height:
                                      2.5, // Adjust height to fit text properly
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' $endSymbol',
                                style: TextStyle(
                                  color:
                                      isSajdah ? Colors.orange : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Image.asset("assets/images/backward_btn.png"),
                    onPressed: currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Image.asset("assets/images/forward_btn.png"),
                    onPressed: currentPage < surahPages.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _bookmarkPage,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark, color: Colors.white),
                      SizedBox(width: 8.0),
                      Text(
                        S.of(context).bookmarkPage,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
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
