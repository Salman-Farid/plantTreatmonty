import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';

class PlantCarePage extends StatelessWidget {
  const PlantCarePage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _loadCareGuides(BuildContext context) async {
    final String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/care_guides/care_guides.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData['careGuides']);
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'water_drop': Icons.water_drop,
      'grass': Icons.grass,
      'bug_report': Icons.bug_report,
      'wb_sunny': Icons.wb_sunny,
    };
    return iconMap[iconName] ?? Icons.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Plant Care Guide')
            .animate()
            .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
            .slideX(begin: -0.3, end: 0, duration: 1200.ms),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadCareGuides(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final guide = snapshot.data![index];
              final color = _getColorFromHex(guide['color']);
              final List<String> tips = List<String>.from(guide['tips']);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 0.5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getIconData(guide['icon']), color: color),
                    )
                        .animate()
                        .fadeIn(
                      duration: 800.ms,
                      delay: (300 + (index * 100)).ms,
                      curve: Curves.easeOut,
                    )
                        .slideX(begin: -0.2, end: 0),
                    title: Text(
                      guide['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                        .animate()
                        .fadeIn(
                      duration: 800.ms,
                      delay: (500 + (index * 100)).ms,
                      curve: Curves.easeOut,
                    )
                        .slideX(begin: 0.2, end: 0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tips.asMap().entries.map((entry) {
                            final int tipIndex = entry.key;
                            final String tip = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle, size: 20, color: color)
                                      .animate()
                                      .fadeIn(
                                    duration: 600.ms,
                                    delay: (200 + (tipIndex * 100)).ms,
                                    curve: Curves.easeOut,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(tip)
                                        .animate()
                                        .fadeIn(
                                      duration: 800.ms,
                                      delay: (400 + (tipIndex * 100)).ms,
                                      curve: Curves.easeOut,
                                    )
                                        .slideY(
                                      begin: 0.2,
                                      end: 0,
                                      duration: 600.ms,
                                      delay: (400 + (tipIndex * 100)).ms,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                duration: 1000.ms,
                delay: (200 + (index * 150)).ms,
                curve: Curves.easeOut,
              )
                  .slideY(begin: 0.3, end: 0);
            },
          );
        },
      ),
    );
  }
}