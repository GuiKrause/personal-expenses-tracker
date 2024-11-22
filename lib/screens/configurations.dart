import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_expenses_tracker/providers/theme_provider.dart';

class Configurations extends ConsumerWidget {
  const Configurations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeState appThemeState = ref.watch(appThemeStateNotifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: appThemeState.isDarkModeEnable,
            onChanged: (value) {
              if (value) {
                appThemeState.setDarkTheme();
              } else {
                appThemeState.setLightTheme();
              }
            },
            title: Text(
              'Dark Mode',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            subtitle: Text(
              'Switch to change the theme of the app',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
        ],
      ),
    );
  }
}
