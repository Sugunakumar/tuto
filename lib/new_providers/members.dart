import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/new_providers/models.dart';

import '../data/constants.dart';

// mixin Members {
//   final db = FirebaseFirestore.instance;

//   List<Member> _members = [];

// // imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// // 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// // 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// // 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//   List<Member> get members {
//     return _members.toList();
//   }

//   // List<Member> get favoriteItems {
//   //   return _members.where((prodItem) => prodItem.isFavorite).toList();
//   // }

//   Member findMemberById(String id) {
//     return _members.firstWhere((prod) => prod.id == id);
//   }

//   Future<void> findMemberInList(List<String> ids) async {
//     List<Member> retrivedMembers =
//         _members.where((member) => ids.contains(member.id)).toList();
//     if (ids.length == retrivedMembers.length) {
//       print('retrivedMembers.length ' + retrivedMembers.length.toString());
//       return retrivedMembers;
//     } else {
//       await fetchAndSetMembers(ids);
//       return _members;
//     }
//   }

//   Future<void> fetchAndSetMembers(List<String> memberIds) async {
//     //String currentUserId = FirebaseAuth.instance.currentUser.uid;
//     print("fetchAndSetMembers");
//     final List<Member> loadedMembers = [];
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection(membersTableName)
//           .where(FieldPath.documentId, whereIn: memberIds)
//           .get();
//       if (snapshot.size == 0) return;

//       // final userFavSnapshot =
//       //     await db.collection(membersTableName).doc(currentUserId).get();

//       // List<dynamic> fav = userFavSnapshot.data().containsKey('favorites')
//       //     ? userFavSnapshot.get('favorites')
//       //     : null;

//       //print("fav : " + fav.toString());

//       snapshot.docs.forEach((doc) async {
//         loadedMembers.add(
//           Member(
//               id: doc.id,
//               email: doc.get('email'),
//               username: doc.get('username'),
//               imageURL: doc.data().containsKey('image_url')
//                   ? doc.get('image_url')
//                   : null),
//         );
//       });

//       //print(doc.id);

//       // final snapshotQ =
//       //     await FirebaseFirestore.instance.collectionGroup("questions").get();
//       // snapshotQ.docs.forEach((element) {
//       //   print("questions : " + element.get("answer"));
//       // });

//       // final snapshotChap =
//       //     await FirebaseFirestore.instance.collectionGroup("chapters").get();
//       // snapshotChap.docs.forEach((element) {
//       //   print("chapters : " + element.get("title"));
//       // });

//       // final snapshottrial = await FirebaseFirestore.instance
//       //     .collection(memberTable)
//       //     .doc("1Lf87x0AKGdW4CDnzkHc")
//       //     .collection("chapters")
//       //     .get();
//       // snapshottrial.docs.forEach((element) {
//       //   print("plain way : " + element.get("title"));
//       // });

//       _members = loadedMembers;
//       //notifyListeners();
//     } catch (e) {
//       throw (e);
//     }
//   }

//   // Future<void> addMember(Member member) async {
//   //   final newMember = {
//   //     'grade': member.grade,
//   //     'subject': member.subject.capitalizeFirstofEach,
//   //     'title': member.title.capitalizeFirstofEach,
//   //     'description': member.description,
//   //     'pages': member.pages,
//   //     'editor': member.editor.inCaps,
//   //     'publisher': member.publisher.capitalizeFirstofEach,
//   //     'imageUrl': member.imageUrl
//   //   };

//   //   try {
//   //     final addedMember = await FirebaseFirestore.instance
//   //         .collection(membersTableName)
//   //         .add(newMember);
//   //     final newMemberList = Member(
//   //       id: addedMember.id,
//   //       grade: member.grade,
//   //       subject: member.subject.capitalizeFirstofEach,
//   //       title: member.title.capitalizeFirstofEach,
//   //       description: member.description,
//   //       pages: member.pages,
//   //       editor: member.editor.inCaps,
//   //       publisher: member.publisher.capitalizeFirstofEach,
//   //       imageUrl: member.imageUrl,
//   //     );
//   //     //_members.add(newMemberList);
//   //     _members.insert(0, newMemberList);
//   //     // notifyListeners();
//   //   } catch (e) {
//   //     print(e);
//   //     throw e;
//   //   }
//   // }

//   // Future<void> updateMember(String id, Member newMember) async {
//   //   final prodIndex = _members.indexWhere((prod) => prod.id == id);
//   //   if (prodIndex >= 0) {
//   //     try {
//   //       await FirebaseFirestore.instance
//   //           .collection(membersTableName)
//   //           .doc(id)
//   //           .update({
//   //         'grade': newMember.grade,
//   //         'subject': newMember.subject,
//   //         'title': newMember.title,
//   //         'description': newMember.description,
//   //         'pages': newMember.pages,
//   //         'editor': newMember.editor,
//   //         'publisher': newMember.publisher,
//   //         'imageUrl': newMember.imageUrl
//   //       });
//   //       _members[prodIndex] = newMember;
//   //       notifyListeners();
//   //     } catch (e) {
//   //       print(e);
//   //       throw e;
//   //     }
//   //   } else {
//   //     print('...');
//   //   }
//   // }

//   // Future<void> deleteMember(String id) async {
//   //   final existingMemberIndex = _members.indexWhere((prod) => prod.id == id);
//   //   var existingMember = _members[existingMemberIndex];
//   //   _members.removeAt(existingMemberIndex);
//   //   // notifyListeners();

//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection(membersTableName)
//   //         .doc(id)
//   //         .delete();
//   //     existingMember = null;
//   //   } catch (e) {
//   //     _members.insert(existingMemberIndex, existingMember);
//   //     //notifyListeners();
//   //     throw e;
//   //   }
//   // }
// }
