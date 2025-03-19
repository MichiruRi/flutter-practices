import 'package:realm/realm.dart';

part 'location.realm.dart';

@RealmModel()
class _Location {
  late String region;
  late String province;
  late String city;
}
