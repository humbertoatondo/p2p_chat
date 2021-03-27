part of 'home_page.dart';

class ChatListView extends StatefulWidget {
  ChatListView({
    Key key,
    @required this.chatsRepository,
  })  : assert(chatsRepository != null),
        super(key: key);

  final ChatsRepository chatsRepository;

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  var usernamesList;
  final _animatedChatsListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    usernamesList = widget.chatsRepository.getChatsUsernames();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageAddedToChat) {
          usernamesList = widget.chatsRepository.getChatsUsernames();
          if (state.previousChatPositionInList == 0) {
            return;
          }
          if (state.previousChatPositionInList != -1) {
            int previousIndex = state.previousChatPositionInList;
            _animatedChatsListKey.currentState.removeItem(
              previousIndex,
              (context, animation) => ChatCell(username: usernamesList[previousIndex]),
            );
          }
          _animatedChatsListKey.currentState.insertItem(0);
          print(widget.chatsRepository.getChatsUsernames());
        }
      },
      child: AnimatedList(
        key: _animatedChatsListKey,
        initialItemCount: widget.chatsRepository.getChatsUsernames().length,
        itemBuilder: (context, index, animation) {
          return ChatCell(username: usernamesList[index]);
        },
      ),
    );
  }
}

class ChatCell extends StatelessWidget {
  ChatCell({Key key, @required this.username}) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pushNamed(
          '/chat',
          arguments: username,
        );
      },
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          color: Colors.purple[300],
        ),
      ),
    );
  }
}
