import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import '../util/specialities.dart';
import 'colors.dart';

abstract class AllaySearchDelegate extends SearchDelegate<String> {
  final List<SearchItem> suggestions;
  final BuildContext context;
  final String searchLabel;

  AllaySearchDelegate({
    required this.context,
    required this.suggestions,
    required this.searchLabel,
  }) : super(
    searchFieldDecorationTheme: InputDecorationTheme(
      labelStyle: LabelSmall.style,
      hintStyle: LabelSmall.style,
      isDense: true,
      border: InputBorder.none,
      counterStyle: LabelSmall.style,
      floatingLabelStyle: LabelSmall.style,
      helperStyle: LabelSmall.style,
      suffixStyle: LabelSmall.style
    )
  );

  @override
  String get searchFieldLabel => searchLabel;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, size: 20.0),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        size: 20,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: getSearchResults(SearchItem(label: query)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ? this.suggestions : _getSuggestions();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated (
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: suggestions.length,
        itemBuilder: (content, index) => ListTile(
          dense: true,
          style: ListTileStyle.list,
          minVerticalPadding: 1.0,
          title: getListItemWidget(suggestions[index]),
          onTap: () => onSearchItemPressed(suggestions[index]),
        ),
        separatorBuilder: (context, index) => const Divider(color: subTextColor),
      ),
    );
  }

  List<SearchItem> _getSuggestions() {
    var matchedSuggestions = suggestions.where(
      (e) => e.label.toLowerCase().startsWith(query.toLowerCase()) ||
        (e.tags??[]).any((tag) => tag.toLowerCase().startsWith(query.toLowerCase()))
    ).toList();
    matchedSuggestions.add(SearchItem(label: query));
    return matchedSuggestions;
  }

  Widget getListItemWidget(SearchItem item);

  void onSearchItemPressed(SearchItem item);

  Widget getSearchResults(SearchItem queryItem);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        brightness: colorScheme.brightness,
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        textTheme: theme.textTheme.copyWith(headline6: LabelSmall.style),
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
        InputDecorationTheme(
          hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
          border: InputBorder.none,
        ),
      textTheme: theme.textTheme.copyWith(headline6: Label.style)
    );
  }
}
