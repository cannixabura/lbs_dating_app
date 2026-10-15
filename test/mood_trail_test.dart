import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/mood_trail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('same mood at the same place is recorded once', () async {
    await MoodTrail.record('平靜地散步🌿', 25.0330, 121.5654);
    await MoodTrail.record('平靜地散步🌿', 25.0331, 121.5655); // ~15 m away
    expect((await MoodTrail.entries()).length, 1);
  });

  test('a new mood or a new place adds a point', () async {
    await MoodTrail.record('平靜地散步🌿', 25.0330, 121.5654);
    await MoodTrail.record('好開心', 25.0330, 121.5654);       // mood changed
    await MoodTrail.record('好開心', 25.0400, 121.5654);       // ~780 m away
    expect((await MoodTrail.entries()).length, 3);
  });

  test('nothing is recorded when the trail is turned off', () async {
    await MoodTrail.setEnabled(false);
    await MoodTrail.record('好開心', 25.0330, 121.5654);
    expect(await MoodTrail.entries(), isEmpty);
  });

  test('weekly recap: most frequent mood and distinct places', () async {
    await MoodTrail.record('平靜🌿', 25.0330, 121.5654);
    await MoodTrail.record('好開心', 25.0330, 121.5654);
    await MoodTrail.record('發呆中', 25.0500, 121.5654);
    await MoodTrail.record('平靜地看海', 25.0700, 121.5654);
    final r = MoodTrail.weeklyRecap(await MoodTrail.entries());
    expect(r.topMood, '平靜');
    expect(r.topCount, 3);
    expect(r.places, 3);
    expect(r.total, 4);
  });
}
