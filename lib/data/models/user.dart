import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:engelsiz_admin/data/models/student.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(unionKey: 'role')
class User with _$User {
  const factory User.teacher(
      {required final String fullName,
      required final String email,
      required final String phoneNumber,
      required final String tc,
      required final String branch,
      @Default("https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg")
          String profilePicture,
      required final List<String> classroom,
      @Default([])
          List<String> waitAppo,
      required final Gender gender}) = Teacher;

  @JsonSerializable(explicitToJson: true)
  const factory User.parent(
      {required final String fullName,
      required final String email,
      required final String phoneNumber,
      required final String tc,
      required final Gender gender,
      @Default([])
          List<String> waitAppo,
      @Default("https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg")
          String profilePicture,
      required final List<String> classroom,
      required final Student student}) = Parent;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
