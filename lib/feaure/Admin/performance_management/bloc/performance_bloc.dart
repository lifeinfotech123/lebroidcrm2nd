import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/performance_repository.dart';
import 'performance_event.dart';
import 'performance_state.dart';

class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  final PerformanceRepository _repository;

  PerformanceBloc(this._repository) : super(PerformanceInitial()) {

    // ── Performance Rating Handlers ──

    on<FetchPerformances>((event, emit) async {
      emit(PerformanceLoading());
      try {
        final performances = await _repository.getAllPerformances(
          month: event.month,
          year: event.year,
          userId: event.userId,
        );
        emit(PerformancesLoaded(performances));
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<FetchPerformanceById>((event, emit) async {
      emit(PerformanceLoading());
      try {
        final performance = await _repository.getPerformanceById(event.id);
        emit(PerformanceDetailLoaded(performance));
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<CreatePerformance>((event, emit) async {
      emit(PerformanceLoading());
      try {
        await _repository.createPerformance(event.data);
        emit(PerformanceOperationSuccess("Performance rating saved."));
        add(FetchPerformances());
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<UpdatePerformance>((event, emit) async {
      emit(PerformanceLoading());
      try {
        await _repository.updatePerformance(event.id, event.data);
        emit(PerformanceOperationSuccess("Performance rating updated."));
        add(FetchPerformances());
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<DeletePerformance>((event, emit) async {
      emit(PerformanceLoading());
      try {
        await _repository.deletePerformance(event.id);
        emit(PerformanceOperationSuccess("Performance rating deleted."));
        add(FetchPerformances());
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    // ── Goal Handlers ──

    on<FetchGoals>((event, emit) async {
      emit(PerformanceLoading());
      try {
        final goals = await _repository.getAllGoals();
        emit(GoalsLoaded(goals));
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<FetchGoalById>((event, emit) async {
      emit(PerformanceLoading());
      try {
        final goal = await _repository.getGoalById(event.id);
        emit(GoalDetailLoaded(goal));
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<CreateGoal>((event, emit) async {
      emit(PerformanceLoading());
      try {
        await _repository.createGoal(event.data);
        emit(PerformanceOperationSuccess("Goal created successfully."));
        add(FetchGoals());
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<UpdateGoal>((event, emit) async {
      emit(PerformanceLoading());
      try {
        await _repository.updateGoal(event.id, event.data);
        emit(PerformanceOperationSuccess("Goal updated successfully."));
        add(FetchGoals());
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });

    on<DeleteGoal>((event, emit) async {
      emit(PerformanceLoading());
      try {
        await _repository.deleteGoal(event.id);
        emit(PerformanceOperationSuccess("Goal deleted successfully."));
        add(FetchGoals());
      } catch (e) {
        emit(PerformanceError(e.toString()));
      }
    });
  }
}
