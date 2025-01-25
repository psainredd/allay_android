import 'package:allay/src/search/search_page.dart';
import 'package:allay/src/util/error.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/util/specialities.dart';
import 'package:allay/src/widgets/allay_search_delegate.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'landing_page.dart';

class MainSearch extends ConsumerStatefulWidget {
  final List<SearchItem> specialities;
  const MainSearch({Key? key, required this.specialities}) : super(key: key);

  @override
  ConsumerState<MainSearch> createState() => MainSearchState();
}

class MainSearchState extends ConsumerState<MainSearch> {
  late List<SearchItem> specialities;

  @override
  void initState() {
    specialities = widget.specialities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
      child: GestureDetector(
        child: Container(
          alignment: AlignmentDirectional.topStart,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: subTextColor, width: 0.2),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: TextButton.icon (
            onPressed: () =>  showSearchPage(specialities, context),
            icon: const Icon(Icons.search, color: subTextColor, size: 20.0),
            label: const LabelSmall('Search doctors, specialities, medicines...', color: subTextColor)
          ),
        ),
        onTap: () => showSearchPage(specialities, context),
      )
    );
  }
}

class MainSearchDelegate extends AllaySearchDelegate {
  MainSearchDelegate({
    required BuildContext context,
    required List<SearchItem> suggestions,
  }) : super(
    context: context,
    suggestions: suggestions,
    searchLabel: "Search doctors, medicines, specialities..."
  );

  @override
  Widget getListItemWidget(SearchItem item) {
    return GestureDetector(
      onTap: () => onSearchItemPressed(item),
      child: LabelIcon(
        item.label,
        item.icon?.icon??Icons.search,
        iconSize: 25,
        spacing: 8,
        color: secondaryTextColor,
      ),
    );
  }

  @override
  void onSearchItemPressed(SearchItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchPage(searchQuery: item.label)));
  }

  @override
  Widget getSearchResults(SearchItem queryItem) {
    return getListItemWidget(queryItem);
  }
}