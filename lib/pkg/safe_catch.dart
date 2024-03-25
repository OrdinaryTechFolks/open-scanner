
import 'package:either_dart/either.dart';

Future<Either<Object, T>> safeCatchFuture<T>(Future<T> Function() func) async {
  try {
    return Right(await func());
  } catch (err) {
    return Left(err);
  }
}