class User {
  String? userName;
  String? email;
  String? password;
  String? mobileNumber;
  String? image;
  User(this.userName, this.email, this.password, this.mobileNumber, this.image);

  User.fromJson(dynamic json) {
    userName = json["userName"];
    email = json["email"];
    password = json["password"];
    mobileNumber = json["mobileNumber"];
    image = json["image"];
  }

  static jsonToObject(dynamic json) {
    return User(json["userName"], json["email"], json["password"],
        json["mobileNumber"], json["image"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userName"] = userName;
    map["email"] = email;
    map["password"] = password;
    map["mobileNumber"] = mobileNumber;
    map["image"] = image;
    return map;
  }
}
