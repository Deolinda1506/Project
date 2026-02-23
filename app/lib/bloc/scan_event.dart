import 'package:equatable/equatable.dart';

/// Events for the scan flow (captured/selected image and optional analysis result).
abstract class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

/// User selected or captured an image for analysis.
class ScanImageSelected extends ScanEvent {
  final String imagePath;

  const ScanImageSelected(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// Clear current scan (e.g. when starting a new scan).
class ScanCleared extends ScanEvent {
  const ScanCleared();
}

/// Optional: when backend is connected, set IMT and risk from API.
class ScanAnalysisResultUpdated extends ScanEvent {
  final double? imtMm;
  final bool? isHighRisk;

  const ScanAnalysisResultUpdated({this.imtMm, this.isHighRisk});

  @override
  List<Object?> get props => [imtMm, isHighRisk];
}
