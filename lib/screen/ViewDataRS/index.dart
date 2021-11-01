import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/utils/warna.dart';
import 'package:http/http.dart' as http;
import 'package:relative_scale/relative_scale.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ViewDataRs extends StatefulWidget {
  ViewDataRs({Key key}) : super(key: key);

  @override
  _ViewDataRsState createState() => _ViewDataRsState();
}

class _ViewDataRsState extends State<ViewDataRs> {
  var dataView = [];
  var dataPem = [];
  var isLoading = true;
  var _animatedHeight = 0.0;
  var _animatedHeight2 = 0.0;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    String myurl = 'https://apijoss.linas-media.com/public/api/view_data_rs';
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
      var view = data['data_stok'];
      if (data['status'] == true) {
        setState(() {
          dataView = view;
          dataPem = data['data'];
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "View Data RS",
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
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        // print(_animatedHeight);
                        _animatedHeight != 0.0
                            ? _animatedHeight = 0.0
                            : _animatedHeight = height;
                      }),
                      child: Card(
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('STOK CARD', style: GoogleFonts.poppins()),
                              (_animatedHeight != 0.0)
                                  ? Icon(Icons.remove)
                                  : Icon(Icons.add)
                            ],
                          ),
                          height: height * 0.05,
                          width: width,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        height: _animatedHeight,
                        width: width,
                        child: (dataView.length == 0)
                            ? Center(
                                child: Text(
                                  "Kosong",
                                  style: GoogleFonts.poppins(),
                                ),
                              )
                            : Column(
                                children: [
                                  ...dataView.map((arr) {
                                    var index = dataView.indexOf(arr);
                                    var a = double.parse(
                                            dataView[index]['pemasukan']) -
                                        dataView[index]['pemakaian'];
                                    return Column(
                                      children: [
                                        Card(
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
                                                            "Stok Pemasukan",
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
                                                                ['pemasukan'],
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
                                                            "Stok Pemakaian",
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
                                                                    'pemakaian']
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
                                                            "Balance Stok",
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
                                                            a.toString(),
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )))
                                      ],
                                    );
                                  }),
                                ],
                              )),
                    GestureDetector(
                      onTap: () => setState(() {
                        // print(_animatedHeight);
                        _animatedHeight2 != 0.0
                            ? _animatedHeight2 = 0.0
                            : _animatedHeight2 = height;
                      }),
                      child: Card(
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('DETAIL PEMGELUARAN / PEMASUKAN STOK',
                                  style: GoogleFonts.poppins()),
                              (_animatedHeight2 != 0.0)
                                  ? Icon(Icons.remove)
                                  : Icon(Icons.add)
                            ],
                          ),
                          height: height * 0.05,
                          width: width,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      height: _animatedHeight2,
                      width: width,
                      child: (dataPem.length == 0)
                          ? Center(
                              child: Text(
                                "Kosong",
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  (dataPem.length == 0) ? 0 : dataPem.length,
                              itemBuilder: (context, index) {
                                var a =
                                    double.parse(dataPem[index]['stok_update'])
                                        .abs();
                                var status = (double.parse(
                                            dataPem[index]['stok_update']) <
                                        0)
                                    ? 'Pemakaian'
                                    : 'Pemasukan';
                                return Column(
                                  children: [
                                    Card(
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
                                                        dataPem[index]
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
                                                        "Jam Input",
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
                                                        dataPem[index]
                                                            ['jam_input'],
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
                                                        "Tanggal Input",
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
                                                        dataPem[index][
                                                                'tanggal_input']
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
                                                        "Stok Pemasukan / Pengeluaran",
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
                                                        a.toString(),
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
                                                        "Status",
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
                                                        status,
                                                        style: GoogleFonts.poppins(
                                                            backgroundColor:
                                                                (status ==
                                                                        'Pemakaian')
                                                                    ? Colors
                                                                        .pink
                                                                    : Colors
                                                                        .blue,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )))
                                  ],
                                );
                              }),
                    ),
                  ],
                )));
    });
  }
}
