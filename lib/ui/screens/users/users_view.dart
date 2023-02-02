import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:engelsiz_admin/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersView extends ConsumerWidget {
  const UsersView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(usersStreamProvider);
    return Center(
      child: allUsers.when(
          data: (data) => ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) => Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      data[index].user.map(
                          teacher: (_) => Icons.school_outlined,
                          parent: (_) => Icons.person_outline),
                    ),
                    title: Text(data[index].user.fullName),
                    subtitle: Text(data[index].user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
