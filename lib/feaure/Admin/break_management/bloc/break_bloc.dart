import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/break_model.dart';
import '../data/repository/break_repository.dart';
import 'break_event.dart';
import 'break_state.dart';

class BreakBloc extends Bloc<BreakEvent, BreakState> {
  final BreakRepository breakRepository;

  BreakBloc({required this.breakRepository}) : super(BreakInitial()) {
    on<FetchBreaks>(_onFetchBreaks);
    on<FetchBreakTypes>(_onFetchBreakTypes);
    on<CreateBreak>(_onCreateBreak);
    on<UpdateBreak>(_onUpdateBreak);
    on<DeleteBreak>(_onDeleteBreak);
  }

  Future<void> _onFetchBreaks(FetchBreaks event, Emitter<BreakState> emit) async {
    emit(BreakLoading());
    try {
      final breaks = await breakRepository.getBreaks();
      // We retrieve break types as well to keep state consistent if needed
      final types = await breakRepository.getBreakTypes();
      emit(BreaksLoaded(breaks: breaks, breakTypes: types));
    } catch (e) {
      emit(BreakError(e.toString()));
    }
  }

  Future<void> _onFetchBreakTypes(FetchBreakTypes event, Emitter<BreakState> emit) async {
    emit(BreakLoading());
    try {
      final types = await breakRepository.getBreakTypes();
      // We keep the current breaks in state if we're in BreaksLoaded state
      final currentBreaks = state is BreaksLoaded ? (state as BreaksLoaded).breaks : <BreakRecord>[];
      emit(BreaksLoaded(breaks: currentBreaks, breakTypes: types));
    } catch (e) {
      emit(BreakError(e.toString()));
    }
  }

  Future<void> _onCreateBreak(CreateBreak event, Emitter<BreakState> emit) async {
    emit(BreakLoading());
    try {
      await breakRepository.createBreak(event.data);
      emit(const BreakActionSuccess('Break created successfully.'));
      add(FetchBreaks());
    } catch (e) {
      emit(BreakError(e.toString()));
    }
  }

  Future<void> _onUpdateBreak(UpdateBreak event, Emitter<BreakState> emit) async {
    emit(BreakLoading());
    try {
      await breakRepository.updateBreak(event.id, event.data);
      emit(const BreakActionSuccess('Break updated successfully.'));
      add(FetchBreaks());
    } catch (e) {
      emit(BreakError(e.toString()));
    }
  }

  Future<void> _onDeleteBreak(DeleteBreak event, Emitter<BreakState> emit) async {
    emit(BreakLoading());
    try {
      final success = await breakRepository.deleteBreak(event.id);
      if (success) {
        emit(const BreakActionSuccess('Break deleted successfully.'));
        add(FetchBreaks());
      } else {
        emit(const BreakError('Failed to delete break.'));
      }
    } catch (e) {
      emit(BreakError(e.toString()));
    }
  }
}
