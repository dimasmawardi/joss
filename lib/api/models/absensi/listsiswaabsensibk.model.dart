import 'dart:convert';

import 'dart:core';
class ListSiswaAbsensiBKModel {
  int nis, tingkat_kelas, idkelas;
  String nama, level_kelas;

  ListSiswaAbsensiBKModel(
      {this.nis,
      this.tingkat_kelas,
      this.idkelas,
      this.nama,
      this.level_kelas
  });

  factory ListSiswaAbsensiBKModel.fromJson(Map<String, dynamic> map){
    return ListSiswaAbsensiBKModel(
      nis: map["nis"],
      tingkat_kelas: map["tingkat_kelas"],
      idkelas: map["idkelas"],
      nama: map["nama"],
      level_kelas: map["level_kelas"]
    );
  }

  Map<String, dynamic>toJson(){
    return{
      "nis": nis,
      "tingkat_kelas": tingkat_kelas,
      "idkelas": idkelas,
      "nama": nama,
      "level_kelas": level_kelas
    };
  }

  @override
  String toString() {
    return 'ListSiswaAbsensiBKModel{nis: $nis, tingkat_kelas: $tingkat_kelas, idkelas: $idkelas, nama: $nama, level_kelas: $level_kelas}';
  }
}

List<ListSiswaAbsensiBKModel> listSiswaAbsensiBKFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ListSiswaAbsensiBKModel>.from(
      data.map((item) => ListSiswaAbsensiBKModel.fromJson(item)));
}

String ListSiswaAbsensiBKToJson(ListSiswaAbsensiBKModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
