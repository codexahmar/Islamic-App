import 'dart:ui';
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
  int? _selectedIndex; // Track the selected card index

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
          style: GoogleFonts.scheherazadeNew(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1F4068),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/islamic_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Tasbeeh>>(
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

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = _selectedIndex == index ? null : index;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _selectedIndex == index
                                ? Color(0xFF1F4068).withOpacity(0.9)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFFE6B17E),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tasbeeh.name,
                                style: GoogleFonts.scheherazadeNew(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : Color(0xFF1F4068),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tasbeeh.arabic,
                                style: GoogleFonts.scheherazadeNew(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedIndex == index
                                      ? Color(0xFFE6B17E)
                                      : Color(0xFF1F4068),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tasbeeh.translation,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: _selectedIndex == index
                                      ? Colors.white70
                                      : Color(0xFF4B5563),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == index
                                          ? Color(0xFFE6B17E)
                                          : Color(0xFF1F4068),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${tasbeeh.currentCount}/${tasbeeh.count}',
                                      style: GoogleFonts.lato(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _selectedIndex == index
                                            ? Color(0xFF1F4068)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _buildIconButton(Icons.remove, () {
                                        setState(() {
                                          if (tasbeeh.currentCount > 0) {
                                            tasbeeh.currentCount--;
                                            _saveTasbeehCounts(tasbeehList);
                                          }
                                        });
                                      }, _selectedIndex == index),
                                      const SizedBox(width: 10),
                                      _buildIconButton(Icons.add, () {
                                        setState(() {
                                          if (tasbeeh.currentCount <
                                              tasbeeh.count) {
                                            tasbeeh.currentCount++;
                                            _selectedIndex =
                                                index; // Change color on increment
                                            _saveTasbeehCounts(tasbeehList);
                                          }
                                        });
                                      }, _selectedIndex == index),
                                      const SizedBox(width: 10),
                                      _buildIconButton(Icons.refresh, () {
                                        setState(() {
                                          tasbeeh.currentCount = 0;
                                          _saveTasbeehCounts(tasbeehList);
                                        });
                                      }, _selectedIndex == index),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, VoidCallback onPressed, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Color(0xFFE6B17E) : Color(0xFF1F4068),
      ),
      child: IconButton(
        icon: Icon(icon, color: isSelected ? Color(0xFF1F4068) : Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
