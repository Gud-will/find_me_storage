import 'package:find_me_storage/screens/widgets/itemcard.dart';
import 'package:find_me_storage/screens/widgets/itemcontainercard.dart';
import 'package:find_me_storage/screens/widgets/additemdialog.dart';
import 'package:find_me_storage/screens/widgets/drawer.dart';
import 'package:find_me_storage/screens/widgets/searchbar.dart';
import 'package:find_me_storage/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/databasemodel.dart';
import '../providers/database_provider.dart';
import '../providers/listitemsprovider.dart';
import '../providers/theme_provider.dart';

class MyHomePage extends StatefulWidget {
  final ItemContainerRepository itemContainerRepository;
  String path;
  ItemContainer? parentContainer;
  MyHomePage(
      {super.key,
      required this.itemContainerRepository,
      required this.path,
      this.parentContainer});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ThemeProvider themeProvider;
  late ListItemsProvider listItemsProvider;
  late ListContainerProvider listContainerProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
    listItemsProvider = Provider.of<ListItemsProvider>(context);
    listContainerProvider = Provider.of<ListContainerProvider>(context);
    listItemsProvider.getListItems(widget.path);
    listContainerProvider.getListContainers(widget.path);
  }

  void onbackpressed() async {
    List<String> pathItems = widget.path.split("/");
    pathItems.removeLast();
    print(widget.path);
    widget.path = pathItems.join("/");
    print(widget.path);
    if (widget.path == "") {
      widget.path = "/";
      widget.parentContainer = null;
    } else {
      widget.parentContainer = await widget.itemContainerRepository
          .getItemContainer(widget.parentContainer?.parentLink.value?.id ?? 0);
    }
    print(widget.parentContainer?.name??"None nada");
    listItemsProvider.getListItems(widget.path);
    listContainerProvider.getListContainers(widget.path);
  }

  void ontap(String path, ItemContainer itemContainer) {
    widget.path = path;
    widget.parentContainer = itemContainer;
    print(widget.parentContainer?.name??"");
    print(widget.path);
    listItemsProvider.getListItems(widget.path);
    listContainerProvider.getListContainers(widget.path);
  }

  @override
  Widget build(BuildContext context) {
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
                child: PageView(
                  children: [
                    Consumer2<ListItemsProvider, ListContainerProvider>(builder:
                        (context, listItemsProv, listContainerProv, child) {
                      List<dynamic> totalitems = [];
                      totalitems.addAll(listItemsProv.rootItems);
                      totalitems.addAll(listContainerProv.rootContainers);
                      return ListView.builder(
                        itemCount: totalitems.length,
                        itemBuilder: (context, index) {
                          final cont = totalitems[index];
                          if (index < listItemsProv.rootItems.length) {
                            return ItemCard(item: cont);
                          }
                          return ItemContainerCard(
                            itemContainer: cont,
                            ontap: ontap,
                          );
                        },
                      );
                    }),
                    // Consumer<ListItemsProvider>(
                    //   builder: (context, listItemsProvider, child) {
                    //     List<Item> containers =
                    //         listItemsProvider.rootItems;
                    //     return ListView.builder(
                    //       itemCount: containers.length,
                    //       itemBuilder: (context, index) {
                    //         final cont = containers[index];
                    //         return ItemCard(
                    //           item: cont,
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.path == "/"
              ? const SizedBox(
                  height: 1,
                )
              : FloatingActionButton(
                  onPressed: onbackpressed,
                  child: const Icon(Icons.arrow_back_outlined),
                ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SlidingDialogBox(
                    itemContainerRepository: widget.itemContainerRepository,
                    parentitemcontainer: widget.parentContainer,
                    path: widget.path,
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}


// FutureBuilder(
//                   future: _rootContainers,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Center(child: Text('No containers found'));
//                     } else {
//                       final containers = snapshot.data!;
//                       return ListView.builder(
//                         itemCount: containers.length,
//                         itemBuilder: (context, index) {
//                           final cont = containers[index];
//                           return ItemContainerCard(
//                             itemContainer: cont,
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),