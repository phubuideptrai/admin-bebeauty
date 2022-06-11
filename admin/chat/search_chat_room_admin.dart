import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MAddress.dart';
import 'package:bebeautyapp/model/MPreference.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/chat_services.dart';
import 'package:bebeautyapp/ui/admin/chat/chat_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SearchChatRoomAdmin extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchChatRoomAdmin> {
  ChatServices database = new ChatServices();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot? searchResultSnapshot;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await database
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(String admin_id) {
    return haveUserSearched
        ? Container(
            height: MediaQuery.of(context).size.height - 80,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: searchResultSnapshot!.docs.length,
              itemBuilder: (context, index) {
                return userTile(
                    searchResultSnapshot!.docs[index]["name"],
                    searchResultSnapshot!.docs[index]["id"],
                    admin_id,
                    searchResultSnapshot!.docs[index]["photo"]);
              },
            ))
        : Container();
  }

  Widget userTile(String name, String user_id, String admin_id, String photo) {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                Image.network(user.getAvatarUri(), fit: BoxFit.fill).image,
            maxRadius: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              String chatRoomId = user_id;
              database.seen(chatRoomId);
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
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String admin_id = user_model.user.getID();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: BackButton(color: kPrimaryColor),
        title: Text(
          'Search',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: kPrimaryColor,
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Color(0x54FFFFFF),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              filled: true,
                              hintText: "Search name...",
                              hintStyle: const TextStyle(color: Colors.black38),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 47,
                              width: 47,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(13),
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                                height: 20,
                                width: 20,
                              )),
                        )
                      ],
                    ),
                  ),
                  userList(admin_id)
                ],
              ),
            ),
    );
  }
}
