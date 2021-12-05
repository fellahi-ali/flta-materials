import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('path to app dir', () async {
    final userDir = await getApplicationDocumentsDirectory();
    print(userDir.uri);
  });
}
