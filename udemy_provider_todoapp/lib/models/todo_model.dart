// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

///Todo들의 상태를 구분짓기 위한 enum
enum Filter { all, active, completed }

//Todo 클래스의 기능
//1. 새로운 Todo를 만들 떄 -> Unique한 id
//2. 기존 Todo를 edit 할 때 -> 기존 id 이용

Uuid uuid = const Uuid();

class Todo {
  final String id;
  final String description;
  final bool isCompleted;

  Todo({String? id, required this.description, this.isCompleted = false})
      : id = id ?? uuid.v4();

  @override
  String toString() =>
      'Todo(id: $id, description: $description, isCompleted: $isCompleted)';

  ///equatable
  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.isCompleted == isCompleted;
  }

  ///human readable한 형태로 변경하기 위해
  @override
  int get hashCode => id.hashCode ^ description.hashCode ^ isCompleted.hashCode;
}
