import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nagp_quiz/common/json_util.dart';
import 'package:nagp_quiz/models/category.dart';
import 'package:nagp_quiz/models/quiz.dart';
import 'package:nagp_quiz/models/quiz_history.dart';

class QuizStore {
  final String categoryJsonFileName = "assets/data/category.json";
  final String quizJsonFileName = "assets/data/quiz.json";
  static const String quizHistoryListKey = "QuizHistorysListKey";
  static SharedPreferences? prefs;
  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<List<Category>> loadCategoriesAsync() async {
    List<Category> categoryList = [];
    categoryList = await JsonUtil.loadFromJsonAsync<Category>(
        categoryJsonFileName, Category.jsonToObject);
    return categoryList;
  }

  Future<List<Quiz>> loadQuizListByCategoryAsync(int categoryId) async {
    List<Quiz> quizList = [];
    quizList = await JsonUtil.loadFromJsonAsync<Quiz>(
        quizJsonFileName, Quiz.jsonToObject);
    var categoryQuizList =
        quizList.where((element) => element.categoryId == categoryId).toList();
    return categoryQuizList;
  }

  Future<Category> getCategoryAsync(int categoryId) async {
    List<Category> categoryList = [];
    categoryList = await JsonUtil.loadFromJsonAsync<Category>(
        categoryJsonFileName, Category.jsonToObject);
    return categoryList.where((element) => element.id == categoryId).first;
  }

  Future<Quiz> getQuizByIdAsync(int quizId, int categoryId) async {
    var quizList = await loadQuizListByCategoryAsync(categoryId);
    var quiz = quizList.where((element) => element.id == quizId).first;
    return quiz;
  }

  Future<void> saveQuizHistory(QuizHistory history) async {
    var historyList = await loadQuizHistoryAsync();
    historyList.add(history);
    var historyJson = jsonEncode(historyList);
    prefs!.setString(quizHistoryListKey, historyJson);
  }

  Future<List<QuizHistory>> loadQuizHistoryAsync() async {
    List<QuizHistory> quizHistoryList = [];
    var ifExists = QuizStore.prefs!.containsKey(quizHistoryListKey);
    if (ifExists) {
      var quizHistoryJson = QuizStore.prefs!.getString(quizHistoryListKey);
      if (quizHistoryJson != null) {
        quizHistoryList = await JsonUtil.loadFromJsonStringAsync<QuizHistory>(
            quizHistoryJson, QuizHistory.jsonToObject);
        quizHistoryList = quizHistoryList.reversed.toList();
      }
    }
    return quizHistoryList;
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
