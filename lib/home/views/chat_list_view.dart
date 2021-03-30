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
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/images/profile.jpg",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                    height: double.infinity,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          height: 4,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                    height: double.infinity,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "9:54 p.m.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 20, maxHeight: 20),
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text("1"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            indent: 88,
            thickness: 1,
            height: 0,
          ),
        ],
      ),
    );
  }
}
