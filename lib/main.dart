import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joss/screen/Home/index.dart';
import 'package:joss/screen/Login/login.screen.dart';
import 'package:joss/screen/Widgets/navigationbar.screen.dart';
import 'package:joss/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new GetMaterialApp(
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(name: '/', page: () => MyApp()),
      GetPage(name: '/Login', page: () => LoginPage()),
      GetPage(name: '/Home', page: () => Home()),
    ],
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var page;
  @override
  void initState() {
    super.initState();
    checkIntro();
  }

  checkIntro() async {
    final prefs = await SharedPreferences.getInstance();
    var id_cust = prefs.get('id_customer');
    // print(id_cust);
    if (id_cust != null) {
      setState(() {
        page = NavigationBarPage();
      });
    } else {
      setState(() {
        page = LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SplashScreen(
      seconds: 5,
      photoSize: 200,
      // useLoader: false,

      navigateAfterSeconds: page,
      // title: new Text(
      //   'Sekolah Smart',
      //   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20.0),
      // ),
      image: new Image.asset(
        'assets/logos/joss.png',
        width: 300,
        height: 400,
      ),
      backgroundColor: primaryColor,
      loaderColor: Colors.white,
    );
  }
}
