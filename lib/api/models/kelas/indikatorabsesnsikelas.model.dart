import 'dart:convert';

class IndikatorAbsensiKelasModel {
  int idkelas_siswa, jumlah_siswa, jumlah_siswa_diabsen;
  String level_kelas;

  IndikatorAbsensiKelasModel({
    this.idkelas_siswa,
    this.jumlah_siswa,
    this.jumlah_siswa_diabsen,
    this.level_kelas
  });

  factory IndikatorAbsensiKelasModel.fromJson(Map<String, dynamic> map){
    return IndikatorAbsensiKelasModel(
        idkelas_siswa: map["idkelas_siswa"],
      jumlah_siswa: map["jumlah_siswa"],
      jumlah_siswa_diabsen: map["jumlah_siswa_diabsen"],
      level_kelas: map["level_kelas"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idkelas_siswa": idkelas_siswa,
      "jumlah_siswa": jumlah_siswa,
      "jumlah_siswa_diabsen": jumlah_siswa_diabsen,
      "level_kelas": level_kelas
    };
  }

  @override
  String toString() {
    return 'IndikatorAbsensiKelasModel{idkelas_siswa: $idkelas_siswa, jumlah_siswa: $jumlah_siswa, jumlah_siswa_diabsen: $jumlah_siswa_diabsen, level_kelas: $level_kelas}';
  }
}

List<IndikatorAbsensiKelasModel> indikatorkelasFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<IndikatorAbsensiKelasModel>.from(
      data.map((item) => IndikatorAbsensiKelasModel.fromJson(item)));
}

String indikatorkelasToJson(IndikatorAbsensiKelasModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
