import 'package:find_me_storage/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import '../../models/databasemodel.dart';

class MySearchBar extends StatefulWidget {
  final ItemContainerRepository itemContainerRepository;
  const MySearchBar({super.key, required this.itemContainerRepository});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _suggestions = [];
  Widget searchChild(x) {
    return ListTile(
      title: Text(x.name),
      subtitle: Text(x.description),
    );
  }

  Future<void> _updateSuggestions(String query) async {
    if (query.isEmpty) {
      _suggestions.clear();
    }
    final containers =
        await widget.itemContainerRepository.getContainersThroughQuery(query);
    final items =
        await widget.itemContainerRepository.getItemsThroughQuery(query);
    _suggestions = [...containers, ...items];
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchField(
      emptyWidget: const Text("No item/Containers Found"),
      controller: _controller,
      suggestionDirection: SuggestionDirection.down,
      onTapOutside: (p0) {
        Focus.of(context).unfocus();
      },
      hint: "Search By Name or Description",
      suggestions: _suggestions.map((e) {
        print("Check Check Check" + e.name);
        String displayValue;
        if (e is ItemContainer) {
          displayValue = e.name;
        } else if (e is Item) {
          displayValue = e.name;
        } else {
          displayValue = 'Unknown';
        }
        return SearchFieldListItem<dynamic>(
          displayValue,
          child: searchChild(e),
        );
      }).toList(),
      suggestionState: Suggestion.expand,
      onSearchTextChanged: (query) {
        _updateSuggestions(_controller.value.text);
        return _suggestions.map((e) {
          print("Check Check Check" + e.name);
          String displayValue;
          if (e is ItemContainer) {
            displayValue = e.name;
          } else if (e is Item) {
            displayValue = e.name;
          } else {
            displayValue = 'Unknown';
          }
          return SearchFieldListItem<dynamic>(
            displayValue,
            child: searchChild(e),
          );
        }).toList();
      },
      onTap: () async {
        await _updateSuggestions(_controller.value.text);
        setState(() {});
      },
    );
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Search Example'),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       children: [
    //         TextField(
    //           controller: _controller,
    //           decoration: InputDecoration(
    //             hintText: 'Search by name or description',
    //           ),
    //           onChanged:
    //         ),
    //         Expanded(
    //           child: ListView.builder(
    //             itemCount: _suggestions.length,
    //             itemBuilder: (context, index) {
    //               final suggestion = _suggestions[index];
    //               final isContainer = suggestion is ItemContainer;
    //               final name = isContainer
    //                   ? suggestion.name
    //                   : (suggestion as Item).name;
    //               final description = isContainer
    //                   ? suggestion.description
    //                   : (suggestion as Item).description;

    //               return ListTile(
    //                 title: Text(name),
    //                 subtitle: Text(description ?? ''),
    //                 onTap: () {
    //                   // Handle tap on suggestion
    //                 },
    //               );
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
