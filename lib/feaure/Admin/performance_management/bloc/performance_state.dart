import '../data/model/performance_model.dart';

abstract class PerformanceState {}

class PerformanceInitial extends PerformanceState {}

class PerformanceLoading extends PerformanceState {}

// ── Performance Rating States ──
class PerformancesLoaded extends PerformanceState {
  final List<PerformanceModel> performances;
  PerformancesLoaded(this.performances);
}

class PerformanceDetailLoaded extends PerformanceState {
  final PerformanceModel performance;
  PerformanceDetailLoaded(this.performance);
}

// ── Goal States ──
class GoalsLoaded extends PerformanceState {
  final List<GoalModel> goals;
  GoalsLoaded(this.goals);
}

class GoalDetailLoaded extends PerformanceState {
  final GoalModel goal;
  GoalDetailLoaded(this.goal);
}

// ── Common States ──
class PerformanceOperationSuccess extends PerformanceState {
  final String message;
  PerformanceOperationSuccess(this.message);
}

class PerformanceError extends PerformanceState {
  final String message;
  PerformanceError(this.message);
}
