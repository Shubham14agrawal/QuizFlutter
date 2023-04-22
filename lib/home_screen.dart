import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nagp_quiz/auth/login/login.dart';
import 'package:nagp_quiz/common/theme_helper.dart';
import 'package:nagp_quiz/profile_screen.dart';
import 'package:nagp_quiz/quiz_results_screen.dart';
import 'package:nagp_quiz/stores/quiz_store.dart';
import 'auth/auth_repository.dart';
import 'quiz_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final QuizStore _quizStore = QuizStore();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: navigationDrawer(),
        body: Container(
          alignment: Alignment.center,
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: Column(
            children: [
              drawerToggleButton(),
              Column(
                children: [
                  headerText("NAGP Quiz App"),
                  const SizedBox(height: 24),
                  ...homeScreenButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer navigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(200, 95, 159, 180),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Quiz App",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                Text(
                  "Version: 1.00",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfileScreen()));
            },
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ListTile(
            title: const Text('Results'),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QuizHistoryScreen()));
            },
          ),
          ListTile(
            title: const Text('Quiz Category'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QuizCategoryScreen()));
            },
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            title: const Text('Exit'),
            onTap: () {
              AuthRepository.logOutUser();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RepositoryProvider(
                        create: (context) => AuthRepository(),
                        child: LoginView(),
                      )));
            },
          ),
        ],
      ),
    );
  }

  Widget drawerToggleButton() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: const Image(
          image: AssetImage("assets/icons/menu.png"),
          width: 36,
        ),
        onTap: () {
          _key.currentState!.openDrawer();
        },
      ),
    );
  }

  Text headerText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 72,
          color: ThemeHelper.accentColor,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
                color: ThemeHelper.shadowColor,
                offset: const Offset(-5, 5),
                blurRadius: 30)
          ]),
    );
  }

  List<Widget> homeScreenButtons(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QuizCategoryScreen()));
        },
        child: const Text(
          "Quiz Category",
          style: TextStyle(
              fontSize: 35, color: Color.fromARGB(255, 239, 239, 232)),
        ),
      ),
      const Divider(
        thickness: 2,
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QuizHistoryScreen()));
        },
        child: const Text(
          "Results",
          style: TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 247, 249, 238)),
        ),
      ),
    ];
  }
}
