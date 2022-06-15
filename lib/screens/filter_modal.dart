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
      builder: (_) => FilterModal(),
    );

class FilterModal extends StatelessWidget {
  final form = FormGroup({
    'name': FormControl<String>(value: ''),
    'wishlisted': FormControl<bool>(value: false),
  });

  FilterModal({super.key});

  void _submit(BuildContext context) {
    final name = form.control('name').value;
    final wishlisted = form.control('wishlisted').value;

    final isFormEmpty = name == null && wishlisted == false;
    final filter = isFormEmpty
        ? null
        : FilterBookEntity(
            name: name,
            wishlisted: wishlisted,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _submit(context),
                child: const Text("Search!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
