import 'package:equatable/equatable.dart';

abstract class CorrectionRequestState extends Equatable {
  const CorrectionRequestState();

  @override
  List<Object?> get props => [];
}

class CorrectionRequestInitial extends CorrectionRequestState {}

class CorrectionRequestSubmitting extends CorrectionRequestState {}

class CorrectionRequestSuccess extends CorrectionRequestState {
  final String message;
  const CorrectionRequestSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CorrectionRequestError extends CorrectionRequestState {
  final String message;
  const CorrectionRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
