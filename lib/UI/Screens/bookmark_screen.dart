import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart' as quran;
import '../../generated/l10n.dart';
import 'surah_details_screen.dart';
import 'dart:convert';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Map<String, dynamic>> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> loadedBookmarks = [];

    for (int i = 1; i <= 114; i++) {
      String? bookmarksJson = prefs.getString('bookmarks_$i');
      if (bookmarksJson != null) {
        List<int> surahBookmarks = List<int>.from(jsonDecode(bookmarksJson));
        String surahName = quran.getSurahName(i);

        for (int pageNumber in surahBookmarks) {
          loadedBookmarks.add({
            'surahNumber': i,
            'pageNumber': pageNumber,
            'surahName': surahName,
          });
        }
      }
    }

    setState(() {
      bookmarks = loadedBookmarks;
    });
  }

  Future<void> _removeBookmark(int surahNumber, int pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'bookmarks_$surahNumber';
    String? bookmarksJson = prefs.getString(key);

    if (bookmarksJson != null) {
      List<int> surahBookmarks = List<int>.from(jsonDecode(bookmarksJson));
      surahBookmarks.remove(pageNumber);

      if (surahBookmarks.isEmpty) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, jsonEncode(surahBookmarks));
      }
    }

    setState(() {
      bookmarks.removeWhere((bookmark) =>
          bookmark['surahNumber'] == surahNumber &&
          bookmark['pageNumber'] == pageNumber);
    });
  }

  void _showRemoveDialog(int surahNumber, int pageNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).removeBookmarkTitle),
          content: Text(S.of(context).removeBookmarkContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                _removeBookmark(surahNumber, pageNumber);
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).yes),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).bookmarksTitle,
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
      body: bookmarks.isEmpty
          ? Center(child: Text(S.of(context).noBookmarks))
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> bookmark = bookmarks[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            "${bookmark['surahNumber']}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        bookmark['surahName'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                          S.of(context).pageNumber(bookmark['pageNumber'])),
                      trailing: IconButton(
                        icon: Icon(Icons.bookmark, color: Colors.yellow[700]),
                        onPressed: () {
                          _showRemoveDialog(
                              bookmark['surahNumber'], bookmark['pageNumber']);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahDetailScreen(
                              surahNumber: bookmark['surahNumber'],
                              initialPage: bookmark['pageNumber'] -
                                  1, // Subtract 1 to convert from 1-based to 0-based index
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
