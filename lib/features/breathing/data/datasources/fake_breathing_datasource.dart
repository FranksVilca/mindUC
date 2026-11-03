import '../models/breathing_session_model.dart';

/// Fuente de datos simulada en memoria para sesiones de respiración en tests.
class FakeBreathingDataSource {
  final List<BreathingSessionModel> _sessions = [];

  FakeBreathingDataSource([List<BreathingSessionModel>? initialSessions]) {
    if (initialSessions != null) {
      _sessions.addAll(initialSessions);
    }
  }

  Future<BreathingSessionModel> saveSession(BreathingSessionModel model) async {
    _sessions.add(model);
    return model;
  }

  Future<List<BreathingSessionModel>> getUserSessions(String userId) async {
    return _sessions.where((s) => s.userId == userId).toList()
      ..sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
  }

  void clear() {
    _sessions.clear();
  }
}
