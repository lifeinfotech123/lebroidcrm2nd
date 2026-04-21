import 'package:equatable/equatable.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object?> get props => [];
}

class LoadBranchesEvent extends BranchEvent {}

class FetchSingleBranchEvent extends BranchEvent {
  final int id;
  const FetchSingleBranchEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddBranchEvent extends BranchEvent {
  final Map<String, dynamic> branchData;
  const AddBranchEvent(this.branchData);

  @override
  List<Object?> get props => [branchData];
}

class UpdateBranchEvent extends BranchEvent {
  final int id;
  final Map<String, dynamic> branchData;
  const UpdateBranchEvent(this.id, this.branchData);

  @override
  List<Object?> get props => [id, branchData];
}

class DeleteBranchEvent extends BranchEvent {
  final int branchId;
  const DeleteBranchEvent(this.branchId);

  @override
  List<Object?> get props => [branchId];
}
