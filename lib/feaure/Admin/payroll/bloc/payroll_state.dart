import '../data/model/payroll_model.dart';

abstract class PayrollState {}

class PayrollInitial extends PayrollState {}

class PayrollLoading extends PayrollState {}

class PayrollLoaded extends PayrollState {
  final PayrollSummaryModel summary;
  final List<PayrollModel> payrolls;

  PayrollLoaded({required this.summary, required this.payrolls});
}

class PayrollError extends PayrollState {
  final String message;

  PayrollError(this.message);
}

class PayrollPreviewLoading extends PayrollState {}

class PayrollPreviewLoaded extends PayrollState {
  final List<PayrollPreviewModel> previews;
  PayrollPreviewLoaded(this.previews);
}

class PayrollProcessLoading extends PayrollState {}

class PayrollProcessedSuccess extends PayrollState {}
