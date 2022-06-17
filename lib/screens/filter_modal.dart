import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:readee/_domain/entities/filter_book_entity.dart';

Future<void> showFilterModal(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (_) => const FilterModal(),
    );

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final form = FormGroup({
    'name': FormControl<String>(value: ''),
    'wishlisted': FormControl<bool>(value: false),
    'owned': FormControl<bool>(value: false),
  });

  void _submit(BuildContext context, FormGroup formGroup) {
    final name = formGroup.control('name').value as String;
    final wishlisted = formGroup.control('wishlisted').value as bool;
    final owned = formGroup.control('owned').value as bool;

    final isFormEmpty = name.isEmpty && !wishlisted && !owned;
    final filter = isFormEmpty
        ? null
        : FilterBookEntity(
            name: name,
            wishlisted: wishlisted,
            owned: owned,
          );

    context.router.pop(filter);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: ReactiveTextField(
                formControlName: 'name',
                decoration: const InputDecoration(
                  hintText: 'Harry Potter..',
                  labelText: 'Title',
                ),
              ),
            ),
            ReactiveCheckboxListTile(
              title: const Text("In Wishlist"),
              formControlName: "wishlisted",
            ),
            ReactiveCheckboxListTile(
              title: const Text("Owned"),
              formControlName: "owned",
            ),
            Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 8),
              child: ReactiveFormConsumer(
                builder: (context, form, _) => ElevatedButton(
                  onPressed: () => _submit(context, form),
                  child: const Text("Search!"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () => context.router.pop(),
                child: const Text("Reset"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
