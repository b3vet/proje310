import 'package:flutter/material.dart';

Widget _searchInput() {
  return Form(
    child: Column(
      children: [TextFormField()],
    ),
  );
}

Widget _searchIcon() {
  return IconButton(
      onPressed: () => print('Search'),
      icon: const Padding(
        padding: EdgeInsets.all(14.0),
        child: Icon(Icons.search),
      ));
}

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _searchInput(),
              ),
              _searchIcon()
            ],
          ),
        )
      ],
    );
  }
}
