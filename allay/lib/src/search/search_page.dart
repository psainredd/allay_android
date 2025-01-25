import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String searchQuery;
  const SearchPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String? searchQuery;

  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Label('Showing results for $searchQuery'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://www.tollywood.net/wp-content/uploads/2022/02/Hawttt-Pragya-Jaiswal-in-black-lingerie.jpg'),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}