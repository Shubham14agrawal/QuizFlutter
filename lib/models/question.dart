import 'option.dart';

class Question {
  late String text;
  late List<Option> options;

  Question(
    this.text,
    this.options,
  );

  Question.fromJson(dynamic json) {
    text = json["text"];
    options = List<Option>.from(json["options"].map((x) => Option.fromJson(x)));
  }

  static jsonToObject(dynamic json) {
    List<Option> options = [];
    if (json["options"] != null) {
      options =
          List<Option>.from(json["options"].map((x) => Option.fromJson(x)));
    }
    return Question(json["text"], options);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = text;
    map["options"] = List<dynamic>.from(options.map((x) => x.toJson()));
    return map;
  }
}
