import 'package:equatable/equatable.dart';
import '../data/model/break_model.dart';

abstract class BreakState extends Equatable {
  const BreakState();

  @override
  List<Object?> get props => [];
}

class BreakInitial extends BreakState {}

class BreakLoading extends BreakState {}

class BreaksLoaded extends BreakState {
  final List<BreakRecord> breaks;
  final List<BreakType> breakTypes;
  const BreaksLoaded({required this.breaks, this.breakTypes = const []});

  @override
  List<Object?> get props => [breaks, breakTypes];
}

class BreakActionSuccess extends BreakState {
  final String message;
  const BreakActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BreakError extends BreakState {
  final String message;
  const BreakError(this.message);

  @override
  List<Object?> get props => [message];
}
