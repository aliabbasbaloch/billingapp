import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String label;
  final bool required;

  const InputLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          if (required)
            const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
