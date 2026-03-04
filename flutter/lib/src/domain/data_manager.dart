import 'dart:collection';

import 'package:catotinder/src/domain/cat.dart';

/// Хранение данных о котах (очередь показов).
class CatDataManager {
  final _queue = Queue<Cat>();

  Queue<Cat> get queue {
    return _queue;
  }
}

/// Хранение данных о породах котов.
class BreedDataManager {
  final List<Breed> _list = [];

  List<Breed> get list {
    return _list;
  }
}
