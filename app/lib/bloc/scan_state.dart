import 'package:equatable/equatable.dart';

/// State for the scan flow: current image path and optional analysis result.
class ScanState extends Equatable {
  final String? imagePath;
  final double? imtMm;
  final bool? isHighRisk;

  const ScanState({
    this.imagePath,
    this.imtMm,
    this.isHighRisk,
  });

  const ScanState.initial() : this();

  ScanState copyWith({
    String? imagePath,
    double? imtMm,
    bool? isHighRisk,
  }) {
    return ScanState(
      imagePath: imagePath ?? this.imagePath,
      imtMm: imtMm ?? this.imtMm,
      isHighRisk: isHighRisk ?? this.isHighRisk,
    );
  }

  @override
  List<Object?> get props => [imagePath, imtMm, isHighRisk];
}
