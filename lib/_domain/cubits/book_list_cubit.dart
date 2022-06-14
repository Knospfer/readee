import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';

@injectable
class BookCubit extends Cubit<List<BookModel>> {
  final BookRepository repository;
  late final StreamSubscription subscription;

  BookCubit(this.repository) : super([]) {
    subscription = repository.stream().listen((event) => emit(event));
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
