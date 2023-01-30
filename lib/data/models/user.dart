import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:engelsiz_admin/data/models/student.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User.teacher(
      {required final String fullName,
      required final String email,
      required final String phoneNumber,
      required final String tc,
      required final Gender gender,
      @Default(Role.teacher) Role role}) = Teacher;

  @JsonSerializable(explicitToJson: true)
  const factory User.parent(
      {required final String fullName,
      required final String email,
      required final String phoneNumber,
      required final String tc,
      required final Gender gender,
      required final Student student,
      @Default(Role.parent) Role role}) = Parent;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
