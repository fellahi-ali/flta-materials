abstract class Result<T> {}

class Success<T> extends Result<T> {
  Success(this.value);
  final T value;
}

class Faileur<T> extends Result<T> {
  Faileur(this.exception);
  final Exception exception;
}
