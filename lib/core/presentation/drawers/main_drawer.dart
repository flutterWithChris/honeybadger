import 'package:OutsourcedX/login/view/cubit/login_cubit.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 0.0),
            child: Text(
              'Hey, ${context.read<ProfileBloc>().state.user!.firstName!}!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.push('/settings');
            },
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
          ),
          Expanded(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context.read<LoginCubit>().logout();
                        context.go('/login');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
