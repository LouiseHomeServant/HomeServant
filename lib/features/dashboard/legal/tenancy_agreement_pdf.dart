import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'tenancy_agreement_content.dart';

/// Renders [content] as a PDF using the same clause text the on-screen
/// viewer shows, so the downloaded document always matches what was read.
Future<pw.Document> buildTenancyAgreementPdf(TenancyAgreementContent content) async {
  final navy = PdfColor.fromInt(0xFF10233F);
  final gold = PdfColor.fromInt(0xFFD9A94F);
  // The core PDF fonts (Helvetica et al.) have no ₦ glyph, so the rent
  // clause would render it as a missing-character box. Noto Sans covers it.
  final baseFont = await PdfGoogleFonts.notoSansRegular();
  final boldFont = await PdfGoogleFonts.notoSansBold();
  final doc = pw.Document(theme: pw.ThemeData.withFont(base: baseFont, bold: boldFont));

  pw.Widget partyBlock(String label, TenancyParty party) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 9, color: gold, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 3),
          pw.Text(party.name, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Text('Address: ${party.address}', style: const pw.TextStyle(fontSize: 9)),
          pw.Text('Phone: ${party.phone}', style: const pw.TextStyle(fontSize: 9)),
          pw.Text('Email: ${party.email}', style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  pw.Widget signatureBlock(String label, String prefilledName) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: navy)),
          pw.SizedBox(height: 14),
          pw.Text('Name: $prefilledName', style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(height: 14),
          pw.Container(width: 140, height: 0.7, color: PdfColors.grey500),
          pw.SizedBox(height: 3),
          pw.Text('Signature', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          pw.SizedBox(height: 10),
          pw.Container(width: 140, height: 0.7, color: PdfColors.grey500),
          pw.SizedBox(height: 3),
          pw.Text('Date', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        ],
      ),
    );
  }

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 40),
      build: (pw.Context context) => [
        pw.Center(
          child: pw.Text(
            TenancyAgreementContent.documentTitle.toUpperCase(),
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: navy),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Center(
          child: pw.Text(
            TenancyAgreementContent.documentSubtitle,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ),
        pw.SizedBox(height: 18),
        pw.Text(content.madeOnLine, style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [partyBlock('LANDLORD', content.landlord), pw.SizedBox(width: 20), partyBlock('TENANT', content.tenant)],
        ),
        pw.SizedBox(height: 20),
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 8),
        for (final clause in content.clauses)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${clause.number}. ${clause.title}',
                  style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: navy),
                ),
                pw.SizedBox(height: 3),
                pw.Text(clause.body, style: const pw.TextStyle(fontSize: 9.5, lineSpacing: 2)),
              ],
            ),
          ),
        pw.SizedBox(height: 12),
        pw.Text(
          'SIGNED / ACCEPTED BY THE PARTIES',
          style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: navy),
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            signatureBlock('LANDLORD', content.landlord.name),
            pw.SizedBox(width: 20),
            signatureBlock('TENANT', content.tenant.name),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [signatureBlock('WITNESS 1', '_______________'), pw.SizedBox(width: 20), signatureBlock('WITNESS 2', '_______________')],
        ),
        pw.SizedBox(height: 24),
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 6),
        pw.Text(content.generatedNote, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        pw.SizedBox(height: 4),
        pw.Text(content.disclaimer, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
      ],
    ),
  );

  return doc;
}
