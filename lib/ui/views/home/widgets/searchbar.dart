import 'package:flutter/material.dart';

import '../../../../constants/themes/light_color.dart';

class SearchBar extends StatelessWidget {
  final void Function(String) func;

  const SearchBar({Key key, this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search for your Recipe",
              hintStyle: TextStyle(fontSize: 14),
              contentPadding: EdgeInsets.all(16.0),
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.none,
                  width: 0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
            ),
            onSubmitted: func,
          ),
        ),
      ],
    );
  }
}
