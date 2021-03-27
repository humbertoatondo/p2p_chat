part of 'home_page.dart';

class SearchAppBar extends AppBar {
  final TextEditingController searchTextController = TextEditingController();

  SearchAppBar({
    Key key,
    @required BuildContext context,
  }) : super(
          key: key,
          title: const Text('Home'),
          bottom: PreferredSize(
            child: Container(
              height: 36,
              margin: EdgeInsets.all(12),
              child: TextField(
                onChanged: (username) {
                  context.read<HomeBloc>().add(SearchInputChanged(username));
                },
                // focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: "Search users",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.blue[800],
                  contentPadding: EdgeInsets.only(left: 8, right: 8),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(kToolbarHeight),
          ),
        );
}
