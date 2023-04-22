import 'package:flutter/material.dart';
import 'package:nagp_quiz/common/theme_helper.dart';
import 'package:nagp_quiz/stores/quiz_store.dart';

import 'auth/auth_repository.dart';
import 'models/dto/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User currentUser = User("", "", "", "", "");
  late AuthRepository store;

  @override
  void initState() {
    store = AuthRepository();
    store.loadCurrentUserAsync().then((value) {
      setState(() {
        currentUser = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: Column(
            children: [
              screenHeader(),
              Text(
                "Profile",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              categoryListViewItem(currentUser),
            ],
          ),
        ),
      ),
    );
  }

  screenHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            child: const Image(
              image: AssetImage("assets/icons/back.png"),
              width: 40,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            "Home",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget quizHistoryViewItem(User quiz) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(10),
        decoration: ThemeHelper.roundBoxDeco(),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10),
            child: SizedBox(
              height: 59,
              width: 10,
              child: Container(
                decoration: ThemeHelper.roundBoxDeco(
                    color: ThemeHelper.primaryColor, radius: 10),
              ),
            ),
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Email Id: ${quiz.email}",
                style: const TextStyle(fontSize: 20),
              ),
              Text("Mobile: ${quiz.mobileNumber}",
                  style:
                      TextStyle(color: ThemeHelper.accentColor, fontSize: 18)),
            ]),
          ),
        ]));
  }

  Widget categoryListViewItem(User quiz) {
    return Container(
      margin: const EdgeInsets.only(top: 100, bottom: 40),
      width: 300,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.memory(
            QuizStore.dataFromBase64String(
                (currentUser.image ?? currentUser.image)!),
            width: 130,
          ),
          Text(
            "Name : ${quiz.userName}",
            style: const TextStyle(fontSize: 20),
          ),
          quizHistoryViewItem(quiz)
        ],
      ),
    );
  }
}
