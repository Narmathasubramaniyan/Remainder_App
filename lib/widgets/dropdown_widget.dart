import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const DropdownWidget({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: DropdownButton<T>(
            hint: const Text('Select'),
            iconSize: 36,
            icon: const Icon(
              Icons.arrow_drop_down_circle_rounded,
              color: Color.fromARGB(255, 95, 93, 76),
            ),
            isExpanded: true,
            value: value,
            onChanged: onChanged,
            items: items,
          ),
        ),
      ],
    );
  }
}
