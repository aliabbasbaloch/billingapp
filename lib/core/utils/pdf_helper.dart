import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:billingapp/core/data/hive_database.dart';
import 'package:billingapp/features/billing/domain/entities/cart_item.dart';
import 'package:billingapp/features/settings/data/models/settings_model.dart';

class PdfHelper {
  static Future<File> generateInvoice({
    required List<CartItem> cartItems,
    required SettingsModel? settings,
  }) async {
    final pdf = pw.Document();

    // Get next invoice number
    final box = HiveDatabase.invoiceCounterStore;
    final current = box.get('counter', defaultValue: 0)!;
    final invoiceNumber = current + 1;
    await box.put('counter', invoiceNumber);

    final invoiceId = 'INV-${invoiceNumber.toString().padLeft(4, '0')}';
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    final shopName = settings?.shopName ?? 'My Shop';
    final address1 = settings?.addressLine1 ?? '';
    final address2 = settings?.addressLine2 ?? '';
    final phone = settings?.phoneNumber ?? '';
    final footer = settings?.receiptFooter ?? 'Thank you, visit again!';

    final double grandTotal =
        cartItems.fold(0, (sum, item) => sum + item.totalPrice);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      shopName,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (address1.isNotEmpty) pw.Text(address1),
                    if (address2.isNotEmpty) pw.Text(address2),
                    if (phone.isNotEmpty) pw.Text('Tel: $phone'),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice: $invoiceId'),
                  pw.Text('Date: $dateStr'),
                ],
              ),
              pw.SizedBox(height: 16),
              // Table header
              pw.Container(
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                        'Item',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        'Qty',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Unit Price',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Total',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              // Table rows
              ...cartItems.map((item) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey200),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Text(item.productName),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          '${item.quantity}',
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          'PKR ${item.unitPrice.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          'PKR ${item.totalPrice.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Grand Total: PKR ${grandTotal.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Payment details
              if (settings != null &&
                  (settings.easyPaisaNumber?.isNotEmpty == true ||
                      settings.jazzCashNumber?.isNotEmpty == true)) ...[
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.Text(
                  'Payment Options',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                if (settings.easyPaisaNumber?.isNotEmpty == true)
                  pw.Text(
                    'Easypaisa: ${settings.easyPaisaTitle ?? ''} - ${settings.easyPaisaNumber}',
                  ),
                if (settings.jazzCashNumber?.isNotEmpty == true)
                  pw.Text(
                    'JazzCash: ${settings.jazzCashTitle ?? ''} - ${settings.jazzCashNumber}',
                  ),
              ],
              pw.Spacer(),
              pw.Divider(),
              pw.Center(child: pw.Text(footer)),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$invoiceId.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
