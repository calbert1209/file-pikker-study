import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Page extends HiveObject {
  @HiveField(0)
  final String label;

  @HiveField(1)
  final String imageFilePath;

  Page(this.label, this.imageFilePath);

  static Page empty(int index) {
    return Page("item $index", null);
  }
}

class PageDatabase {
  static String _boxName = "pages";
  final Box _box;

  PageDatabase._(this._box);

  static Future<PageDatabase> init() async {
    var box = await Hive.openBox(_boxName);
    if (box.length < 5) {
      box.clear();
      var entries = [0, 1, 2, 3, 4]
        .map((item) => Page.empty(item))
        .toList()
        .asMap();
      await box.putAll(entries);
    }
    return PageDatabase._(box);
  }

  Page getAt(int index) {
    var key = this._box.keyAt(index);
    return this._box.get(key);
  }

  Future<void> setAt(int index, Page value) async {
    var key = this._box.keyAt(index);
    return this._box.put(key, value);
  }
}
