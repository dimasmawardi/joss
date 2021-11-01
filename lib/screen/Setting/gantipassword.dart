import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Login/login.screen.dart';
import 'package:joss/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class GantiPassword extends StatefulWidget {
  @override
  _GantiPasswordSettingsState createState() => _GantiPasswordSettingsState();
}

bool _obscureText = true;

class _GantiPasswordSettingsState extends State<GantiPassword> {
  final oCcy = new NumberFormat("#,##0", "en_US");

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  final pass = TextEditingController();
  bool _showPassword = true;

  String nama = "";
  String saldo = "0";
  String nis = '';

  @override
  void initState() {
    super.initState();
  }

  signOut() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.clear();
//
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  gantiPassword(pass) async {
    // print(pass);
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.get('id_customer');
    print(pass);

    String myurl = "https://apijoss.linas-media.com/api/gantipassword";
    await http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      'id_customer': id.toString(),
      'password': pass
    }).then((response) {
      print(response.body);
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
          title: Text('Ganti Password'),
        ),
        body: Container(
            // color: Colors.red,
            width: screenWidth,
            height: screenHeight / 3,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, bottom: 8.0, left: 24.0, right: 24.0),
                    child: Card(
                      child: TextField(
                        controller: pass,
                        obscureText: this._showPassword,
                        textAlign: TextAlign.left,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: this._showPassword
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                            onPressed: () {
                              setState(() =>
                                  this._showPassword = !this._showPassword);
                            },
                          ),
                          hintText: "Password Baru",
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
                          gantiPassword(pass.text);
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
