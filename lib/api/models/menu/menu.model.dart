import 'dart:convert';

class MenuModel {
  int idMenu, idkat_Menu, idsekolah;
  String token, judul, deskripsi, kategori, gambar;

  MenuModel(
      {this.token,
      this.idMenu,
      this.idkat_Menu,
      this.judul,
      this.deskripsi,
      this.kategori,
      this.gambar,
      this.idsekolah});

  factory MenuModel.fromJson(Map<String, dynamic> map) {
    return MenuModel(
        token: map['token'],
        idMenu: map['idMenu'],
        idkat_Menu: map['idkat_Menu'],
        judul: map['judul'],
        deskripsi: map['deskripsi'],
        kategori: map['kategori'],
        gambar: map['gambar'],
        idsekolah: map['idsekolah']);
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "idMenu": idMenu,
      "idkat_Menu": idkat_Menu,
      "judul": judul,
      "deskripsi": deskripsi,
      "kategori": kategori,
      "gambar": gambar,
      "idsekolah": idsekolah
    };
  }

  @override
  String toString() {
    return 'MenuModel{token: $token, idMenu: $idMenu, idkat_Menu: $idkat_Menu, judul: $judul, deskripsi: $deskripsi, kategori: $kategori, gambar: $gambar, idsekolah: $idsekolah}';
  }
}

List<MenuModel> MenuFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<MenuModel>.from(data.map((item) => MenuModel.fromJson(item)));
}

String MenuToJson(MenuModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
