import 'package:flutter/material.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/utils/main_color.dart';

class JSearch extends StatefulWidget {
  const JSearch({this.callback, Key? key}) : super(key: key);

  final VoidCallback? callback;

  @override
  _JSearchState createState() => _JSearchState();
}

class _JSearchState extends State<JSearch> {
  final TextEditingController _textEditingController = TextEditingController();

  void _search(value) => setState(() {
        AnimeMapper.filter(value);
        widget.callback?.call();
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(label: Text('Rechercher')),
              onChanged: _search,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: MainColor.mainColorO,
            ),
            onPressed: () => _search(_textEditingController.text),
          ),
        ),
      ],
    );
  }
}
