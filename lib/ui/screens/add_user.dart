import 'package:collection/collection.dart';
import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:engelsiz_admin/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../data/models/user.dart';

class AddUserView extends ConsumerStatefulWidget {
  const AddUserView({Key? key}) : super(key: key);

  @override
  ConsumerState<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends ConsumerState<AddUserView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _studentFormKey = GlobalKey<FormBuilderState>();
  final _phoneNumberController =
      TextEditingController(text: "+90 (555) 555 55 55");
  Role? _role;
  late TextEditingController _controller;
  int classNum = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
                    initialValue: "EFO",
                    decoration: const InputDecoration(labelText: 'Ad Soyad'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Bu alan boş bırakılamaz."),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'email',
                    initialValue: "EFO@test.com",
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
                    initialValue: "21091061404",
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FormBuilderChoiceChip<String>(
                          name: "gender",
                          alignment: WrapAlignment.spaceEvenly,
                          decoration:
                              _nonBorder.copyWith(labelText: "Cinsiyet"),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Lütfen birini seçiniz."),
                          ]),
                          options: [
                            FormBuilderChipOption(value: Gender.male.value),
                            FormBuilderChipOption(value: Gender.female.value)
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: FormBuilderChoiceChip<String>(
                          name: "role",
                          alignment: WrapAlignment.spaceEvenly,
                          decoration: _nonBorder.copyWith(labelText: "Rol"),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Lütfen birini seçiniz."),
                          ]),
                          onChanged: (value) => setState(
                            () => _role = Role.values
                                .firstWhereOrNull((r) => r.name == value),
                          ),
                          options: [
                            FormBuilderChipOption(
                              value: Role.parent.name,
                              child: Text(Role.parent.value),
                            ),
                            FormBuilderChipOption(
                              value: Role.teacher.name,
                              child: Text(Role.teacher.value),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderField<List<String>>(
                          name: 'classroom',
                          builder: (FormFieldState field) {
                            return MultiSelectDialogField<String>(
                              buttonText: const Text("Sınıf Seçiniz"),
                              buttonIcon: const Icon(Icons.school_outlined),
                              searchable: true,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  width: 1.0,
                                  color: AppColors.tertiary,
                                ),
                              ),
                              title: const Text("Sınıf Seçiniz"),
                              onConfirm: (values) {
                                if (_role == Role.parent && values.length > 1) {
                                  print("SAAAAAAAAAAAAAAAAA");
                                } else {
                                  field.didChange(values);
                                }
                              },
                              items: ref
                                      .watch(classStreamProvider)
                                      .value
                                      ?.map((classroom) =>
                                          MultiSelectItem<String>(classroom.id,
                                              classroom.classRoom.className))
                                      .toList() ??
                                  [],
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (_role == Role.parent) StudentForm(_studentFormKey),
                  if (_role == Role.teacher)
                    FormBuilderTextField(
                      name: 'branch',
                      decoration:
                          const InputDecoration(labelText: 'Ogretmen Branşı'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Bu alan boş bırakılamaz."),
                      ]),
                    ),
                  const SizedBox(height: 16.0),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      final User user;
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        if (_role == Role.teacher) {
                          user = Teacher.fromJson(_formKey.currentState!.value);
                        } else if (_studentFormKey.currentState
                                ?.saveAndValidate() ??
                            false) {
                          final Map<String, dynamic> parentJson =
                              Map.from(_formKey.currentState!.value);
                          parentJson["student"] =
                              _studentFormKey.currentState!.value;
                          user = Parent.fromJson(parentJson);
                        } else {
                          debugPrint("Error");
                          return;
                        }
                        try {
                          await signUp(ref: ref, user: user);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("User created: ${user.email}")),
                            );
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("$e")));
                        }
                      } else {
                        debugPrint('Invalid');
                      }
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(color: Colors.white),
                    ),
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

