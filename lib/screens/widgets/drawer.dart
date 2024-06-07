import 'package:find_me_storage/screens/widgets/animatedtextswitcher.dart';
import 'package:flutter/material.dart';
import '../../providers/theme_provider.dart';

class MyDrawer extends StatelessWidget {
  final ThemeProvider? themeProvider;
  const MyDrawer({super.key, required this.themeProvider});
  void toggletheme() {
    themeProvider?.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    bool islighttheme = themeProvider?.islighttheme()??true;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text("Theme"),
            trailing: Animatedtextswitcher(
                text1: "Light Mode \u{1F31E}",
                text2: "Dark Mode \u{1F31C}",
                toggleisitem: toggletheme,
                isitem: islighttheme),
          ),
        ],
      ),
    );
  }
}
