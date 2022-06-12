import 'package:flutter/material.dart';

Future<void> showFilterModal(BuildContext context) => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => const FilterModal(),
    );

class FilterModal extends StatelessWidget {
  const FilterModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("SEARCH!"));
  }
}
