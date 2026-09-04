import 'package:flutter_test/flutter_test.dart';
import 'package:ritim/core/providers/cycle_provider.dart';

Map<String, DailyLog> _logsForDaysAgo(List<int> daysAgo) {
  final now = DateTime.now();
  return {
    for (final d in daysAgo)
      '${_date(now, d).year}-${_date(now, d).month}-${_date(now, d).day}': const DailyLog(mood: 'İyi'),
  };
}

DateTime _date(DateTime now, int daysAgo) => now.subtract(Duration(days: daysAgo));

void main() {
  test('hiç kayıt yoksa seri 0', () {
    expect(const CycleState().currentStreak, 0);
  });

  test('sadece bugün kayıtlıysa seri 1', () {
    final state = CycleState(logs: _logsForDaysAgo([0]));
    expect(state.currentStreak, 1);
  });

  test('bugün + dün + evvelsi gün art arda -> seri 3', () {
    final state = CycleState(logs: _logsForDaysAgo([0, 1, 2]));
    expect(state.currentStreak, 3);
  });

  test('bugün henüz kayıt yok ama dün vardı -> seri kırılmış sayılmaz, dünden sayılır', () {
    final state = CycleState(logs: _logsForDaysAgo([1, 2]));
    expect(state.currentStreak, 2);
  });

  test('arada boşluk varsa seri en yakın kesintisiz bloğu sayar', () {
    // Bugün, dün var; 2 gün önce boşluk; 3-4 gün önce var ama kopuk.
    final state = CycleState(logs: _logsForDaysAgo([0, 1, 3, 4]));
    expect(state.currentStreak, 2);
  });

  test('ne bugün ne dün kayıt yoksa seri 0', () {
    final state = CycleState(logs: _logsForDaysAgo([3, 4]));
    expect(state.currentStreak, 0);
  });
}
