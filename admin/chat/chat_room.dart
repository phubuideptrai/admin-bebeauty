import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MAddress.dart';
import 'package:bebeautyapp/model/MPreference.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/chat_services.dart';
import 'package:bebeautyapp/ui/admin/chat/chat_admin.dart';
import 'package:bebeautyapp/ui/admin/chat/search_chat_room_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRoomAdmin extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoomAdmin> {
  Stream<QuerySnapshot>? chatRoom;
  final FirebaseAuth auth = FirebaseAuth.instance;
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

  List<MUser> users = [];

  Widget chatRoomsList(String admin_id) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoom,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ChatRoomsTile(
                      users: users,
                      chatRoomId: snapshot.data!.docs[index]["chatRoomID"],
                      admin_id: admin_id,
                      latestMessage: snapshot.data!.docs[index]
                          ["latestMessage"],
                      isSeenByAdmin: snapshot.data!.docs[index]
                          ["isSeenByAdmin"],
                      isSendByAdmin: snapshot.data!.docs[index]
                              ["latestMessageSendBy"] ==
                          admin_id,
                      latestMessageTime: snapshot.data!.docs[index]
                          ["latestMessageTime"],
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUsers();
    getChatRooms();
    super.initState();
  }

  getChatRooms() async {
    database.getChatRooms().then((snapshots) {
      setState(() {
        chatRoom = snapshots;
      });
    });
  }

  getUsers() async {
    database.getUsers().then((snapshots) {
      List<MUser> list = [];
      for (DocumentSnapshot user in snapshots.docs) {
        list.add(MUser.fromSnapshot(user));
      }
      setState(() {
        users = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String admin_id = user_model.user.getID();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: BackButton(color: kPrimaryColor),
          title: Text(
            'Chat Rooms',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              color: kPrimaryColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchChatRoomAdmin()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.search,
                    color: kPrimaryColor,
                  )),
            )
          ],
        ),
        body: Column(children: [
          // SizedBox(height: 85),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      chatRoomsList(admin_id),
                    ]),
              ))
        ]));
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoomId;
  final String admin_id;
  final List<MUser> users;
  final String latestMessage;
  final bool isSeenByAdmin;
  final bool isSendByAdmin;
  final int latestMessageTime;
  int time = 0;
  bool isSeenByAdmin1 = false;

  ChatRoomsTile(
      {required this.users,
      required this.chatRoomId,
      required this.admin_id,
      required this.latestMessage,
      required this.isSeenByAdmin,
      required this.isSendByAdmin,
      required this.latestMessageTime});

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    isSeenByAdmin1 = isSendByAdmin;
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
    for (int i = 0; i < users.length; i++) {
      if (users[i].getID() == chatRoomId) {
        user = users[i];
      }
    }
    String displayLatestMessage = "";
    if (isSendByAdmin == true)
      displayLatestMessage = "You: " + latestMessage;
    else
      displayLatestMessage = latestMessage;
    String timeAgo = calculateTimeAgoSinceDate(latestMessageTime);
    time = latestMessageTime;
    if (time == 0) {
      isSeenByAdmin1 = true;
      timeAgo = "";
    }
    return GestureDetector(
        onTap: () {
          ChatServices().seen(chatRoomId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatAdmin(
                        chatRoomId: chatRoomId,
                        admin_id: admin_id,
                        user: user,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, 3),
                blurRadius: 5)
          ]),
          padding: EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    Image.network(user.getAvatarUri(), fit: BoxFit.fill).image,
                maxRadius: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.getName(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      displayLatestMessage,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            isSeenByAdmin ? Colors.grey.shade600 : Colors.black,
                        fontWeight:
                            isSeenByAdmin ? FontWeight.w300 : FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    timeAgo,
                    style: TextStyle(
                        fontWeight:
                            isSeenByAdmin ? FontWeight.w300 : FontWeight.w700),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    "assets/images/avt.png",
                    height: 10,
                    width: 10,
                    color: isSeenByAdmin1 ? Colors.transparent : Colors.red,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  String calculateTimeAgoSinceDate(int time) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if (diff.inDays > 8)
      return DateFormat("dd/MM/yyyy HH:mm").format(notificationDate);
    else if ((diff.inDays / 7).floor() >= 1)
      return "last week";
    else if (diff.inDays >= 2)
      return '${diff.inDays} days ago';
    else if (diff.inDays >= 1)
      return "1 day ago";
    else if (diff.inHours >= 2)
      return '${diff.inHours} hours ago';
    else if (diff.inHours >= 1)
      return "1 hour ago";
    else if (diff.inMinutes >= 2)
      return '${diff.inMinutes} minutes ago';
    else if (diff.inMinutes >= 1)
      return "1 minute ago";
    else if (diff.inSeconds >= 3)
      return '${diff.inSeconds} seconds ago';
    else
      return "Just now";
  }
}
