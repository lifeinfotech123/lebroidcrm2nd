abstract class PerformanceEvent {}

// ── Performance Rating Events ──
class FetchPerformances extends PerformanceEvent {
  final String? month;
  final String? year;
  final int? userId;
  FetchPerformances({this.month, this.year, this.userId});
}

class FetchPerformanceById extends PerformanceEvent {
  final int id;
  FetchPerformanceById(this.id);
}

class CreatePerformance extends PerformanceEvent {
  final Map<String, dynamic> data;
  CreatePerformance(this.data);
}

class UpdatePerformance extends PerformanceEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdatePerformance(this.id, this.data);
}

class DeletePerformance extends PerformanceEvent {
  final int id;
  DeletePerformance(this.id);
}

// ── Goal Events ──
class FetchGoals extends PerformanceEvent {}

class FetchGoalById extends PerformanceEvent {
  final int id;
  FetchGoalById(this.id);
}

class CreateGoal extends PerformanceEvent {
  final Map<String, dynamic> data;
  CreateGoal(this.data);
}

class UpdateGoal extends PerformanceEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateGoal(this.id, this.data);
}

class DeleteGoal extends PerformanceEvent {
  final int id;
  DeleteGoal(this.id);
}
