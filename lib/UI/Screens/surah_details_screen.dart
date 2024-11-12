import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/UI/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final int initialPage;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.initialPage = 0,
  });

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late PageController _pageController;
  late ScrollController _scrollController;
  int currentPage = 0;
  late List<int> surahPages;
  List<int> bookmarkedPages = [];

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    _pageController = PageController(initialPage: currentPage);
    _scrollController = ScrollController();
    _loadSurahPages();
    _loadBookmarks();
  }

  Future<void> _loadSurahPages() async {
    surahPages = quran.getSurahPages(widget.surahNumber);
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bookmarksJson = prefs.getString('bookmarks_${widget.surahNumber}');
    if (bookmarksJson != null) {
      setState(() {
        bookmarkedPages = List<int>.from(jsonDecode(bookmarksJson));
      });
    }
  }

  Future<void> _bookmarkPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (bookmarkedPages.contains(currentPage + 1)) {
      // Remove bookmark if already bookmarked
      bookmarkedPages.remove(currentPage + 1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Bookmark removed from page ${currentPage + 1}')),
      );
    } else {
      // Add new bookmark
      bookmarkedPages.add(currentPage + 1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Page ${currentPage + 1} bookmarked!')),
      );
    }

    // Save updated bookmarks
    await prefs.setString(
        'bookmarks_${widget.surahNumber}', jsonEncode(bookmarkedPages));

    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String surahName = quran.getSurahName(widget.surahNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          surahName,
          style: GoogleFonts.lateef(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(
              bookmarkedPages.contains(currentPage + 1)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
            onPressed: _bookmarkPage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                reverse: true,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: surahPages.length,
                itemBuilder: (context, index) {
                  int pageNumber = surahPages[index];
                  List<String> verses = quran.getVersesTextByPage(pageNumber);

                  int startVerseNumber = 1;
                  for (int i = 0; i < index; i++) {
                    startVerseNumber +=
                        quran.getVersesTextByPage(surahPages[i]).length;
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: verses.length,
                    itemBuilder: (context, verseIndex) {
                      int verseNumber = startVerseNumber + verseIndex;
                      String verseText = verses[verseIndex];
                      String endSymbol = quran.getVerseEndSymbol(verseNumber);
                      bool isSajdah =
                          quran.isSajdahVerse(widget.surahNumber, verseNumber);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: verseText,
                                    style: GoogleFonts.scheherazadeNew(
                                      fontSize: 24,
                                      height: 2.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' $endSymbol',
                                    style: TextStyle(
                                      color: isSajdah
                                          ? Colors.orange
                                          : primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${widget.surahNumber}:$verseNumber',
                              style: GoogleFonts.lateef(
                                fontSize: 18,
                                color: primaryColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: currentPage < surahPages.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
                Text(
                  'Page ${currentPage + 1} of ${surahPages.length}',
                  style: GoogleFonts.lateef(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
