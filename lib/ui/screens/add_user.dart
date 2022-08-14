import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:engelsiz_admin/data/models/teacher_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddUserView extends ConsumerStatefulWidget {
  const AddUserView({Key? key}) : super(key: key);

  @override
  ConsumerState<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends ConsumerState<AddUserView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _studentFormKey = GlobalKey<FormBuilderState>();
  final _phoneNumberController = TextEditingController(text: "+90");
  Role? _role;

  @override
  void initState() {
    super.initState();

    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'TR',
      newMask: '+00 (000) 000 00 00',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'fullName',
                    decoration: const InputDecoration(labelText: 'Ad Soyad'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Bu alan boş bırakılamaz."),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Bu alan boş bırakılamaz."),
                      FormBuilderValidators.email(
                        errorText: "Doğru formatta bir mail adresi giriniz.",
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    controller: _phoneNumberController,
                    name: 'phoneNumber',
                    inputFormatters: [PhoneInputFormatter()],
                    decoration:
                        const InputDecoration(labelText: 'Telefon Numarası'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Bu alan boş bırakılamaz."),
                      FormBuilderValidators.equalLength(
                        19,
                        errorText:
                            "Doğru formatta bir telefon numarası giriniz.",
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'tc',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 11,
                    decoration:
                        const InputDecoration(labelText: 'TC Kimlik No'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Bu alan boş bırakılamaz."),
                      FormBuilderValidators.integer(),
                      FormBuilderValidators.equalLength(
                        11,
                        errorText: "TC Kimlik numarası 11 haneli olmalıdır.",
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Flexible(
                  //         child: FormBuilderTextField(
                  //       name: 'password',
                  //       decoration: const InputDecoration(labelText: 'Şifre'),
                  //       obscureText: true,
                  //       validator: FormBuilderValidators.compose([
                  //         FormBuilderValidators.required(),
                  //         FormBuilderValidators.minLength(11),
                  //       ]),
                  //     )),
                  //     const SizedBox(width: 16.0),
                  //     Flexible(
                  //       child: FormBuilderTextField(
                  //         name: 'confirm_password',
                  //         autovalidateMode:
                  //             AutovalidateMode.onUserInteraction,
                  //         decoration: InputDecoration(
                  //           labelText: 'Şifre Tekrar',
                  //           suffixIcon: ((_formKey
                  //                       .currentState
                  //                       ?.fields['confirm_password']
                  //                       ?.hasError ??
                  //                   false))
                  //               ? const Icon(Icons.error, color: Colors.red)
                  //               : const Icon(Icons.check,
                  //                   color: Colors.green),
                  //         ),
                  //         obscureText: true,
                  //         validator: FormBuilderValidators.compose([
                  //           /*FormBuilderValidators.equal(
                  //           context,
                  //           _formKey.currentState != null
                  //               ? _formKey.currentState.fields['password'].value
                  //               : null),*/
                  //           /*(val) {
                  //         if (val !=
                  //             _formKey.currentState?.fields['password']?.value) {
                  //           return 'Passwords do not match';
                  //         }
                  //         return null;
                  //       }*/
                  //         ]),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FormBuilderChoiceChip<Gender>(
                          name: "gender",
                          alignment: WrapAlignment.spaceEvenly,
                          decoration:
                              _nonBorder.copyWith(labelText: "Cinsiyet"),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Lütfen birini seçiniz."),
                          ]),
                          options: [
                            FormBuilderChipOption(
                                value: Gender.male,
                                child: Text(Gender.male.value)),
                            FormBuilderChipOption(
                                value: Gender.female,
                                child: Text(Gender.female.value))
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: FormBuilderChoiceChip<Role>(
                          name: "role",
                          alignment: WrapAlignment.spaceEvenly,
                          decoration: _nonBorder.copyWith(labelText: "Rol"),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Lütfen birini seçiniz."),
                          ]),
                          onChanged: ((value) => setState(() {
                                _role = value;
                              })),
                          options: [
                            FormBuilderChipOption(
                                value: Role.parent,
                                child: Text(Role.parent.value)),
                            FormBuilderChipOption(
                                value: Role.teacher,
                                child: Text(Role.teacher.value))
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (_role == Role.parent) StudentForm(_studentFormKey),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      final studentCase = _studentFormKey.currentState == null
                          ? true
                          : _studentFormKey.currentState?.saveAndValidate() ??
                              false;
                      if ((_formKey.currentState?.saveAndValidate() ?? false) &&
                          studentCase) {
                        try {
                          final UserCredential userCredential = await ref
                              .read(firebaseAuthProvider)
                              .createUserWithEmailAndPassword(
                                  email: _formKey
                                      .currentState!.fields["email"]!.value
                                      .toString(),
                                  password: _formKey
                                      .currentState!.fields["tc"]!.value
                                      .toString());
                          await userCredential.user?.updateDisplayName(_formKey
                              .currentState!.fields["fullName"]!.value
                              .toString());
                          TeacherUser teacherUser = TeacherUser(
                              fullName: _formKey
                                  .currentState!.fields["fullName"]!.value,
                              email:
                                  _formKey.currentState!.fields["email"]!.value,
                              phoneNumber: _formKey
                                  .currentState!.fields["phoneNumber"]!.value
                                  .replaceAll(
                                      RegExp(r"\p{P}", unicode: true), ""),
                              tc: _formKey.currentState!.fields["tc"]!.value,
                              gender: _formKey
                                  .currentState!.fields["gender"]!.value);
                          await ref
                              .read(fireStoreProvider)
                              .collection("users")
                              .doc(userCredential.user?.uid)
                              .set(teacherUser.toJson());
                          debugPrint(
                              "User created w/ id: ${userCredential.user?.uid}");
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "User created w/ id: ${userCredential.user?.uid}")));
                        } catch (e) {
                          debugPrint(e.toString());
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("$e")));
                        }
                      } else {
                        debugPrint('Invalid');
                      }
                    },
                    child: const Text('Signup',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _nonBorder = const InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.all(14.0),
  // errorBorder: InputBorder.none,
  // enabledBorder: InputBorder.none,
  fillColor: Colors.transparent,
);

class StudentForm extends StatefulWidget {
  final GlobalKey studentKey;
  const StudentForm(this.studentKey, {Key? key}) : super(key: key);

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.studentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Öğrencinin", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16.0),
          FormBuilderTextField(
            name: 'full_name',
            decoration: const InputDecoration(labelText: 'Ad Soyad'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: "Bu alan boş bırakılamaz.",
              ),
            ]),
          ),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormBuilderChoiceChip<Gender>(
                  name: "gender",
                  alignment: WrapAlignment.spaceEvenly,
                  decoration: _nonBorder.copyWith(labelText: "Cinsiyet"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Lütfen birini seçiniz."),
                  ]),
                  options: [
                    FormBuilderChipOption(
                        value: Gender.male, child: Text(Gender.male.value)),
                    FormBuilderChipOption(
                        value: Gender.female, child: Text(Gender.female.value))
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: FormBuilderTextField(
                  name: 'age',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _nonBorder.copyWith(labelText: "Yaş"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.integer(),
                    FormBuilderValidators.required(
                        errorText: "Bu alan boş bırakılamaz."),
                  ]),
                ),
              )
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

enum Gender {
  male("Erkek"),
  female("Kadın");

  const Gender(this.value);
  final String value;
}

enum Role {
  admin("Yönetici"),
  teacher("Öğretmen"),
  parent("Veli");

  const Role(this.value);
  final String value;
}
