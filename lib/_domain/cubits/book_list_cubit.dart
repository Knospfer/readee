import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/entities/filter_book_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/use_cases/filter_use_case.dart';

@injectable
class BookCubit extends Cubit<List<BookModel>> {
  final FilterUseCase _filterUseCase;
  StreamSubscription? _subscription;

  BookCubit( this._filterUseCase) : super([]) {
    _init();
  }

  void search(FilterBookEntity? filter) {
    if (filter == null) return _init();
    final stream = _filterUseCase.search(filter);

    _subscription?.cancel();
    _subscription = stream.listen(
      (event) => emit(event.where((e) => e.owned == filter.owned).toList()),
    );
  }

  void _init() {
    if (_subscription != null) _subscription?.cancel();
    _subscription = _filterUseCase.initialStream().listen((event) => emit(event));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
