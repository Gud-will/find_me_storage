import 'package:find_me_storage/screens/widgets/itemcontainercard.dart';
import 'package:find_me_storage/screens/widgets/additemdialog.dart';
import 'package:find_me_storage/screens/widgets/drawer.dart';
import 'package:find_me_storage/screens/widgets/searchbar.dart';
import 'package:find_me_storage/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/databasemodel.dart';
import '../providers/database_provider.dart';
import '../providers/theme_provider.dart';

class MyHomePage extends StatefulWidget {
  final ItemContainerRepository itemContainerRepository;

  const MyHomePage({super.key, required this.itemContainerRepository});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<ItemContainer>> _rootContainers;
  Future<void> _addSampleData() async {
    final bigBox = ItemContainer()
      ..name = 'Big Box'
      ..description = 'A big box'
      ..path = 'Big Box';
    await widget.itemContainerRepository.addItemContainer(bigBox);

    final smallBox = ItemContainer()
      ..name = 'Small Box'
      ..description = 'A small box'
      ..parentLink.value=bigBox
      ..path = 'Big Box/Small Box';
    await widget.itemContainerRepository.addItemContainer(smallBox,hasparent: true,parentid: bigBox.id);

    final spidermanKeychain = Item()
      ..name = 'Spiderman Keychain'
      ..description = 'A Spiderman keychain'
      ..parentLink.value=smallBox
      ..path = 'Big Box/Small Box/Spiderman Keychain';
    await widget.itemContainerRepository
        .addItemToContainer(smallBox.id, spidermanKeychain);

    setState(() {
      _rootContainers = widget.itemContainerRepository.getRootContainers();
    });
  }

  @override
  void initState() {
    super.initState();
    _rootContainers = widget.itemContainerRepository.getRootContainers();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: MyDrawer(),
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
            MySearchBar(),
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
                          return ItemContainerCard(
                            itemContainer: cont,
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
          _addSampleData();
          // showModalBottomSheet(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return SlidingDialogBox(
          //       itemContainerRepository: widget.itemContainerRepository,
          //       parentitemcontainer: ItemContainer(),
          //       path: "",
          //     );
          //   },
          // );
          // setState(() {
          //   _rootContainers =
          //       widget.itemContainerRepository.getRootContainers();
          // });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
