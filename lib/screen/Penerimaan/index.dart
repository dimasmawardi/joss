import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Penerimaan/update.dart';
import 'package:joss/screen/SettingDataRS/add.dart';
import 'package:joss/screen/UpdateStokRS/update.dart';
import 'package:joss/utils/warna.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PenerimaanDataRS extends StatefulWidget {
  PenerimaanDataRS({Key key}) : super(key: key);

  @override
  _PenerimaanDataRSState createState() => _PenerimaanDataRSState();
}

class _PenerimaanDataRSState extends State<PenerimaanDataRS> {
  var isLoading = true;
  var dataView = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    String myurl =
        'https://apijoss.linas-media.com/public/api/get_data_barang_rs';
    final prefs = await SharedPreferences.getInstance();
    var id_cust = prefs.get('id_customer');

    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1'
      // 'authorization': 'pass your key(optional)'
    }, body: {
      'id': id_cust.toString()
    }).then((response) {
      // print(response.body);
      final data = jsonDecode(response.body);
      // Toast.show(myurl, context,
      //     duration: 5, gravity: Toast.BOTTOM, backgroundColor: Colors.orange);
      // print(data['status']);
      if (data['status'] == true) {
        setState(() {
          dataView = data['data'];
          isLoading = false;
        });
      }
      print(dataView);
      // print(dataView.length);
      // print(dataView.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Penerimaan Data RS",
            style: GoogleFonts.poppins(),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: (isLoading == true)
            ? SpinKitThreeBounce(
                color: primaryColor,
                size: 40.0,
              )
            : (dataView.length == 0)
                ? Center(
                    child: Text(
                      "Kosong",
                      style: GoogleFonts.poppins(),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: (dataView.length == 0) ? 0 : dataView.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                              elevation: 3,
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: width * 0.3,
                                            child: Text(
                                              "Nama Barang",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.02,
                                            child: Text(
                                              ":",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.6,
                                            child: Text(
                                              dataView[index]['nama_barang'],
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: width * 0.3,
                                            child: Text(
                                              "Sisa Stok",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.02,
                                            child: Text(
                                              ":",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.6,
                                            child: Text(
                                              dataView[index]['stok_barang'],
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: width * 0.3,
                                            child: Text(
                                              "Kebutuhan Saat Ini",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.02,
                                            child: Text(
                                              ":",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.6,
                                            child: Text(
                                              dataView[index]
                                                      ['kebutuhan_saat_ini']
                                                  .toString(),
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: width * 0.3,
                                            child: Text(
                                              "Jam Kritis",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.02,
                                            child: Text(
                                              ":",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.6,
                                            child: Text(
                                              (int.parse(dataView[index]
                                                              ['jam_kritis']) ==
                                                          null
                                                      ? 0
                                                      : int.parse(dataView[
                                                                      index][
                                                                  'jam_kritis']) <
                                                              0 ||
                                                          int.parse(dataView[
                                                                      index][
                                                                  'jam_kritis']) ==
                                                              null)
                                                  ? '0 Jam'
                                                  : dataView[index]
                                                              ['jam_kritis']
                                                          .toString() +
                                                      ' Jam',
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: width * 0.8,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: FlatButton(
                                              child: Text(
                                                  "Tambah Penerimaan Barang RS",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins()),
                                              textColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                              color: primaryred,
                                              onPressed: () {
                                                Get.to(PEnerimaanStokDataRS(
                                                  data: dataView[index],
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )))
                        ],
                      );
                    }),
      );
    });
  }
}