class StudentForm extends ConsumerWidget {
  final GlobalKey studentKey;
  const StudentForm(this.studentKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        FormBuilder(
          key: studentKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Öğrencinin",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'fullName',
                initialValue: "EFO",
                decoration: const InputDecoration(labelText: 'Ad Soyad'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Bu alan boş bırakılamaz.",
                  ),
                ]),
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'tc',
                initialValue: "21091014495",
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 11,
                decoration: const InputDecoration(labelText: 'TC Kimlik No'),
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
              Row(
                children: [
                  Expanded(
                    child: FormBuilderChoiceChip<String>(
                      name: "gender",
                      alignment: WrapAlignment.spaceEvenly,
                      decoration: _nonBorder.copyWith(labelText: "Cinsiyet"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Lütfen birini seçiniz."),
                      ]),
                      options: [
                        FormBuilderChipOption(value: Gender.male.value),
                        FormBuilderChipOption(value: Gender.female.value)
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'age',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _nonBorder.copyWith(labelText: "Yaş"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.integer(),
                        FormBuilderValidators.required(
                            errorText: "Bu alan boş bırakılamaz."),
                      ]),
                      valueTransformer: (val) => int.tryParse(val ?? ""),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}

// class CreatClasses extends ConsumerStatefulWidget {
//   const CreatClasses({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   ConsumerState createState() => _CreatClassesState();
// }
//
// class _CreatClassesState extends ConsumerState<CreatClasses> {
//   late TextEditingController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: FormBuilderField<List<String>>(
//                 name: 'teachers',
//                 builder: (FormFieldState field) {
//                   return MultiSelectDialogField<String>(
//                     buttonText: const Text("Öğretmen Seçiniz"),
//                     buttonIcon: const Icon(Icons.school_outlined),
//                     searchable: true,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(
//                         width: 1.0,
//                         color: AppColors.tertiary,
//                       ),
//                     ),
//                     title: const Text("Öğretmen Seçiniz"),
//                     items: ref
//                             .watch(classStreamProvider)
//                             .value
//                             ?.map((classroom) => MultiSelectItem<String>(
//                                 classroom.id, classroom.classRoom.className))
//                             .toList() ??
//                         [],
//                     onConfirm: (values) {
//                       field.didChange(values);
//                     },
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(
//               width: 16,
//             ),
//             Expanded(
//                 child: MaterialButton(
//               color: Theme.of(context).colorScheme.tertiary,
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) => AlertDialog(
//                     title: const Text("Oluşturulacak Sıfının Adı"),
//                     content: TextField(
//                       controller: _controller,
//                     ),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, 'Cancel'),
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           final Classroom classRoom = Classroom.fromJson({
//                             'className': _controller.text,
//                             'teachers': [],
//                             'parents': []
//                           });
//                           print(_controller.text);
//
//                           try {
//                             await createClass(ref: ref, classRoom: classRoom);
//                             if (context.mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text(
//                                         "Class created: ${classRoom.className}")),
//                               );
//                             }
//                           } catch (e) {
//                             debugPrint(e.toString());
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(SnackBar(content: Text("$e")));
//                           }
//                           Navigator.pop(context, 'OK');
//                         },
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: const Text(
//                 'Sınıf Oluştur',
//                 style: TextStyle(color: Colors.white),
//               ),
//             )
//                 // child: MaterialButton(
//                 //   color: Theme.of(context).colorScheme.tertiary,
//                 //   onPressed: () {
//                 //     showDialog(
//                 //       context: context,
//                 //       builder: (BuildContext context) => AlertDialog(
//                 //         title: Text("Oluşturulacak Sınıfın Adı"),
//                 //         content: FormBuilder(
//                 //           key: _formKey,
//                 //           child: FormBuilderTextField(
//                 //             name: 'className',
//                 //             decoration: const InputDecoration(
//                 //                 labelText: 'Sınıf Adını giriniz'),
//                 //           ),
//                 //         ),
//                 //         actions: <Widget>[
//                 //           TextButton(
//                 //             onPressed: () => Navigator.pop(context, 'İptal'),
//                 //             child: const Text('İptal'),
//                 //           ),
//                 //           TextButton(
//                 //               onPressed: () {
//                 //                 final ClassRoom classRoom;
//                 //
//                 //                 print(_formKey.currentState!.value);
//                 //
//                 //                 // classRoom = ClassRoom.fromJson(
//                 //                 //     _formKey.currentState!.value);
//                 //                 Navigator.pop(context, 'OK');
//                 //               },
//                 //               child: Text("OK"))
//                 //         ],
//                 //       ),
//                 //     );
//                 //   },
//                 //   child: Text("Sınıf Oluştur"),
//                 // ),
//                 )
//           ],
//         ),
//       ],
//     );
//   }
// }
