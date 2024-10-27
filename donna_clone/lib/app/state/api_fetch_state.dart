import 'package:equatable/equatable.dart';

sealed class ApiFetchState<T> extends Equatable {
  const ApiFetchState();

  @override
  List<Object?> get props => [];
}

final class ApiFetchInitial<T> extends ApiFetchState<T> {
  const ApiFetchInitial();
}

final class ApiFetchLoading<T> extends ApiFetchState<T> {}

final class ApiFetchSuccess<T> extends ApiFetchState<T> {
  final T data;

  const ApiFetchSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class ApiFetchFailure<T> extends ApiFetchState<T> {
  final String? error;
  final int? statusCode;

  const ApiFetchFailure({this.error, this.statusCode});

  @override
  List<Object?> get props => [error, statusCode];
}
