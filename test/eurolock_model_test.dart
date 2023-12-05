import 'package:eurokey2/models/eurolock_model.dart';
import 'package:test/test.dart';

void main() {
  final eurolocks = EurolockModel();

  test('XLS file should be loaded', () async {
    await eurolocks.onInitApp();

    expect(eurolocks.locationsList.isNotEmpty, true);
  });

  test('the itemList should be populated', () async {
    eurolocks.buildItemList();

    expect(eurolocks.itemList.isNotEmpty, true);
  });
}
