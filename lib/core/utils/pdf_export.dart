import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import '../../models/head_model.dart';
import '../../models/family_member_model.dart';
import '../../core/constants/theme/theme.dart';

Future<void> exportFamilyTreeToPdf(
  BuildContext context,
  HeadModel head,
  List<FamilyMemberModel> members,
) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.robotoRegular(),
        bold: await PdfGoogleFonts.robotoBold(),
      ),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Family Tree of ${head.name}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(AppTheme.primaryMagenta.value),
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            _buildPdfFamilyTreeVisualization(head, members),
            pw.SizedBox(height: 30),
            pw.Text(
              'Generated on ${DateTime.now().toString().split(' ')[0]}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

pw.Widget _buildPdfConnectorLine() {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 20),
    height: 40,
    width: 2,
    decoration: pw.BoxDecoration(
      gradient: pw.LinearGradient(
        colors: [
          PdfColor.fromInt(AppTheme.primaryMagenta.value),
          PdfColor(0x00, 0x00, 0x00, 0x00),
        ],
        stops: const [0.0, 1.0],
      ),
    ),
  );
}

pw.Widget _buildPdfFamilyTreeVisualization(
    HeadModel head, List<FamilyMemberModel> members) {
  final spouses = members.where((m) => m.relationWithHead == 'Spouse').toList();
  final children = members
      .where((m) =>
          m.relationWithHead == 'Son' || m.relationWithHead == 'Daughter')
      .toList();
  final parents = members
      .where((m) =>
          m.relationWithHead == 'Father' || m.relationWithHead == 'Mother')
      .toList();
  final others = members
      .where((m) => !['Spouse', 'Son', 'Daughter', 'Father', 'Mother']
          .contains(m.relationWithHead))
      .toList();

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      if (parents.isNotEmpty) ...[
        _buildPdfGenerationTitle('Parents'),
        _buildPdfGenerationRow(parents),
        _buildPdfConnectorLine(),
      ],
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          _buildPdfMemberCard(head, isHead: true),
          if (spouses.isNotEmpty) ...[
            pw.SizedBox(width: 40),
            _buildPdfMemberCard(spouses.first),
          ],
        ],
      ),
      if (children.isNotEmpty) ...[
        _buildPdfConnectorLine(),
        _buildPdfGenerationTitle('Children'),
        _buildPdfGenerationRow(children),
      ],
      if (others.isNotEmpty) ...[
        pw.SizedBox(height: 40),
        _buildPdfGenerationTitle('Other Relatives'),
        _buildPdfGenerationRow(others),
      ],
    ],
  );
}

pw.Widget _buildPdfGenerationTitle(String title) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 10),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 14,
        color: PdfColor.fromInt(AppTheme.primaryMagenta.value),
      ),
    ),
  );
}

pw.Widget _buildPdfGenerationRow(List<FamilyMemberModel> members) {
  return pw.Wrap(
    spacing: 20,
    runSpacing: 20,
    alignment: pw.WrapAlignment.center,
    children: members.map((member) => _buildPdfMemberCard(member)).toList(),
  );
}

pw.Widget _buildPdfMemberCard(dynamic member, {bool isHead = false}) {
  // Safely get name
  final name = member is HeadModel
      ? member.name?.trim() ?? 'Head'
      : '${member.firstName ?? ''} ${member.lastName ?? ''}'.trim();

  // Safely get initials
  final initials = _getInitials(name);

  final relation = member is FamilyMemberModel ? member.relationWithHead : null;

  return pw.Container(
    margin: const pw.EdgeInsets.all(8),
    width: 140,
    child: pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(3),
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            gradient: isHead
                ? pw.LinearGradient(
                    colors: [
                      PdfColor.fromInt(AppTheme.primaryMagenta.value),
                      PdfColor.fromInt(AppTheme.primaryGray.value),
                    ],
                  )
                : pw.LinearGradient(
                    colors: [
                      PdfColor.fromInt(AppTheme.lightMagenta.value),
                      PdfColor.fromInt(AppTheme.lightGray.value),
                    ],
                  ),
          ),
          child: pw.Container(
            decoration: const pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: PdfColors.white,
            ),
            child: pw.Container(
              width: 64,
              height: 64,
              decoration: const pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                color: PdfColors.white,
              ),
              child: pw.Center(
                child: pw.Text(
                  initials,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(AppTheme.primaryMagenta.value),
                  ),
                ),
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(20),
            boxShadow: [
              pw.BoxShadow(
                color: PdfColor.fromInt(AppTheme.lightGray.value),
                blurRadius: 5,
              ),
            ],
          ),
          child: pw.Column(
            children: [
              pw.Text(
                name.isNotEmpty ? name : 'Unnamed',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: isHead
                      ? PdfColor.fromInt(AppTheme.primaryMagenta.value)
                      : PdfColors.black,
                ),
                textAlign: pw.TextAlign.center,
                maxLines: 2,
                overflow: pw.TextOverflow.clip,
              ),
              if (relation != null && relation.isNotEmpty)
                pw.Text(
                  relation,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromInt(AppTheme.primaryGray.value),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

String _getInitials(String name) {
  if (name.isEmpty) return '?';

  try {
    final parts = name.trim().split(' ').where((part) => part.isNotEmpty);
    if (parts.isEmpty) return '?';

    final firstInitial = parts.first[0];
    final lastInitial = parts.length > 1 ? parts.last[0] : '';

    return '$firstInitial$lastInitial';
  } catch (e) {
    return '?';
  }
}
