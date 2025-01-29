import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:card_swiper/card_swiper.dart';

import 'widgets/generate_pdf.dart';
import 'main_screen/home_page.dart';

class AnalysisImagePage extends StatefulWidget {
  final Uint8List imageData;
  final String prediction;

  const AnalysisImagePage({
    required this.imageData,
    required this.prediction,
  });

  @override
  _AnalysisImagePageState createState() => _AnalysisImagePageState();
}

class _AnalysisImagePageState extends State<AnalysisImagePage> with SingleTickerProviderStateMixin {
  bool _showSymptoms = false;
  bool _showTreatments = false;
  late AnimationController _controller;
  Map<String, dynamic> diseaseData = {};
  final Color boxColor =  Colors.white;
  final Color textColor = Colors.black87;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();
    _loadDiseaseData();
  }

  Future<void> _loadDiseaseData() async {
    final String response = await rootBundle.loadString('assets/symptoms_and_treatment/plant_diseases_complete.json');
    setState(() {
      diseaseData = json.decode(response)['diseases'];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getSymptoms(String disease) {
    if (diseaseData.containsKey(disease)) {
      return diseaseData[disease]['symptoms'];
    }
    return "Symptoms not available for this disease.";
  }

  String _getTreatments(String disease) {
    if (diseaseData.containsKey(disease)) {
      return diseaseData[disease]['treatments'];
    }
    return "Treatments not available for this disease.";
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 0.5,
      color: boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Analysis Results',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: -0.3),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.agriculture, color: textColor, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.prediction,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                )
              ],
            ).animate().fadeIn(delay: 700.ms).slideX(),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: boxColor,
        elevation: 0.5,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ).animate()
        .fadeIn(delay: 1100.ms)
        .slideX(begin: 0.3);
  }

  Widget _buildDetailSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 0.5,
      color: boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Divider(color: textColor.withOpacity(0.3)),
            Text(
              content,
              style: TextStyle(fontSize: 16, height: 1.5, color: textColor),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(delay: 300.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Analysis Results', style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: textColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('About Analysis', style: TextStyle(color: textColor)),
                  content: Text('This analysis is based on machine learning model predictions. Results may vary.'),
                  actions: [
                    TextButton(
                      child: Text('OK', style: TextStyle(color: boxColor)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Hero(
                  tag: 'plant_image',
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        widget.imageData,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ).animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8)),

                SizedBox(height: 24),
                _buildResultCard(),
                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        text: 'Symptoms',
                        icon: Icons.sick,
                        onPressed: () => setState(() => _showSymptoms = !_showSymptoms),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        text: 'Treatments',
                        icon: Icons.healing,
                        onPressed: () => setState(() => _showTreatments = !_showTreatments),
                      ),
                    ),
                  ],
                ),

                if (_showSymptoms) ...[
                  SizedBox(height: 16),
                  _buildDetailSection(
                    title: 'Symptoms',
                    content: _getSymptoms(widget.prediction),
                    icon: Icons.visibility,
                  ),
                ],

                if (_showTreatments) ...[
                  SizedBox(height: 16),
                  _buildDetailSection(
                    title: 'Treatments',
                    content: _getTreatments(widget.prediction),
                    icon: Icons.medical_services,
                  ),
                ],

                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    await GeneratePdfPage.generatePdf(
                      imageData: widget.imageData,
                      prediction: widget.prediction,
                      symptoms: _getSymptoms(widget.prediction),
                      treatments: _getTreatments(widget.prediction),
                    );
                  },
                  icon: Icon(Icons.picture_as_pdf, color: textColor),
                  label: Text('Generate Report', style: TextStyle(color: textColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: boxColor,
                    elevation: 0.5,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ).animate()
                    .fadeIn(delay: 1300.ms)
                    .slideY(begin: 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
