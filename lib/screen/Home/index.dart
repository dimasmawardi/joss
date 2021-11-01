import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Penerimaan/index.dart';
import 'package:joss/screen/SettingDataRS/index.dart';
import 'package:joss/screen/UpdateStokRS/index.dart';
import 'package:joss/screen/ViewDataRS/index.dart';
import 'package:joss/utils/warna.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(SettingDataRS(), transition: Transition.zoom);
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    width: width,
                    height: height / 6,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF6ab8f7),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("Setting Data Rumah Sakit",
                              style: GoogleFonts.poppins(
                                  fontSize: 29, color: Colors.white)),
                        ),
                        Expanded(
                            child: Icon(
                          Icons.medical_services,
                          size: 80,
                          color: Colors.white,
                        ))
                      ],
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(ViewDataRs(), transition: Transition.zoom);
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    width: width,
                    height: height / 6,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFffca5b),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("View Data Rumah Sakit",
                              style: GoogleFonts.poppins(
                                  fontSize: 29, color: Colors.white)),
                        ),
                        Expanded(
                            child: Icon(
                          Icons.data_usage,
                          size: 80,
                          color: Colors.white,
                        ))
                      ],
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(UpdateDataRS(), transition: Transition.zoom);
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    width: width,
                    height: height / 6,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFfe85be),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("Update Stok Rumah Sakit",
                              style: GoogleFonts.poppins(
                                  fontSize: 29, color: Colors.white)),
                        ),
                        Expanded(
                            child: Icon(
                          Icons.system_update,
                          size: 80,
                          color: Colors.white,
                        ))
                      ],
                    )),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Get.to(PenerimaanDataRS(), transition: Transition.zoom);
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                      width: width,
                      height: height / 6,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF534d82),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("Penerimaan Data Rumah Sakit",
                                style: GoogleFonts.poppins(
                                    fontSize: 29, color: Colors.white)),
                          ),
                          Expanded(
                              child: Icon(
                            Icons.call_received,
                            size: 80,
                            color: Colors.white,
                          ))
                        ],
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
