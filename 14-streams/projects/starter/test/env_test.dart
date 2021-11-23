import 'package:recipes/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('read api key & id from env', () {
    expect(Env.edamamKey, isNotEmpty);
    expect(Env.edamamKey, isNotEmpty);
  });
}
