import 'package:find_me_storage/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/databasemodel.dart';
import '../providers/database_provider.dart';
import '../providers/theme_provider.dart';

class MyHomePage extends StatefulWidget {
   final ItemContainerRepository itemContainerRepository;

  MyHomePage({required this.itemContainerRepository});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<ItemContainer>> _rootContainers;

  @override
  void initState() {
    super.initState();
    _rootContainers = widget.itemContainerRepository.getRootContainers()
        as Future<List<ItemContainer>>;
  }

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
                Builder(builder: (context) {
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
                }),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              child: SearchBar(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: FutureBuilder(
                  future: _rootContainers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No containers found'));
                    } else {
                      final containers = snapshot.data!;
                      return ListView.builder(
                        itemCount: containers.length,
                        itemBuilder: (context, index) {
                          final cont = containers[index];
                          return ListTile(
                            onTap: () {},
                            title: Row(
                              children: [
                                const Text("Hall"),
                                Text.rich(
                                  TextSpan(
                                    style: Theme.of(context)
                                        .listTileTheme
                                        .subtitleTextStyle,
                                    children: const [
                                      TextSpan(text: "C: 1"),
                                      TextSpan(text: "I:  10")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: const Text(
                              "descp",
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
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
