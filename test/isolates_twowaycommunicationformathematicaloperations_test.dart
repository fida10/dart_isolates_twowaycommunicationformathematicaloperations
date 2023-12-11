import 'package:isolates_twowaycommunicationformathematicaloperations/isolates_twowaycommunicationformathematicaloperations.dart';
import 'package:test/test.dart';

void main() {
  test('mathOperationInIsolate performs addition correctly', () async {
    var result = await mathOperationInIsolate(5, 3, 'add');
    expect(result, equals(8));
  });

  test('mathOperationInIsolate performs division', () async {
    var result = await mathOperationInIsolate(10, 2, 'divide');
    expect(result, equals(5));
  });

  test('mathOperationInIsolate handles division by zero', () async {
    var result = await mathOperationInIsolate(10, 0, 'divide');
    expect(result, isNull);
  });
}