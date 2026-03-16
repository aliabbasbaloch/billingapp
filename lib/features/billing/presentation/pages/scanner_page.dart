import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:billingapp/features/billing/presentation/bloc/cart_bloc.dart';
import 'package:billingapp/features/product/presentation/bloc/product_bloc.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';
import 'package:billingapp/core/service_locator.dart';
import 'package:billingapp/features/product/domain/usecases/product_usecases.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController? _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(String barcode) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await _controller?.stop();

    final result = await sl<GetProductByBarcode>()(barcode);

    result.fold(
      (failure) {
        _showError(failure.message);
        setState(() => _isProcessing = false);
      },
      (product) {
        if (product != null) {
          context.read<CartBloc>().add(AddToCart(product));
          _showAddedSnackBar(product.name);
          context.pop();
        } else {
          _showNotFoundDialog(barcode);
        }
      },
    );
  }

  void _showAddedSnackBar(String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showNotFoundDialog(String barcode) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Product Not Found'),
        content:
            Text('No product found with barcode: $barcode\nWould you like to add it?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isProcessing = false);
              _controller?.start();
            },
            child: const Text('Scan Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/products/add');
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller?.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => _controller?.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull?.rawValue;
              if (barcode != null && !_isProcessing) {
                _onBarcodeDetected(barcode);
              }
            },
          ),
          // Scanning overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Align barcode within the frame',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
