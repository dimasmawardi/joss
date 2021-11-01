import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Setting/edit.profile.dart';
import 'package:joss/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var nama = "nama";
  var email = "email";
  var nis = "nis";
  var alamat = "alamat";
  var notel = "notel";
  var profile = [];
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    getProfile();
    // // print("Eg. 1: ${oCcy.format(123456789.75)}");
  }

  getProfile() async {
    String myurl = "https://192.168.0.140/api/profile";
    final prefs = await SharedPreferences.getInstance();
    var idp = prefs.get('idpengguna');
    var a = prefs.get('token').toString();
    // print('a');
    // print(idp);
    await http.post(myurl, headers: {
      'Accept': 'application/json',
      // 'authorization': 'pass your key(optional)'
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1',
      'Authorization': 'Bearer ' + a
    }, body: {
      'idpengguna': idp.toString(),
    }).then((response) {
      // print(response.body);
      final data = jsonDecode(response.body);
      final a = data['data'];
      setState(() {
        nama = a['nama'];
        email = a['email'];
        // profile = a;
        isLoading = false;
        nis = a['nis'].toString();
        alamat = a['alamat'];
        notel = a['notelp'];
      });

      // getKantin();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: (isLoading == true)
          ? Container(
              padding: EdgeInsets.all(20.0),
              child: Center(
                  child: SpinKitWave(
                color: Colors.cyan[700],
                size: 50.0,
              )),
            )
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  height: MediaQuery.of(context).size.height * 0.110,
                  // color: Colors.white,
                  // margin: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.person_pin,
                        size: 50,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        nama,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 70,
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.all(10),
                            child: Text('Nama',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.1,
                            padding: EdgeInsets.all(2),
                            child: Text(':',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.6,
                            padding: EdgeInsets.all(0),
                            child: Text(nama,
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 70,
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.all(10),
                            child: Text('NIS',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.1,
                            padding: EdgeInsets.all(2),
                            child: Text(':',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.6,
                            padding: EdgeInsets.all(0),
                            child: Text(nis,
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 70,
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.all(10),
                            child: Text('Email',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.1,
                            padding: EdgeInsets.all(2),
                            child: Text(':',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.6,
                            padding: EdgeInsets.all(0),
                            child: Text(email,
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 70,
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.all(10),
                            child: Text('No Telp',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.1,
                            padding: EdgeInsets.all(2),
                            child: Text(':',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.6,
                            padding: EdgeInsets.all(0),
                            child: Text(notel,
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 70,
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.all(10),
                            child: Text('Alamat',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.1,
                            padding: EdgeInsets.all(2),
                            child: Text(':',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                          Container(
                            width: width * 0.6,
                            padding: EdgeInsets.all(0),
                            child: Text(alamat,
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
                GestureDetector(
                  onTap: () {
                    Get.to(EditProfile(
                      email: email,
                      alamat: alamat,
                      notel: notel,
                    ));
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 70,
                      width: width,
                      child: Card(
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Edit",
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
    );
  }
}
