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
              padding: const EdgeInsets.all(16).copyWith(bottom: 0, top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Search books",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ReactiveFormConsumer(
                    builder: (context, form, _) => IconButton(
                      onPressed: () => _submit(context, form),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(bottom: 24),
              child: ReactiveTextField(
                formControlName: 'name',
                decoration: const InputDecoration(
                  hintText: 'Harry Potter..',
                  labelText: 'Title',
                ),
              ),
            ),
            const _FilterListTile(
              title: "In Wishlist",
              formControlName: "wishlisted",
            ),
            const _FilterListTile(
              title: "Owned",
              formControlName: "owned",
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(16),
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

class _FilterListTile extends StatelessWidget {
  final String formControlName;
  final String title;

  const _FilterListTile({required this.formControlName, required this.title});

  @override
  Widget build(BuildContext context) {
    return ReactiveCheckboxListTile(
      title: Text(title),
      formControlName: formControlName,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.only(right: 16, left: 6),
    );
  }
}
