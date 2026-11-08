import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/whisper_engine.dart';

void main() {
  test('distance is shown in tiers, never as an exact number', () {
    expect(WhisperEngine.formatDistance(12), '100m 內');
    expect(WhisperEngine.formatDistance(99.9), '100m 內');
    expect(WhisperEngine.formatDistance(100), '100m');
    expect(WhisperEngine.formatDistance(137), '150m');
    expect(WhisperEngine.formatDistance(412), '400m');
    expect(WhisperEngine.formatDistance(980), '950m');
    expect(WhisperEngine.formatDistance(1000), '1.0km');
    expect(WhisperEngine.formatDistance(2345), '2.3km');
  });
}
