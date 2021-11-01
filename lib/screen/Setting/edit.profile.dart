import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfile extends StatefulWidget {
  final email;
  final alamat;
  final notel;
  EditProfile({Key key, this.email, this.alamat, this.notel}) : super(key: key);
  @override
  _EditProfileSettingsState createState() => _EditProfileSettingsState();
}

bool _obscureText = true;

class _EditProfileSettingsState extends State<EditProfile> {
  final oCcy = new NumberFormat("#,##0", "en_US");

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  final email = TextEditingController();
  final alamat = TextEditingController();
  final notel = TextEditingController();
  bool _showPassword = true;

  String nama = "";
  String saldo = "0";
  String nis = '';

  @override
  void initState() {
    email.text = widget.email;
    alamat.text = widget.alamat;
    notel.text = widget.notel;
    super.initState();
  }

  signOut() async {
    // Get.offAll()
  }

  gantiProfile(email, alamat, no) async {
    // // print(pass);
    final prefs = await SharedPreferences.getInstance();
    var a = prefs.getString('token');
    var id = prefs.get('idpengguna');

    String myurl = "https://192.168.0.140/api/updateprofile";
    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1',
      'Authorization': 'Bearer ' + a
      // 'authorization': 'pass your key(optional)'
    }, body: {
      'idpengguna': id.toString(),
      'email': email,
      'alamat': alamat,
      'notelp': no
    }).then((response) {
      // print(response.body);
      // final data = jsonDecode(response.body);
      // final makanan = data['data'];
      // // print(makanan);

      // // print(datahistori.length);
      signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height - 126;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text('Edit Profile'),
        ),
        body: Container(
            // color: Colors.red,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, left: 26.0, right: 24.0),
                    child: Text(
                      "Email",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 8.0, left: 24.0, right: 24.0),
                    child: Card(
                      child: TextFormField(
                        controller: email,

                        // obscureText: this._showPassword,
                        textAlign: TextAlign.left,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: widget.email,
                          hintStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, left: 26.0, right: 24.0),
                    child: Text(
                      "Alamat",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 8.0, left: 24.0, right: 24.0),
                    child: Card(
                      child: TextFormField(
                        controller: alamat,
                        // obscureText: this._showPassword,
                        textAlign: TextAlign.left,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: widget.alamat,
                          hintStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, left: 26.0, right: 24.0),
                    child: Text(
                      "No Telephone",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 8.0, left: 24.0, right: 24.0),
                    child: Card(
                      child: TextFormField(
                        controller: notel,
                        // obscureText: this._showPassword,
                        textAlign: TextAlign.left,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: widget.notel,
                          hintStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, bottom: 8.0, left: 24.0, right: 24.0),
                    child: SizedBox(
                      width: screenWidth,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          gantiProfile(email.text, alamat.text, notel.text);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text("Simpan".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                      ),
                    )),
              ],
            )));
  }
}
