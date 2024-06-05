import 'package:find_me_storage/providers/database_provider.dart';
import 'package:find_me_storage/providers/theme_provider.dart';
import 'package:find_me_storage/screens/homepage.dart';
import 'package:find_me_storage/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'models/databasemodel.dart';


Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [ItemContainerSchema, ItemSchema],
    directory: dir.path,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar
  final isar = await openIsar();

  // Initialize repository
  final itemContainerRepository = ItemContainerRepository(isar);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(lightTheme),
      child: MyApp(itemContainerRepository: itemContainerRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ItemContainerRepository itemContainerRepository;

  MyApp({required this.itemContainerRepository});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeProvider.themeData,
          home: MyHomePage(itemContainerRepository: itemContainerRepository),
        );
      },
    );
  }
}
