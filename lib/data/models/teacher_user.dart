import 'package:engelsiz_admin/ui/screens/add_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_user.freezed.dart';
part 'teacher_user.g.dart';

@freezed
class TeacherUser with _$TeacherUser {
  const factory TeacherUser(
      {required final String fullName,
      required final String email,
      required final String phoneNumber,
      required final String tc,
      required final Gender gender,
      @Default(Role.teacher) Role role}) = _TeacherUser;

  factory TeacherUser.fromJson(Map<String, Object?> json) =>
      _$TeacherUserFromJson(json);
}
