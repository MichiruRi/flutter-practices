// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Location extends _Location
    with RealmEntity, RealmObjectBase, RealmObject {
  Location(
    String region,
    String province,
    String city,
  ) {
    RealmObjectBase.set(this, 'region', region);
    RealmObjectBase.set(this, 'province', province);
    RealmObjectBase.set(this, 'city', city);
  }

  Location._();

  @override
  String get region => RealmObjectBase.get<String>(this, 'region') as String;
  @override
  set region(String value) => RealmObjectBase.set(this, 'region', value);

  @override
  String get province =>
      RealmObjectBase.get<String>(this, 'province') as String;
  @override
  set province(String value) => RealmObjectBase.set(this, 'province', value);

  @override
  String get city => RealmObjectBase.get<String>(this, 'city') as String;
  @override
  set city(String value) => RealmObjectBase.set(this, 'city', value);

  @override
  Stream<RealmObjectChanges<Location>> get changes =>
      RealmObjectBase.getChanges<Location>(this);

  @override
  Stream<RealmObjectChanges<Location>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Location>(this, keyPaths);

  @override
  Location freeze() => RealmObjectBase.freezeObject<Location>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'region': region.toEJson(),
      'province': province.toEJson(),
      'city': city.toEJson(),
    };
  }

  static EJsonValue _toEJson(Location value) => value.toEJson();
  static Location _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'region': EJsonValue region,
        'province': EJsonValue province,
        'city': EJsonValue city,
      } =>
        Location(
          fromEJson(region),
          fromEJson(province),
          fromEJson(city),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Location._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Location, 'Location', [
      SchemaProperty('region', RealmPropertyType.string),
      SchemaProperty('province', RealmPropertyType.string),
      SchemaProperty('city', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
