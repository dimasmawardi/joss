import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/SettingDataRS/add.dart';
import 'package:joss/screen/SettingDataRS/update.dart';
import 'package:joss/screen/Widgets/navigationbar.screen.dart';
import 'package:joss/utils/warna.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingDataRS extends StatefulWidget {
  SettingDataRS({Key key}) : super(key: key);

  @override
  _SettingDataRSState createState() => _SettingDataRSState();
}

class _SettingDataRSState extends State<SettingDataRS> {
  var isLoading = true;
  var dataView = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    // print('apa');
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
      // print(dataView.length);
      // print(dataView.length);
      // print(dataView.length);
    });
  }

  hapus(idbarang) async {
    // print
    String myurl =
        'https://apijoss.linas-media.com/public/api/delete_setting_data_rs';
    final prefs = await SharedPreferences.getInstance();
    var id_cust = prefs.get('id_customer');

    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1'
      // 'authorization': 'pass your key(optional)'
    }, body: {
      'id_customer': id_cust.toString(),
      'id_barang_detail': idbarang.toString(),
    }).then((response) {
      // print(response.body);
      final data = jsonDecode(response.body);
      Get.offAll(NavigationBarPage());
      Get.to(SettingDataRS());
      Get.snackbar("Hapus Berhasil", "Hapus Data Barang Berhasil",
          backgroundColor: Colors.greenAccent[100]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Setting Data RS",
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FlatButton(
                          child: Text("Tambah Barang RS",
                              style: GoogleFonts.poppins()),
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          color: Colors.green,
                          onPressed: () {
                            Get.to(AddSettingDataRS());
                          },
                        ),
                      ),
                    ),
                  ),
                  (dataView.length == 0)
                      ? Center(
                          child: Text(
                            "Kosong",
                            style: GoogleFonts.poppins(),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (dataView.length == 0) ? 0 : dataView.length,
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
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.02,
                                                      child: Text(
                                                        ":",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.6,
                                                      child: Text(
                                                        dataView[index]
                                                            ['nama_barang'],
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: width * 0.3,
                                                      child: Text(
                                                        "Stok Barang",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.02,
                                                      child: Text(
                                                        ":",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.6,
                                                      child: Text(
                                                        dataView[index]
                                                            ['stok_barang'],
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: width * 0.3,
                                                      child: Text(
                                                        "Jumlah Barang",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.02,
                                                      child: Text(
                                                        ":",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.6,
                                                      child: Text(
                                                        dataView[index][
                                                                'jumlah_barang']
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .poppins(),
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
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.02,
                                                      child: Text(
                                                        ":",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.6,
                                                      child: Text(
                                                        dataView[index][
                                                                'kebutuhan_saat_ini']
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .poppins(),
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
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.02,
                                                      child: Text(
                                                        ":",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.6,
                                                      child: Text(
                                                        (dataView[index][
                                                                        'jam_kritis'] ==
                                                                    null ||
                                                                int.parse(dataView[
                                                                            index]
                                                                        [
                                                                        'jam_kritis']) <
                                                                    1)
                                                            ? '0 Jam'
                                                            : dataView[index][
                                                                        'jam_kritis']
                                                                    .toString() +
                                                                ' Jam',
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          width: width * 0.4,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: FlatButton(
                                                              child: Text(
                                                                  "Edit",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins()),
                                                              textColor:
                                                                  Colors.white,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          20),
                                                              color:
                                                                  Colors.blue,
                                                              onPressed: () {
                                                                Get.to(
                                                                    UpdateSettingDataRS(
                                                                  data: dataView[
                                                                      index],
                                                                ));
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          width: width * 0.4,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: FlatButton(
                                                              child: Text(
                                                                  "Hapus",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins()),
                                                              textColor:
                                                                  Colors.white,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          20),
                                                              color: primaryred,
                                                              onPressed: () {
                                                                Get.defaultDialog(
                                                                  title:
                                                                      "Apakah Anda Yakin ?",
                                                                  titleStyle:
                                                                      GoogleFonts
                                                                          .poppins(),
                                                                  middleTextStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  textConfirm:
                                                                      "Hapus",
                                                                  textCancel:
                                                                      "Batal",
                                                                  cancelTextColor:
                                                                      Colors
                                                                          .black,
                                                                  confirmTextColor:
                                                                      Colors
                                                                          .white,
                                                                  buttonColor:
                                                                      Colors
                                                                          .red,
                                                                  barrierDismissible:
                                                                      false,
                                                                  radius: 10,
                                                                  onConfirm:
                                                                      () {
                                                                    hapus(dataView[
                                                                            index]
                                                                        [
                                                                        'id_barang_detail']);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            )))
                                  ],
                                );
                              }),
                        )
                ],
              ),
      );
    });
  }
}
