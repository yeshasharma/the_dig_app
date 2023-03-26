import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_dig_app/models/message.dart';
import 'package:the_dig_app/screens/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String destinationFName;
  final String destinationId;
  final String profileId;
  const ChatScreen(
      {Key? key,
      required this.destinationFName,
      required this.destinationId,
      required this.profileId})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String groupChatId = "";
  String currentUserId = "";
  String peerId = "";

  generateGroupId() {
    if (int.parse(widget.destinationId) > int.parse(widget.profileId)) {
      groupChatId = '${widget.destinationId} - ${widget.profileId}';
    } else {
      groupChatId = '${widget.profileId} - ${widget.destinationId}';
    }
    currentUserId = widget.profileId;
    peerId = widget.destinationId;
  }

  sendChat({required String message}) async {
    Message chat = Message(
        content: message,
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: Timestamp.now().toString());

    await FirebaseFirestore.instance
        .collection("groupMessages")
        .doc(groupChatId)
        .collection("messages")
        .add(chat.toJson());

    _messageController.text = "";
    //
  }

  @override
  void initState() {
    generateGroupId();
    _scrollDown();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                onBackPress();
              }),
          title: Text(widget.destinationFName),
          centerTitle: true,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextField(
                    decoration: InputDecoration(
                        label: const Text("Enter message"),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15.0))),
                    controller: _messageController,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (_messageController.text.isNotEmpty &&
                          _messageController.text.trim().isNotEmpty) {
                        sendChat(message: _messageController.text);
                        _messageController.text = "";
                        _scrollDown();
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ))
              ],
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("groupMessages")
                .doc(groupChatId)
                .collection("messages")
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                controller: _controller,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Message chat =
                      Message.fromDocument(snapshot.data!.docs[index]);
                  return ChatBubble(
                      text: chat.content,
                      isCurrentUser:
                          chat.idFrom == currentUserId ? true : false);
                },
              );
            }),
      ),
    );
  }
}
