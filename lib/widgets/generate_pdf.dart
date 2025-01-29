import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class GeneratePdfPage {
  static Future<void> generatePdf({
    required Uint8List imageData,
    required String prediction,
    required String symptoms,
    required String treatments,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Report of Disease Detected',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 20),
                if (imageData.isNotEmpty)
                  pw.Container(
                    width: 300,
                    height: 300,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.red100, width: 10),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.ClipRRect(
                      horizontalRadius: 10,
                      verticalRadius: 10,
                      child: pw.Image(
                        pw.MemoryImage(imageData),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),

                pw.SizedBox(height: 20),
                pw.Text(
                  'Prediction: $prediction',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Symptoms: \n$symptoms',
                  style: pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Treatments: \n$treatments',
                  style: pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Mobile platform-specific code to save and open the PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file using the 'open_file' package
    OpenFile.open(file.path);
  }
}
