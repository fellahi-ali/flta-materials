import 'package:test/test.dart';

void main() {
  test('uri parse', () {
    final url = Uri(host: 'localhost.com', queryParameters: {'test': 'test'});
    print(url);
  });
}
