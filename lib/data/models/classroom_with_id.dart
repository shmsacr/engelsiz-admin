import 'package:engelsiz_admin/data/models/class_room.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'classroom_with_id.freezed.dart';
part 'classroom_with_id.g.dart';

@freezed
class ClassroomWithId with _$ClassroomWithId {
  @JsonSerializable(explicitToJson: true)
  const factory ClassroomWithId({
    required String id,
    required Classroom classRoom,
  }) = _ClassroomWithId;

  factory ClassroomWithId.fromJson(Map<String, Object?> json) =>
      _$ClassroomWithIdFromJson(json);
}
