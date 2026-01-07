// WEEK 6–7: CAMERA BASED PPG PROVIDER (WITH CAMERA SWITCHING)
import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// =======================
/// STATE
/// =======================
class PpgState {
  final bool capturing;
  final List<double> samples;
  final double mean;
  final double variance;
  final CameraController? controller;
  final bool isFrontCamera;
  final String? errorMessage;

  PpgState({
    required this.capturing,
    required this.samples,
    required this.mean,
    required this.variance,
    this.controller,
    this.isFrontCamera = false,
    this.errorMessage,
  });

  PpgState copyWith({
    bool? capturing,
    List<double>? samples,
    double? mean,
    double? variance,
    CameraController? controller,
    bool? isFrontCamera,
    String? errorMessage,
  }) {
    return PpgState(
      capturing: capturing ?? this.capturing,
      samples: samples ?? this.samples,
      mean: mean ?? this.mean,
      variance: variance ?? this.variance,
      controller: controller ?? this.controller,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// =======================
/// PROVIDER
/// =======================
final ppgProvider = StateNotifierProvider<PpgNotifier, PpgState>((ref) {
  return PpgNotifier();
});

/// =======================
/// NOTIFIER
/// =======================
class PpgNotifier extends StateNotifier<PpgState> {
  PpgNotifier()
      : super(
          PpgState(
            capturing: false,
            samples: [],
            mean: 0,
            variance: 0,
            controller: null,
            isFrontCamera: false,
            errorMessage: null,
          ),
        );

  CameraController? _controller;
  List<CameraDescription>? _availableCameras;
  CameraDescription? _frontCamera;
  CameraDescription? _backCamera;

  /// =======================
  /// INITIALIZE CAMERAS LIST
  /// =======================
  Future<void> _initializeCameras() async {
    try {
      if (_availableCameras == null) {
        _availableCameras = await availableCameras();

        for (var camera in _availableCameras!) {
          if (camera.lensDirection == CameraLensDirection.front) {
            _frontCamera = camera;
          } else if (camera.lensDirection == CameraLensDirection.back) {
            _backCamera = camera;
          }
        }

        if (_backCamera == null && _frontCamera != null) {
          _backCamera = _frontCamera;
        }
      }
    } catch (e) {
      print("Error initializing cameras: $e");
      state = state.copyWith(errorMessage: "Failed to initialize cameras: $e");
    }
  }

  /// =======================
  /// START CAMERA + PPG (DEFAULT BELAKANG)
  /// =======================
  Future<void> startCapture() async {
    state = state.copyWith(errorMessage: null);

    try {
      if (state.capturing) {
        await _safeStopCapture();
      }

      await _initializeCameras();

      CameraDescription? selectedCamera = _backCamera ?? _frontCamera;

      if (selectedCamera == null) {
        throw Exception("No camera available");
      }

      await _safeDisposeController();

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _controller!.initialize();

      state = state.copyWith(
        capturing: true,
        controller: _controller,
        isFrontCamera: selectedCamera.lensDirection == CameraLensDirection.front,
        samples: [],
        mean: 0,
        variance: 0,
        errorMessage: null,
      );

      _controller!.startImageStream(_processImage);
    } catch (e) {
      print("Error starting camera: $e");
      await _safeDisposeController();
      state = state.copyWith(
        capturing: false,
        errorMessage: "Failed to start camera: ${e.toString()}",
      );
    }
  }

  /// =======================
  /// SWITCH CAMERA
  /// =======================
  Future<void> switchCamera() async {
    if (!state.capturing) return;

    try {
      await _safeStopCapture();

      await _initializeCameras();

      CameraDescription? selectedCamera;
      if (state.isFrontCamera) {
        selectedCamera = _backCamera ?? _frontCamera;
      } else {
        selectedCamera = _frontCamera ?? _backCamera;
      }

      if (selectedCamera == null) {
        throw Exception("No camera available");
      }

      await _safeDisposeController();

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _controller!.initialize();

      state = state.copyWith(
        controller: _controller,
        isFrontCamera: selectedCamera.lensDirection == CameraLensDirection.front,
        errorMessage: null,
      );

      _controller!.startImageStream(_processImage);
    } catch (e) {
      print("Error switching camera: $e");
      state = state.copyWith(
        errorMessage: "Failed to switch camera: ${e.toString()}",
      );
    }
  }

  /// =======================
  /// IMAGE PROCESSING
  /// =======================
  void _processImage(CameraImage image) {
    try {
      if (!state.capturing) return;

      final buffer = image.planes[0].bytes;

      double sum = 0;
      int count = 0;

      for (int i = 0; i < buffer.length; i += 50) {
        sum += buffer[i];
        count++;
      }

      if (count == 0) return;

      final meanY = sum / count;

      final newSamples = [...state.samples, meanY];
      if (newSamples.length > 300) {
        newSamples.removeAt(0);
      }

      final mean = newSamples.reduce((a, b) => a + b) / newSamples.length;

      final variance = newSamples.fold(0.0, (s, x) => s + pow(x - mean, 2)) /
          max(1, newSamples.length - 1);

      state = state.copyWith(
        samples: newSamples,
        mean: mean,
        variance: variance,
      );
    } catch (e) {
      print("Error processing image: $e");
    }
  }

  /// =======================
  /// SAFE STOP CAPTURE
  /// =======================
  Future<void> _safeStopCapture() async {
    try {
      if (_controller != null && state.capturing) {
        await _controller!.stopImageStream();
      }
    } catch (e) {
      print("Error stopping image stream: $e");
    }
  }

  /// =======================
  /// SAFE DISPOSE CONTROLLER
  /// =======================
  Future<void> _safeDisposeController() async {
    try {
      await _safeStopCapture();

      if (_controller != null) {
        try {
          await _controller!.dispose();
        } catch (e) {
          print("Error disposing controller: $e");
        } finally {
          _controller = null;
        }
      }
    } catch (e) {
      print("Error in safe dispose: $e");
    }
  }

  /// =======================
  /// STOP CAPTURE
  /// =======================
  Future<void> stopCapture() async {
    try {
      await _safeDisposeController();

      state = state.copyWith(
        capturing: false,
        controller: null,
        errorMessage: null,
      );

      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      print("Error in stopCapture: $e");
      state = state.copyWith(
        capturing: false,
        controller: null,
        errorMessage: "Error stopping camera: ${e.toString()}",
      );
    }
  }

  /// =======================
  /// CLEAR SAMPLES DATA
  /// =======================
  void clearSamples() {
    state = state.copyWith(
      samples: [],
      mean: 0,
      variance: 0,
      errorMessage: null,
    );
  }

  /// =======================
  /// CLEAR ERROR
  /// =======================
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _safeDisposeController();
    super.dispose();
  }
}