import 'package:equatable/equatable.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/data/model/branch_model.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object?> get props => [];
}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<BranchModel> branches;
  const BranchLoaded(this.branches);

  @override
  List<Object?> get props => [branches];
}

class SingleBranchLoaded extends BranchState {
  final BranchModel branch;
  const SingleBranchLoaded(this.branch);

  @override
  List<Object?> get props => [branch];
}

class BranchOperationSuccess extends BranchState {
  final String message;
  const BranchOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BranchError extends BranchState {
  final String message;
  const BranchError(this.message);

  @override
  List<Object?> get props => [message];
}
