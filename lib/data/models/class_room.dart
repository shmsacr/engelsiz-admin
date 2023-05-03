import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_room.freezed.dart';
part 'class_room.g.dart';

@freezed
class Classroom with _$Classroom {
  @JsonSerializable(explicitToJson: true)
  const factory Classroom({
    required final String className,
    required final List<String> teachers,
    required final List<String> parents,
  }) = _ClassRoom;

  factory Classroom.fromJson(Map<String, Object?> json) =>
      _$ClassroomFromJson(json);
}
