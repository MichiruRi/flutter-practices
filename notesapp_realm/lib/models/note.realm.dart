// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Note extends _Note with RealmEntity, RealmObjectBase, RealmObject {
  Note(
    String title,
    String content, {
    DateTime? date,
  }) {
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'date', date);
  }

  Note._();

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get content => RealmObjectBase.get<String>(this, 'content') as String;
  @override
  set content(String value) => RealmObjectBase.set(this, 'content', value);

  @override
  DateTime? get date =>
      RealmObjectBase.get<DateTime>(this, 'date') as DateTime?;
  @override
  set date(DateTime? value) => RealmObjectBase.set(this, 'date', value);

  @override
  Stream<RealmObjectChanges<Note>> get changes =>
      RealmObjectBase.getChanges<Note>(this);

  @override
  Stream<RealmObjectChanges<Note>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Note>(this, keyPaths);

  @override
  Note freeze() => RealmObjectBase.freezeObject<Note>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'title': title.toEJson(),
      'content': content.toEJson(),
      'date': date.toEJson(),
    };
  }

  static EJsonValue _toEJson(Note value) => value.toEJson();
  static Note _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'title': EJsonValue title,
        'content': EJsonValue content,
      } =>
        Note(
          fromEJson(title),
          fromEJson(content),
          date: fromEJson(ejson['date']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Note._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Note, 'Note', [
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('date', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
