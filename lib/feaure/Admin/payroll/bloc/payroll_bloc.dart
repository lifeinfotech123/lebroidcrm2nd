import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/payroll_repository.dart';
import 'payroll_event.dart';
import 'payroll_state.dart';

class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  final PayrollRepository _repository;

  PayrollBloc(this._repository) : super(PayrollInitial()) {
    on<FetchPayrollData>((event, emit) async {
      emit(PayrollLoading());
      try {
        final summaryTask = _repository.getPayrollSummary(month: event.month);
        final payrollsTask = _repository.getPayrolls(
          month: event.month,
          status: event.status,
          search: event.search,
        );

        final results = await Future.wait([summaryTask, payrollsTask]);
        
        emit(PayrollLoaded(
          summary: results[0] as dynamic,
          payrolls: results[1] as dynamic,
        ));
      } catch (e) {
        emit(PayrollError(e.toString()));
      }
    });

    on<GeneratePayrollPreview>((event, emit) async {
      emit(PayrollPreviewLoading());
      try {
        final previews = await _repository.getPayrollPreview(
          month: event.month,
          branchId: event.branchId,
          deptId: event.deptId,
        );
        emit(PayrollPreviewLoaded(previews));
      } catch (e) {
        emit(PayrollError(e.toString()));
      }
    });

    on<ProcessPayrollEvent>((event, emit) async {
      emit(PayrollProcessLoading());
      try {
        final previewsPayload = event.previews.map((p) => {
          'user_id': p.userId,
          'net_pay': p.netPay,
        }).toList();

        await _repository.processPayroll(
          month: event.month, 
          previews: previewsPayload,
        );
        emit(PayrollProcessedSuccess());
      } catch (e) {
        emit(PayrollError(e.toString()));
      }
    });
  }
}
