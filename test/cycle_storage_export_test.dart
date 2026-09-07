import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritim/core/services/cycle_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('importFromFile bozuk/geçersiz JSON için null döner, çökmez', () async {
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/ritim-bozuk-test.json');
    await file.writeAsString('bu geçerli bir json değil {{{');
    addTearDown(() => file.delete());

    final imported = await CycleStorageService.importFromFile(file);
    expect(imported, isNull);
  });
}
