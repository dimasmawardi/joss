import 'dart:convert';

class SekolahModel {
  int idsekolah;
  String nama_sekolah, alamat, kontak, email, website;

  SekolahModel({
    this.idsekolah,
    this.nama_sekolah,
    this.alamat,
    this.kontak,
    this.email,
    this.website
  });

  factory SekolahModel.fromJson(Map<String, dynamic> map){
    return SekolahModel(
      idsekolah: int.parse(map["idsekolah"]),
      nama_sekolah: map["nama_sekolah"],
      alamat: map["alamat"],
      kontak: map["kontak"],
      email: map["email"],
      website: map["website"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idsekolah": idsekolah,
      "nama_sekolah": nama_sekolah,
      "alamat": alamat,
      "kontak": kontak,
      "email": email,
      "website": website,
    };
  }

  @override
  String toString() {
    return 'SekolahModel{idsekolah: $idsekolah, nama_sekolah: $nama_sekolah, alamat: $alamat, kontak: $kontak, email: $email, website: $website}';
  }
}

List<SekolahModel> sekolahmodelFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<SekolahModel>.from(data.map((item) => SekolahModel.fromJson(item)));
}

String sekolahmodelToJson(SekolahModel data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}