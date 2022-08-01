import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:engelsiz_admin/controller/dashboard_controller.dart';
import 'package:engelsiz_admin/ui/screens/add_user.dart';
import 'package:engelsiz_admin/ui/screens/login/login_screen.dart';
import 'package:engelsiz_admin/ui/screens/users/users_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  final List<Widget> _screens = const <Widget>[
    UsersView(),
    AddUserView(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dashboardIndexProvider);
    return Scaffold(
      body: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              NavigationRail(
                backgroundColor: Colors.transparent,
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  ref
                      .read(dashboardIndexProvider.notifier)
                      .update((state) => index);
                },
                labelType: NavigationRailLabelType.selected,
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Kullanıcılar'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_add),
                    label: Text('Kullanıcı Ekle'),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Dikkat'),
                      content:
                          const Text("Çıkış yapmak istediğinize emin misiniz?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Vazgeç'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ref
                                .read(firebaseAuthProvider)
                                .signOut()
                                .then((_) => Navigator.of(context)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const LoginScreen()),
                                        (route) => false))
                                .onError((error, stackTrace) =>
                                    debugPrint(error.toString()));
                          },
                          child: const Text('Evet'),
                        ),
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                ),
              )
            ],
          ),
          const VerticalDivider(thickness: 2, width: 1),
          // This is the main content.
          Expanded(
            child: _screens[selectedIndex],
          )
        ],
      ),
    );
  }
}
