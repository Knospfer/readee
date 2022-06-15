import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/entities/filter_book_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';

@injectable
class BookCubit extends Cubit<List<BookModel>> {
  final BookRepository _repository;
  StreamSubscription? _subscription;

  BookCubit(this._repository) : super([]) {
    _init();
  }

  void search(FilterBookEntity? filter) {
    if (filter == null) return _init();
    final bookName = filter.name;
    if (bookName == null || bookName.isEmpty) return _init();

    _subscription?.cancel();
    _subscription = _repository.query(bookName).listen((event) => emit(event));
  }

  void _init() {
    if (_subscription != null) _subscription?.cancel();
    _subscription = _repository.stream().listen((event) => emit(event));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
