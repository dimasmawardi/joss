import 'dart:convert';

class InformasiModel{
  int idinformasi, idkat_informasi, idsekolah;
  String token, judul, deskripsi, kategori, gambar;

  InformasiModel({
    this.token,
    this.idinformasi,
    this.idkat_informasi,
    this.judul,
    this.deskripsi,
    this.kategori,
    this.gambar,
    this.idsekolah
  });

  factory InformasiModel.fromJson(Map<String, dynamic>map){
    return InformasiModel(
      token: map['token'],
      idinformasi: map['idinformasi'],
      idkat_informasi: map['idkat_informasi'],
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      kategori: map['kategori'],
      gambar: map['gambar'],
      idsekolah: map['idsekolah']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "token": token,
      "idinformasi": idinformasi,
      "idkat_informasi": idkat_informasi,
      "judul": judul,
      "deskripsi": deskripsi,
      "kategori": kategori,
      "gambar": gambar,
      "idsekolah": idsekolah
    };
  }

  @override
  String toString() {
    return 'InformasiModel{token: $token, idinformasi: $idinformasi, idkat_informasi: $idkat_informasi, judul: $judul, deskripsi: $deskripsi, kategori: $kategori, gambar: $gambar, idsekolah: $idsekolah}';
  }
}

List<InformasiModel> informasiFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<InformasiModel>.from(data.map((item) => InformasiModel.fromJson(item)));
}

String informasiToJson(InformasiModel data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
