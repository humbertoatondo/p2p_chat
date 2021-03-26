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
  final _animatedChatsListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageAddedToChat) {
          print(state.previousChatPositionInList);
          if (state.previousChatPositionInList != -1) {
            int previousIndex = state.previousChatPositionInList;
            _animatedChatsListKey.currentState.removeItem(
              previousIndex,
              (context, animation) => ChatCell(),
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
          return ChatCell();
        },
      ),
    );
  }
}

class ChatCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        color: Colors.purple[300],
      ),
    );
  }
}
