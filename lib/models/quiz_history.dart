class QuizHistory {
  int quizId = 0;
  int categoryId = 0;
  String quizTitle = "";
  String score = "";
  DateTime quizDate = DateTime.now();
  String status = "";

  QuizHistory(this.quizId, this.quizTitle, this.categoryId, this.score,
      this.quizDate, this.status);

  QuizHistory.fromJson(dynamic json) {
    quizId = json["quizId"];
    quizTitle = json["quizTitle"];
    categoryId = json["categoryId"];
    score = json["score"];
    quizDate = json["quizDate"];
    status = json["status"];
  }

  static jsonToObject(dynamic json) {
    return QuizHistory(json["quizId"], json["quizTitle"], json["categoryId"],
        json["score"], DateTime.parse(json["quizDate"]), json["status"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["quizId"] = quizId;
    map["quizTitle"] = quizTitle;
    map["categoryId"] = categoryId;
    map["score"] = score;
    map["quizDate"] = quizDate.toIso8601String();
    map["status"] = status;
    return map;
  }
}
