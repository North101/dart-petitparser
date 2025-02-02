import '../core/exception.dart';
import 'result.dart';

/// An immutable parse result in case of a failed parse.
class Failure<R> extends Result<R> {
  const Failure(super.buffer, super.position, this.message, [super.start = 0]);

  @override
  bool get isFailure => true;

  @override
  R get value => throw ParserException(this);

  @override
  final String message;

  @override
  Result<T> map<T>(T Function(R element) callback) =>
      failure(message, position, start);

  @override
  String toString() => 'Failure[${toPositionString()}]: $message';
}
