import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
class Student with _$Student {
  const factory Student(
      {required final String fullName,
      required final String tc,
      required final Gender gender,
      required final int age}) = _Student;

  factory Student.fromJson(Map<String, Object?> json) =>
      _$StudentFromJson(json);
}
