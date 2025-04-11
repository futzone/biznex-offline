import 'dart:io';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/order_database/order_percent_database.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PrinterServices {
  final AppModel model;
  final Order order;
  final WidgetRef ref;

  PrinterServices({
    required this.order,
    required this.model,
    required this.ref,
  });

  Future<Uint8List?> shopLogoImage() async {
    if (model.imagePath == null || model.imagePath!.isEmpty) return null;
    final imageFile = File(model.imagePath!);
    if (!await imageFile.exists()) return null;

    return await imageFile.readAsBytes();
  }

  void printOrderCheck() async {
    final font = await PdfGoogleFonts.robotoRegular();
    final percents = await OrderPercentDatabase().get();
    final doc = pw.Document();

    final pdfTheme = pw.TextStyle(fontSize: 8, font: font);
    final headerStyle = pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: font);
    final image = await shopLogoImage();

    final content = pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (image != null) pw.Center(child: pw.Image(pw.MemoryImage(image))),
        if (image != null) pw.SizedBox(height: 2),
        pw.Text(
          model.shopName == null || model.shopName!.isEmpty ? 'Biznex' : model.shopName!,
          style: headerStyle,
        ),
        pw.SizedBox(height: 2),
        if (model.shopAddress != null) pw.Text(model.shopAddress ?? '', style: pdfTheme),
        if (model.shopAddress != null) pw.SizedBox(height: 3),
        pw.Text('${AppLocales.orderNumber.tr()}: ${order.orderNumber ?? DateTime.now().millisecondsSinceEpoch}', style: pdfTheme),
        pw.SizedBox(height: 4),
        pw.Container(color: PdfColor.fromHex("#000000"), height: 1),
        pw.SizedBox(height: 4),
        for (final item in order.products)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2, bottom: 2),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    "${item.product.name}: ",
                    style: pdfTheme,
                    overflow: pw.TextOverflow.clip,
                    maxLines: 2,
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Text(
                  "${item.amount.price} ${item.product.measure} * ${item.product.price.price} UZS",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, font: font),
                ),
              ],
            ),
          ),

        if (percents.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Container(color: PdfColor.fromHex("#000000"), height: 1),
          pw.SizedBox(height: 4),
          for (final item in percents)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2, bottom: 2),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "${item.name}: ",
                      style: pdfTheme,
                      overflow: pw.TextOverflow.clip,
                      maxLines: 2,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Text(
                    "${item.percent} %",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, font: font),
                  ),
                ],
              ),
            ),
        ],

        pw.SizedBox(height: 4),
        pw.Container(color: PdfColor.fromHex("#000000"), height: 1),
        pw.SizedBox(height: 4),
        pw.SizedBox(height: 4),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "${order.employee.roleName}:",
                style: pdfTheme,
                overflow: pw.TextOverflow.clip,
                maxLines: 2,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text(
              order.employee.fullname,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, font: font),
            ),
          ],
        ),
        pw.SizedBox(height: 4),

        ///
        if (model.printPhone != null)
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  "${AppLocales.contact.tr()}:",
                  style: pdfTheme,
                  overflow: pw.TextOverflow.clip,
                  maxLines: 2,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                model.printPhone ?? '',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, font: font),
              ),
            ],
          ),
        if (model.printPhone != null) pw.SizedBox(height: 4),

        ///
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "${AppLocales.createdDate.tr()}:",
                style: pdfTheme,
                overflow: pw.TextOverflow.clip,
                maxLines: 2,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text(
              DateFormat('yyyy.MM.dd HH:mm').format(DateTime.parse(order.updatedDate)),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, font: font),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Text("${order.price} UZS", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        if (model.byeText == null || model.byeText!.isEmpty)
          pw.Text(AppLocales.thanksForOrder.tr(), style: pdfTheme)
        else
          pw.Text(model.byeText!, style: pdfTheme),
        pw.SizedBox(height: 4),
      ],
    );

    final pageHeight = (order.products.length * 20.0) + 1100.0;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(72 * PdfPageFormat.mm, pageHeight * PdfPageFormat.mm, marginAll: 5 * PdfPageFormat.mm),
        build: (pw.Context context) => content,
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }
}
