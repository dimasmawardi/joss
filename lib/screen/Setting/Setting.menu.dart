import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Login/login.screen.dart';
import 'package:joss/screen/Setting/gantipassword.dart';
import 'package:joss/screen/Setting/profile.dart';
import 'package:joss/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  var setnama = "smart";
  var ver = "";

  void Keluarr() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    if (preferences.getString("token") == null) {
      // print("SharePref berhasil di hapus");
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('intro', false);
      Get.offAll(LoginPage());
    }
  }

  void gantiPassword() async {
    Get.to(GantiPassword(), transition: Transition.downToUp);
  }

  @override
  void initState() {
    // cekToken();
    getPrev();
    super.initState();
  }

  getPrev() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    var nama = prefs.get('nama').toString();
    String version = packageInfo.version;

    setState(() {
      setnama = nama;
      ver = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            "Pengaturan",
            style: GoogleFonts.poppins(),
          ),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.transparent,
              ),
              onPressed: () {}),
        ),
        body: ListView(
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            // ),
            Container(
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
              height: MediaQuery.of(context).size.height * 0.110,
              child: Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_pin,
                      size: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        setnama,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 10, right: 10),
            //   child: Card(
            //     child: ListTile(
            //       leading: Icon(Icons.person),
            //       title: Text(
            //         "Lihat Profile",
            //         style: GoogleFonts.poppins(),
            //       ),
            //       trailing: Icon(Icons.keyboard_arrow_right),
            //       //onTap: () {routing();}),
            //       onTap: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => Profile()),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.admin_panel_settings_outlined),
                  title: Text("Ubah Password", style: GoogleFonts.poppins()),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    gantiPassword();
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Keluar", style: GoogleFonts.poppins()),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Keluarr();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(ver),
            )
          ],
        ));
  }
}
