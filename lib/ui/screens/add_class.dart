import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth_controller.dart';
import '../../data/models/class_room.dart';

class AddClassView extends ConsumerStatefulWidget {
  const AddClassView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddClassViewState();
}

class _AddClassViewState extends ConsumerState<AddClassView> {
  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: SingleChildScrollView(
            child: FormBuilder(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Sınıf Oluşturun"),
                    controller: _controller,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () async {
                        final Classroom classRoom = Classroom.fromJson({
                          'className': _controller.text,
                          'teachers': [],
                          'parents': []
                        });

                        try {
                          await createClass(ref: ref, classRoom: classRoom);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Class created: ${classRoom.className}")),
                            );
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("$e")));
                        }
                      },
                      child: const Text(
                        "Sınıf Olustur",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
