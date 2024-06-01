import 'package:find_me_storage/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: Drawer(),
      body: Padding(
        padding: appPadding,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Items"),
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                        themeProvider.toggleTheme();
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                    );
                  }
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2,),
              child: SearchBar(),
            ),
            Expanded(
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                return ListTile(
                  
                  onTap: (){},
                  title: const Text("Hall"),
                  subtitle: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Conatiner: 2"),
                      Text("Items: 10"),
                    ],
                  ),
                );
              },),),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Container Screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
