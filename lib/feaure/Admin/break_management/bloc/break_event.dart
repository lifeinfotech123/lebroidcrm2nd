import 'package:equatable/equatable.dart';

abstract class BreakEvent extends Equatable {
  const BreakEvent();

  @override
  List<Object?> get props => [];
}

class FetchBreaks extends BreakEvent {}

class FetchBreakTypes extends BreakEvent {}

class CreateBreak extends BreakEvent {
  final Map<String, dynamic> data;
  const CreateBreak(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateBreak extends BreakEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateBreak(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteBreak extends BreakEvent {
  final int id;
  const DeleteBreak(this.id);

  @override
  List<Object?> get props => [id];
}
