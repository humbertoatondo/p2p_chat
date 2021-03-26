part of 'home_page.dart';

class UserSearchView extends StatefulWidget {
  @override
  _UserSearchViewState createState() => _UserSearchViewState();
}

class _UserSearchViewState extends State<UserSearchView> {
  List<Widget> createUserCells(List<dynamic> users) {
    List<Widget> cells = [];
    users.forEach((user) {
      cells.add(UserListViewCell(username: user));
    });
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is DisplayingUsers) {
          return ListView(
            children: createUserCells(state.usernames),
          );
        }
        return SplashPage();
      },
    );
  }
}

class UserListViewCell extends StatelessWidget {
  final String username;

  UserListViewCell({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<CommunicationBloc>().add(StartPeerConnectionRequested(username));
        Navigator.of(context).pushNamed(
          '/chat',
          arguments: username,
        );
        context.read<HomeBloc>().add(SearchInputChanged(""));
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey[850],
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 12,
              height: double.infinity,
            ),
            Text(
              username,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
