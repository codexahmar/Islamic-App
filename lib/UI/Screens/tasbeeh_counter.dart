import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/tasbeeh_model.dart';
import '../../generated/l10n.dart';

class TasbeehCounter extends StatefulWidget {
  const TasbeehCounter({super.key});

  @override
  State<TasbeehCounter> createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends State<TasbeehCounter> {
  late Future<List<Tasbeeh>> _futureTasbeeh;

  @override
  void initState() {
    super.initState();
    _futureTasbeeh = loadTasbeeh().then((tasbeehList) async {
      for (var tasbeeh in tasbeehList) {
        await tasbeeh.loadCount();
      }
      return tasbeehList;
    });
  }

  Future<void> _saveTasbeehCounts(List<Tasbeeh> tasbeehList) async {
    for (var tasbeeh in tasbeehList) {
      await tasbeeh.saveCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.tasbeehCounter,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Tasbeeh>>(
        future: _futureTasbeeh,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final tasbeehList = snapshot.data!;

          return ListView.builder(
            itemCount: tasbeehList.length,
            itemBuilder: (context, index) {
              final tasbeeh = tasbeehList[index];

              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tasbeeh.name,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tasbeeh.arabic,
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tasbeeh.translation,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Count: ${tasbeeh.currentCount}/${tasbeeh.count}',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (tasbeeh.currentCount < tasbeeh.count) {
                                    tasbeeh.currentCount++;
                                    _saveTasbeehCounts(tasbeehList);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (tasbeeh.currentCount > 0) {
                                    tasbeeh.currentCount--;
                                    _saveTasbeehCounts(tasbeehList);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {
                                  tasbeeh.currentCount = 0;
                                  _saveTasbeehCounts(tasbeehList);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
