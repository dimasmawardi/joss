import 'dart:convert';

class LoginSend{
  var idbiodata, password;

  LoginSend({this.idbiodata, this.password});

  factory LoginSend.fromJson(Map<String, dynamic> map){
    return LoginSend(
        idbiodata: map["idbiodata"],
        password: map["password"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idbiodata": idbiodata,
      "password": password
    };
  }

  @override
  String toString() {
    return 'LoginSend{idbiodata: $idbiodata, password: $password}';
  }
}

List<LoginSend> loginsendFromJson(String dataJson){
  final data = json.decode(dataJson);
  return List<LoginSend>.from(data.map((item) => LoginSend.fromJson(item)));
}

String loginsendToJson(LoginSend data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}