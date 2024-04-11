
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

class Snapshot<T> {
  final bool loading;
  final Error? error;
  final T? _result;

  const Snapshot(this.loading, this.error, this._result);

  T get result => _result!;

  static Snapshot<T> init<T>() {
    return Snapshot<T>(false, null, null);
  }

  static Snapshot<T> isLoading<T>() {
    return Snapshot<T>(true, null, null);
  }

  static Snapshot<T> hasError<T>(Error err) {
    return Snapshot<T>(false, err, null);
  }

  static Snapshot<T> hasResult<T>(T result) {
    return Snapshot<T>(false, null, result);
  }
}

class UseFuture<T, U> {
  final ValueNotifier<Snapshot<T>> snapshot = ValueNotifier(Snapshot.init<T>());
  final Future<Either<Error, T>> Function(U param) func;

  UseFuture(this.func);

  Future<void> execute(U param) async {
    snapshot.value = Snapshot.isLoading<T>();
    final res = await func(param);
    if (res.isLeft) {
      snapshot.value = Snapshot.hasError<T>(res.left);
      return;
    }
    snapshot.value = Snapshot.hasResult<T>(res.right);
  }
}