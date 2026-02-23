import 'package:flutter_bloc/flutter_bloc.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(const ScanState.initial()) {
    on<ScanImageSelected>(_onImageSelected);
    on<ScanCleared>(_onCleared);
    on<ScanAnalysisResultUpdated>(_onAnalysisResultUpdated);
  }

  void _onImageSelected(ScanImageSelected event, Emitter<ScanState> emit) {
    emit(state.copyWith(
      imagePath: event.imagePath,
      imtMm: null,
      isHighRisk: null,
    ));
  }

  void _onCleared(ScanCleared event, Emitter<ScanState> emit) {
    emit(const ScanState.initial());
  }

  void _onAnalysisResultUpdated(
    ScanAnalysisResultUpdated event,
    Emitter<ScanState> emit,
  ) {
    emit(state.copyWith(
      imtMm: event.imtMm,
      isHighRisk: event.isHighRisk,
    ));
  }
}
