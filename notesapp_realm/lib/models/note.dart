import 'package:realm/realm.dart';

part 'note.realm.dart';

@RealmModel()
class _Note {
  late String title;
  late String content;
  DateTime? date;
}
