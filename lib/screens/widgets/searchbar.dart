import 'package:find_me_storage/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import '../../models/databasemodel.dart';

class MySearchBar extends StatefulWidget {
  final ItemContainerRepository itemContainerRepository;
  final Function(String, ItemContainer?) ontap;
  const MySearchBar(
      {super.key, required this.itemContainerRepository, required this.ontap});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();
  final focus = FocusNode();
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
    setState(() {});
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchField(
      itemHeight: 50,
      focusNode: focus,
      maxSuggestionsInViewPort: 5,
      emptyWidget: const Text("No item/Containers Found"),
      controller: _controller,
      suggestionDirection: SuggestionDirection.down,
      onTapOutside: (p0) {
        focus.unfocus();
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
          item: e,
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
            item: e,
            child: searchChild(e),
          );
        }).toList();
      },
      onSuggestionTap: (SearchFieldListItem<dynamic> selected) async {
        ItemContainer? parentitemcontainer;
        final selectedItem = selected.item;
        String temppath = "/";
        temppath = selectedItem.path;
        if (temppath == "/") {
          temppath = "/";
          parentitemcontainer = null;
        } else {
          parentitemcontainer = await widget.itemContainerRepository
              .getItemContainer(selectedItem.parentLink.value!.id);
        }
        widget.ontap(selectedItem.path, parentitemcontainer);
        setState(() {
          _controller.clear();
          focus.unfocus();
        });
      },
      onSubmit: (p0) {
        focus.unfocus();
      },
      onTap: () async {
        await _updateSuggestions(_controller.value.text);
        setState(() {});
      },
    );
  }
}
