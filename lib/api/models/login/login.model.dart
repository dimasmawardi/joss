import 'dart:convert';

class Login{

  var message, access_token, refresh_token, jabatan, nama, pgnama;
  Login({
    this.message,
    this.access_token,
    this.refresh_token,
    this.nama,
    this.jabatan,
    this.pgnama
  });

  factory Login.fromJson(Map<String, dynamic> map){
    return Login(
      message: map["message"],
      access_token: map["access_token"],
      refresh_token: map["refresh_token"],
      nama: map["nama"],
      jabatan: map["jabatan"],
      pgnama: map["pgnama"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "message": message,
      "access_token": access_token,
      "refresh_token": refresh_token,
      "nama": nama,
      "jabatan": jabatan,
      "pgnama": pgnama
    };
  }

  @override
  String toString(){
    return 'Login{'
        'message: $message,'
        'access_token: $access_token,'
        'refresh_token: $refresh_token,'
        'nama: $nama,'
        'jabatan: $jabatan,'
        'pgnama: $pgnama}';
  }

}

List<Login> loginFromJson(String dataJson){
  final data = json.decode(dataJson);
  return List<Login>.from(data.map((item) => Login.fromJson(item)));
}

String loginToJson(Login data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}