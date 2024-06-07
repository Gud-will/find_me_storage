import 'package:find_me_storage/providers/theme_provider.dart';
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
  late ListItemsProvider listItemsProvider;
  late ListContainerProvider listContainerProvider;
  late ThemeProvider themeProvider;
  bool _isdone = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isdone) {
      listItemsProvider = Provider.of<ListItemsProvider>(context);
      listContainerProvider = Provider.of<ListContainerProvider>(context);
      themeProvider = Provider.of<ThemeProvider>(context);
      listItemsProvider.getListItems(widget.path);
      listContainerProvider.getListContainers(widget.path);
      _isdone=!_isdone;
    }
  }

  void onbackpressed() async {
    List<String> pathItems = widget.path.split("/");
    print(
        "parentcontainer name ${widget.parentContainer?.name ?? "Onnum ella"}");
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
    print(widget.parentContainer?.name ?? "None nada");
    listItemsProvider.getListItems(widget.path);
    listContainerProvider.getListContainers(widget.path);
  }

  void ontap(String path, ItemContainer itemContainer) {
    String temppath = "/";
    if (itemContainer.path == temppath) {
      temppath = temppath + itemContainer.name;
    } else {
      temppath = "${itemContainer.path}/${itemContainer.name}";
    }
    widget.path = temppath;
    widget.parentContainer = itemContainer;
    print(widget.parentContainer?.name ?? "");
    print(widget.path);
    listItemsProvider.getListItems(widget.path);
    listContainerProvider.getListContainers(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(themeProvider: themeProvider,),
      body: SafeArea(
        child: Padding(
          padding: appPadding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.parentContainer?.name ?? "Items"),
                  Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                    );
                  }),
                ],
              ),
              MySearchBar(
                itemContainerRepository: widget.itemContainerRepository,
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Divider(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PageView(
                    children: [
                      Consumer2<ListItemsProvider, ListContainerProvider>(
                          builder: (context, listItemsProv, listContainerProv,
                              child) {
                        List<dynamic> totalitems = [];
                        totalitems.addAll(listItemsProv.rootItems);
                        totalitems.addAll(listContainerProv.rootContainers);
                        return ListView.builder(
                          itemCount: totalitems.length,
                          itemBuilder: (context, index) {
                            final cont = totalitems[index];
                            // if (index == 0 &&
                            //     index < listItemsProvider.rootItems.length) {
                            //   return Column(
                            //     children: [
                            //       const Text("Items:"),
                            //       const Padding(
                            //         padding: EdgeInsets.all(2),
                            //         child: Divider(),
                            //       ),
                            //       ItemContainerCard(
                            //         itemContainer: cont,
                            //         ontap: ontap,
                            //       ),
                            //     ],
                            //   );
                            // } else
                            if (index < listItemsProv.rootItems.length) {
                              return ItemCard(item: cont);
                            }
                            // } else if (index ==
                            //     listItemsProv.rootItems.length) {
                            //   return Column(
                            //     children: [
                            //       const Text("Containers:"),
                            //       const Padding(
                            //         padding: EdgeInsets.all(2),
                            //         child: Divider(),
                            //       ),
                            //       ItemContainerCard(
                            //         itemContainer: cont,
                            //         ontap: ontap,
                            //       ),
                            //     ],
                            //   );
                            // }
                            return ItemContainerCard(
                              itemContainer: cont,
                              ontap: ontap,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              )
            ],
          ),
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
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SlidingDialogBox(
                      itemContainerRepository: widget.itemContainerRepository,
                      parentitemcontainer: widget.parentContainer,
                      path: widget.path,
                    ),
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
