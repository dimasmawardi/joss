import 'dart:convert';

import 'package:http/http.dart';
import 'package:joss/api/models/absensi/listsiswaabsensibk.model.dart';
import 'package:joss/api/models/informasi/informasi.model.dart';
import 'package:joss/api/models/kelas/indikatorabsesnsikelas.model.dart';
import 'package:joss/api/models/login/login.model.dart';
import 'package:joss/api/models/login/loginsend.model.dart';
import 'package:joss/api/models/responsecode/responsecode.model.dart';
import 'package:joss/api/models/sekolah/sekolah.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String BaseUrl = "http://192.168.0.140:8888/api";
//  final String BaseUrl = "http://192.168.100.38:8888/api";
  Client client = Client();
  ResponseCode responseCode;
  var urlcombokelas, urlcombokatinformasi;

  ApiService() {
    urlcombokelas = BaseUrl + "";
    urlcombokatinformasi = BaseUrl + "";
  }

//ADD SEKOLAH
  Future<bool> addSekolah(SekolahModel data) async {
    final response = await client.post(
      "$BaseUrl/sekolah",
      headers: {"content-type": "application/json"},
      body: sekolahmodelToJson(data),
    );
    Map message = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(message);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

//LOGIN
  Future<bool> loginIn(LoginSend data) async {
    var response = await client.post(
      "$BaseUrl/login",
      headers: {"content-type": "application/json"},
      body: loginsendToJson(data),
    );
    Map resultToken = jsonDecode(response.body);
    var logins = Login.fromJson(resultToken);
    Map responsecode = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsecode);
    // print(response.body);
    if (response.statusCode == 200) {
      //IDBIODATA DAN IDPENGGUNA ADA DI TOKEN
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("access_token", "${logins.access_token}");
      sp.setString("refresh_token", "${logins.refresh_token}");
      sp.setString("jabatan", "${logins.jabatan}");
      sp.setString("nama", "${logins.nama}");
      sp.setString("pgnama", "${logins.pgnama}");
      sp.setString("idsekolah", "1");
      return true;
    } else {
      return false;
    }
  }

//  CHECKING TOKEN
  Future<bool> checkingToken(String access_token) async {
    final response = await client.get("$BaseUrl/ceklogin",
        headers: {"Authorization": "BEARER ${access_token}"});
    // print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

//GET REFRESH TOKEN
  Future<String> refreshToken(String token) async {
    final response = await client.post(
      "$BaseUrl/newtoken",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"token": "${token}"}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];
    } else {
      return "";
    }
  }

  //INFORMASI
  Future<List<InformasiModel>> listInformasi(String token) async {
    final response = await client.get("$BaseUrl/informasi",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return informasiFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> TambahInformasi(InformasiModel data) async {
    final response = await client.post(
      "$BaseUrl/iinformasi",
      headers: {"Content-type": "application/json"},
      body: informasiToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> UbahInformasi(InformasiModel data) async {
    final response = await client.post(
      "$BaseUrl/uinformasi",
      headers: {"Content-type": "application/json"},
      body: informasiToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //ABSENSI
  Future<List<IndikatorAbsensiKelasModel>> listIndikatorKelas(
      String token) async {
    final response = await client.get("$BaseUrl/absensiindikator",
        headers: {"Authorization": "BEARER ${token}"});
    // print(response.body);
    if (response.statusCode == 200) {
      return indikatorkelasFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<ListSiswaAbsensiBKModel>> listSiswaAbsensiBK(
      String token, int idkelas) async {
    final response = await client.get("$BaseUrl/listabsensibk/${idkelas}",
        headers: {"Authorization": "BEARER ${token}"});
    // print(response.body);
    if (response.statusCode == 200) {
      return listSiswaAbsensiBKFromJson(response.body);
    } else {
      return null;
    }
  }
}
