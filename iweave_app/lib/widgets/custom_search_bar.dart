import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;

  const CustomSearchBar({
    super.key,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: const Icon(Icons.tune_rounded),
      ),
    );
  }
}