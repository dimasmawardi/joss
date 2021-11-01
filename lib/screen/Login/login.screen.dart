import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Widgets/navigationbar.screen.dart';
import 'package:joss/utils/TextFieldController.dart';
import 'package:joss/utils/warna.dart';
import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false, _obsecureText = true;
  bool _fieldEmail, _fieldPassword;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  var uuid = '';

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void initState() {
    // cekToken();

    super.initState();
  }

  authenticate(idbio, pass) async {
    String myurl = 'https://apijoss.linas-media.com/public/api/login';

    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1'
      // 'authorization': 'pass your key(optional)'
    }, body: {
      'username': idbio,
      'password': pass,
      'uuid': uuid
    }).then((response) {
      // print(response.body);
      final data = jsonDecode(response.body);
      // Toast.show(myurl, context,
      //     duration: 5, gravity: Toast.BOTTOM, backgroundColor: Colors.orange);
      // print(data['status']);
      var user = data['data'];
      if (data['status'] == true) {
        savePref(user['id_customer'], user['nama_customer']);
        Get.offAll(NavigationBarPage());
      } else {
        // progressDialog.hide();
        setState(() {
          _isLoading = false;
        });
        showAlertGagalLogin(context);
      }
    });
  }

  savePref(id_cus, nama) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt("id_customer", int.parse(id_cus));
      prefs.setString("nama", nama);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            key: _scaffoldState,
            color: primaryColor,
            padding: EdgeInsets.all(25.0),
            width: double.infinity,
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logos/joss.png',
                      height: 150,
                      width: 200,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "JOSS",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 5),
                    ),
                    Text(
                      "JATENG OXYGEN STOCK SYSTEM",
                      style: GoogleFonts.poppins(
                          // fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                          letterSpacing: 5),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    _buildTextFieldEmail(), //textbox username (email / no hp)
                    //textbox password
                    SizedBox(
                      height: 5,
                    ),
                    _buildTextFieldPassword(), //textbox password
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FlatButton(
                          child: (_isLoading == false)
                              ? Text("MASUK",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21))
                              : // button login
                              Text("Loading",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21)), // button login
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          color: primaryred,
                          onPressed: () {
                            if (_fieldEmail == null ||
                                _fieldPassword == null ||
                                !_fieldEmail ||
                                !_fieldPassword) {
//                              _scaffoldState.currentState.showSnackBar(SnackBar(
//                                content: Text("Harap isi Semua Kolom"),
//                              ));
                              // print("Harap Diisi!");
                              return;
                            }

                            String nomorinduk =
                                _controllerEmail.text.toString();
                            String password =
                                _controllerPassword.text.toString();

                            // print(nomorinduk + password);
                            if (_isLoading == false) {
                              // print('dsa');
                              authenticate(nomorinduk, password);
                            }
                            setState(() => _isLoading = true);
                            // Get.offAll(Home());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextFieldController(
      child: TextField(
        controller: _controllerEmail,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          icon: Icon(
            Icons.mail,
            color: primaryColor,
          ),
          hintText: "Username",
          fillColor: Colors.white,
          border: InputBorder.none,
          errorText: _fieldEmail == null || _fieldEmail
              ? null
              : "Username Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _fieldEmail) {
            setState(() => _fieldEmail = isFieldValid);
          }
        },
      ),
    );
  }

  Widget _buildTextFieldPassword() {
    return TextFieldController(
      child: TextField(
        controller: _controllerPassword,
        keyboardType: TextInputType.text,
        obscureText: _obsecureText,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
          ),
          hintText: "Password",
          fillColor: Colors.white,
          border: InputBorder.none,
          errorText: _fieldPassword == null || _fieldPassword
              ? null
              : "Password Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _fieldPassword) {
            setState(() => _fieldPassword = isFieldValid);
          }
        },
      ),
    );
  }

  showAlertGagalLogin(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Login Gagal"),
      content: Text(
          "Pastikan data yang anda masukkan sudah sesuai dengan Username beserta Password yang berlaku."),
      actions: [
        okButton,
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
