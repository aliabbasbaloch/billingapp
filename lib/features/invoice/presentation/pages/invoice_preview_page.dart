import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:billingapp/features/billing/domain/entities/cart_item.dart';
import 'package:billingapp/features/billing/presentation/bloc/cart_bloc.dart';
import 'package:billingapp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:billingapp/core/utils/pdf_helper.dart';

class InvoicePreviewPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const InvoicePreviewPage({super.key, required this.cartItems});

  @override
  State<InvoicePreviewPage> createState() => _InvoicePreviewPageState();
}

class _InvoicePreviewPageState extends State<InvoicePreviewPage> {
  File? _pdfFile;
  bool _isGenerating = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    try {
      final settingsState = context.read<SettingsBloc>().state;
      final settings =
          settingsState is SettingsLoaded ? settingsState.settings : null;
      final file = await PdfHelper.generateInvoice(
        cartItems: widget.cartItems,
        settings: settings,
      );
      setState(() {
        _pdfFile = file;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isGenerating = false;
      });
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfFile == null) return;
    await Share.shareXFiles(
      [XFile(_pdfFile!.path)],
      text: 'Invoice from Billing App',
    );
  }

  Future<void> _printPdf() async {
    if (_pdfFile == null) return;
    await Printing.layoutPdf(
      onLayout: (_) => _pdfFile!.readAsBytes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
        actions: [
          if (_pdfFile != null) ...[
            IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'Print',
              onPressed: _printPdf,
            ),
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share',
              onPressed: _sharePdf,
            ),
          ],
        ],
      ),
      body: _isGenerating
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating invoice...'),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isGenerating = true;
                            _error = null;
                          });
                          _generatePdf();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: PdfPreview(
                        build: (_) => _pdfFile!.readAsBytes(),
                        allowSharing: false,
                        allowPrinting: false,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        canDebug: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _sharePdf,
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<CartBloc>().add(ClearCart());
                                context.go('/');
                              },
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Done'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
