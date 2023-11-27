sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success({this.data});
  final T? data;
}

class Failure<T> extends Result<T> {
  const Failure({required this.message});
  final String message;
}
