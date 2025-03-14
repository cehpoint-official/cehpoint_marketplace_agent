// ignore_for_file: unused_import

import 'package:cehpoint_marketplace_agent/common/constant.dart';
import 'package:cehpoint_marketplace_agent/pages/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:intl/intl.dart';

class CallsProperty extends StatefulWidget {
  final String email;
  final String username;
  const CallsProperty({
    super.key,
    required this.email,
    required this.username,
  });

  @override
  State<CallsProperty> createState() => _CallsPropertyState();
}

class _CallsPropertyState extends State<CallsProperty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      // drawer: NavDrawer(
      //   email: widget.email,
      //   name: widget.username,
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Agents')
            .doc(widget.email)
            .collection('Call History')
            .orderBy('Date-Time', descending: true)
            .snapshots(),

        // future: historyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                bool detailed = false;
                final document = documents[index];
                Timestamp timestamp = document['Date-Time'];
                DateTime dateTime = timestamp.toDate();
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(dateTime);
                String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return ListTile(
                    onTap: () {
                      if (detailed) {
                        setState(() {
                          detailed = false;
                        });
                      } else {
                        setState(() {
                          detailed = true;
                        });
                      }
                    },
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (document['User Type'] == "Seller")
                                ? "SELLER"
                                : "BUYER",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: appColor,
                                fontSize: 13),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        if (document['Direction'] == 'Outgoing')
                                          const Icon(
                                            Icons.call_made_rounded,
                                            color: Colors.green,
                                          ),
                                        if (document['Direction'] == 'Incoming')
                                          const Icon(
                                            Icons.call_received_rounded,
                                            color: Colors.red,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        document['Name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: ZegoSendCallInvitationButton(
                                  onPressed: (code, message, p2) async {
                                    DateTime nowTime = DateTime.now();
                                    await FirebaseFirestore.instance
                                        .collection('Agents')
                                        .doc(widget.email)
                                        .collection('Call History')
                                        .doc()
                                        .set({
                                      'Name': document['Name'],
                                      'CallID': document['CallID'],
                                      'Direction': "Outgoing",
                                      'Date-Time': nowTime,
                                      'User Type': document['User Type'],
                                    });
                                    await FirebaseFirestore.instance
                                        .collection(
                                            (document['User Type'] == "Seller")
                                                ? "users"
                                                : document['User Type'])
                                        .doc(document['CallID'])
                                        .collection('Call History')
                                        .doc()
                                        .set({
                                      'Name': widget.username,
                                      'CallID': widget.email,
                                      'Direction': "Incoming",
                                      'Date-Time': nowTime,
                                      'User Type': 'Agents',
                                    });
                                    setState(() {});
                                  },
                                  notificationTitle: widget.username,
                                  notificationMessage: "Agent is calling you",
                                  buttonSize: const Size(50, 50),
                                  icon:
                                      ButtonIcon(icon: const Icon(Icons.call)),
                                  iconSize: const Size(40, 40),
                                  isVideoCall: false,
                                  resourceID: "zego_sokoni",
                                  invitees: [
                                    ZegoUIKitUser(
                                      id: document['CallID'],
                                      name: document['Name'],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (detailed)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Date",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 81, 81, 81)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Time",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 81, 81, 81)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          }
        },
      ),
    );
  }
}
