import 'package:news_flutter_app/core/error/failures.dart';

abstract class UiResult<T> {
  const UiResult();
}
class UiLoading<T> extends UiResult<T> {}

class UiSuccess<T> extends UiResult<T> {
  final T data;
  UiSuccess(this.data);
}

class UiError<T> extends UiResult<T> {
  final Failure failure;
  UiError(this.failure);
}

