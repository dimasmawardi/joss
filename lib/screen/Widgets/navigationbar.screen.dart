import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joss/screen/Home/index.dart';
import 'package:joss/screen/Login/login.screen.dart';
import 'package:joss/screen/Setting/Setting.menu.dart';
import 'package:joss/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationBarPage extends StatefulWidget {
  @override
  _NavigationBarPage createState() => _NavigationBarPage();
}

class _NavigationBarPage extends State<NavigationBarPage> {
  int currentTab = 0;
  PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();
  // ApiService _apiService = new ApiService();
  SharedPreferences sp;
  var jabatan;
  getJabatan() async {
    final prefs = await SharedPreferences.getInstance();
    var jbt = prefs.get('jabatan').toString();
    // print("sas");
    // print(jbt);

    setState(() {
      jabatan = jbt;
    });
  }

  @override
  void initState() {
    // cekToken();
    getJabatan();
    super.initState();
  }
  // var setnama, access_token, refresh_token, jabatan, nama, pgnama;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: primaryColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.white,
        borderRadius: 25.0,
        width: 540,
        itemBorderRadius: 35,
        iconSize: 28,
        fontSize: 10,
        onTap: (int val) {
          switch (val) {
            case 0:
              {
                currentScreen = Home();
              }
              break;
            case 1:
              {
                currentScreen = SettingPage();
              }
              break;
            default:
              {
                // print("Navigasi Tidak Ditemukan!");
              }
          }

          setState(() {
            currentTab = val;
          });
        },
        currentIndex: currentTab,
        items: [
          FloatingNavbarItem(icon: Icons.widgets, title: 'Home'),
          FloatingNavbarItem(icon: Icons.settings, title: 'Profile'),
        ],
        selectedBackgroundColor: Colors.white,
        // itemBuilder: (context, items) {
        // },
      ),
    );
  }

  AlertTokenValidation(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Sesi Anda Berakhir!"),
      content: Text("Harap masukkan kembali NIP/NIS beserta Password."),
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
