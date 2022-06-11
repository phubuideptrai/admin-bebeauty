import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MAddress.dart';
import 'package:bebeautyapp/model/MPreference.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ChatAdmin extends StatefulWidget {
  final String chatRoomId;
  final String admin_id;
  final MUser user;
  ChatAdmin(
      {required this.chatRoomId, required this.admin_id, required this.user});

  @override
  _ChatAdminState createState() =>
      _ChatAdminState(this.chatRoomId, this.admin_id, this.user);
}

class _ChatAdminState extends State<ChatAdmin> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();
  String chatRoomId = "";
  String admin_id = "";
  MUser user = new MUser(
      id: "",
      displayName: "",
      email: "",
      phone: "",
      dob: DateTime(2001, 1, 1),
      gender: 1,
      address: new MAddress(
          userID: "", fullStreetName: "", latitude: 0, longitude: 0),
      point: 0,
      totalSpending: 0,
      role: 1,
      avatarUri:
          "https://firebasestorage.googleapis.com/v0/b/be-beauty-app.appspot.com/o/avatar.jpg?alt=media&token=4cb911b2-3282-4aea-b03a-0ab9b681602a",
      preference: new MPreference(
          userID: "",
          brandHistory: [],
          skinTypeHistory: [],
          categoryHistory: [],
          sessionHistory: [],
          structureHistory: []));
  ChatServices database = new ChatServices();

  _ChatAdminState(String chatRoomID, String adminID, MUser User) {
    this.chatRoomId = chatRoomID;
    this.admin_id = adminID;
    this.user = User;
  }

  String latestMessageUserID = "";

  int Calculate(int a, int b) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(a);
    final date1 = DateTime.now();
    final diff = date1.difference(notificationDate);

    DateTime notificationDate1 = DateTime.fromMillisecondsSinceEpoch(b);
    final date2 = DateTime.now();
    final diff1 = date2.difference(notificationDate1);

    return diff.inMinutes - diff1.inMinutes;
  }

  Widget chatMessages() {
    String calculateTimeAgoSinceDate1(int time) {
      DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
      final date2 = DateTime.now();
      final diff = date2.difference(notificationDate);

      if (diff.inDays > 7)
        return DateFormat("dd/MM/yyyy").format(notificationDate);
      else if (diff.inDays >= 2 && diff.inDays <= 7)
        return DateFormat('EEEE').format(notificationDate);
      else if (diff.inDays > 1 && diff.inDays < 2)
        return 'Yesterday';
      else
        return DateFormat("kk:mm a").format(notificationDate);
    }

    String id = latestMessageUserID;
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  bool isDisplayTime = false;
                  String timeBreakSection = "";
                  if (index == snapshot.data!.docs.length - 1) {
                    isDisplayTime = true;
                    timeBreakSection = "";
                  } else {
                    if (id == snapshot.data!.docs[index]["sendBy"] &&
                        id != snapshot.data!.docs[index + 1]["sendBy"]) {
                      isDisplayTime = true;
                      id = snapshot.data!.docs[index + 1]["sendBy"];
                    }
                    if (Calculate(snapshot.data!.docs[index]["time"],
                            snapshot.data!.docs[index + 1]["time"]) >
                        60) {
                      timeBreakSection = calculateTimeAgoSinceDate1(
                          snapshot.data!.docs[index + 1]["time"]);
                    }
                  }
                  return MessageTile(
                    message: snapshot.data!.docs[index]["message"],
                    sendByMe: admin_id == snapshot.data!.docs[index]["sendBy"],
                    time: snapshot.data!.docs[index]["time"],
                    isDisplayTime: isDisplayTime,
                    timeBreakSection: timeBreakSection,
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      int time = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> chatMessageMap = {
        "sendBy": admin_id,
        "message": messageEditingController.text,
        'time': time,
      };

      database.addMessage(chatRoomId, chatMessageMap,
          messageEditingController.text, time, true, admin_id, true);

      setState(() {
        messageEditingController.text = "";
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .orderBy('time')
        .get()
        .then(((result) {
      String id = result.docs[0].get("sendBy");
      setState(() {
        latestMessageUserID = id;
      });
    }));

    database.getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String timeAgo = calculateTimeAgoSinceDate(latestMessageTime);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(user.getAvatarUri()),
                  maxRadius: 25,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        user.getName(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10.0),
        color: kFourthColor.withOpacity(0.1),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 115,
              child: chatMessages(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 16, bottom: 10),
                height: 70,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        decoration: InputDecoration(
                            hintText: "Type message...",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(right: 30, bottom: 40),
                child: FloatingActionButton(
                  onPressed: () {
                    addMessage();
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.pink.shade300,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int time;
  final bool isDisplayTime;
  final String timeBreakSection;

  MessageTile(
      {required this.message,
      required this.sendByMe,
      required this.time,
      required this.isDisplayTime,
      required this.timeBreakSection});

  @override
  Widget build(BuildContext context) {
    String timeChat = calculateTimeAgoSinceDate(time);
    return Column(children: [
      Container(
          padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: sendByMe ? 0 : 24,
              right: sendByMe ? 24 : 0),
          alignment: sendByMe ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment:
                sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: sendByMe
                    ? EdgeInsets.only(left: 30)
                    : EdgeInsets.only(right: 30),
                padding:
                    EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: sendByMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23))
                      : BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23)),
                  color: sendByMe ? Colors.white : Colors.pink.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 10,
              ),
              isDisplayTime
                  ? Container(
                      child: Text(
                        timeChat,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
            ],
          )),
      (timeBreakSection != "" && isDisplayTime)
          ? Container(
              height: 20,
              child: Center(
                  child: Text(
                timeBreakSection,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              )))
          : SizedBox(),
    ]);
  }

  String calculateTimeAgoSinceDate(int time) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if (diff.inDays > 7)
      return DateFormat("kk:mm dd/MM/yyyy").format(notificationDate);
    else if (diff.inDays >= 2 && diff.inDays <= 7)
      return DateFormat('kk:mm a EEEE').format(notificationDate);
    else if (diff.inDays > 1 && diff.inDays < 2)
      return DateFormat("kk:mm a").format(notificationDate) + ' Yesterday';
    else
      return DateFormat("kk:mm a").format(notificationDate);
  }
}
