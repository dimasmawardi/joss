import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/UpdateStokRS/index.dart';
import 'package:joss/screen/Widgets/navigationbar.screen.dart';
import 'package:joss/utils/TextFieldController.dart';
import 'package:joss/utils/warna.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateStokDataRS extends StatefulWidget {
  final data;
  UpdateStokDataRS({Key key, this.data}) : super(key: key);

  @override
  _UpdateStokDataRSState createState() => _UpdateStokDataRSState();
}

class _UpdateStokDataRSState extends State<UpdateStokDataRS> {
  TextEditingController _stok = TextEditingController();
  TextEditingController _kebutuhan = TextEditingController();
  var surdef;
  var kritis_jam;
  var stok_barang;
  var kebutuhan_harian;
  var simpanStatus = 'disabled';
  @override
  void initState() {
    // print(widget.data);
    super.initState();
  }

  jam_kritis() {
    // print("ddsdsddsdsdsddddddddd");
    // var update_stok = $(this).closest('tr').find('.stok-update').val();
    // var kebutuhan_harian =
    //     $(this).closest('tr').find('.kebutuhan-harian').val();
    // update_stok = update_stok.replace(",", "");
    // kebutuhan_harian = kebutuhan_harian.replace(",", "");
    // var defesit = parseFloat(update_stok) - parseFloat(kebutuhan_harian);
    // var var_kritis = parseFloat(kebutuhan_harian) / 24;
    // var jam_kritis = parseFloat(update_stok) / parseFloat(var_kritis);
    // console.log(update_stok);
    // if (jam_kritis == Number.POSITIVE_INFINITY ||
    //     jam_kritis == Number.NEGATIVE_INFINITY) {
    //   jam_kritis = 0;
    // }
    // if (isNaN(defesit)) {
    //   defesit = update_stok;
    // }
    // if (isNaN(jam_kritis)) {
    //   jam_kritis = 0;
    // }

    var k = _kebutuhan.text.replaceAll(',', '');
    var s = _stok.text.replaceAll(',', '');

    var defesit = double.parse(s) - double.parse(k);
    var var_kritis = double.parse(k) / 24;
    var jam_kritis = double.parse(s) / var_kritis;
    setState(() {
      surdef = defesit;
      stok_barang = double.parse(s);
      kebutuhan_harian = double.parse(k);
      simpanStatus = 'enabled';
      kritis_jam = jam_kritis.ceil();
    });
  }

  simpan() async {
    String myurl = 'https://apijoss.linas-media.com/public/api/stok_rs_update';
    final prefs = await SharedPreferences.getInstance();
    var id_cust = prefs.get('id_customer');

    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1'
      // 'authorization': 'pass your key(optional)'
    }, body: {
      'id_barang_detail': widget.data['id_barang_detail'].toString(),
      'stok_barang': stok_barang.toString(),
      'kebutuhan_harian': kebutuhan_harian.toString(),
      'jam_kritis': kritis_jam.toString(),
    }).then((response) {
      print(response.body);
      final data = jsonDecode(response.body);
      Get.offAll(NavigationBarPage());
      Get.to(UpdateDataRS());
      Get.snackbar("Update Berhasil", "Update Stok Barang Berhasil",
          backgroundColor: Colors.greenAccent[100]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "Update Data Barang RS",
              style: GoogleFonts.poppins(),
            ),
            centerTitle: true,
            backgroundColor: primaryColor,
          ),
          body: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    child: TextFieldController(
                      child: TextField(
                        style: GoogleFonts.poppins(),
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: widget.data['nama_barang'],
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    child: TextFieldController(
                      child: TextField(
                        style: GoogleFonts.poppins(),
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: widget.data['stok_barang'],
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.3,
                    child: Text(
                      "Update Stok Setelah Pemakaian",
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
                    child: TextFieldController(
                      child: TextField(
                        style: GoogleFonts.poppins(),
                        controller: _stok,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Update Stok Setelah Pemakaian',
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          //fazer o formater para dinheiro
                          CurrencyInputFormatter()
                        ],
                        onChanged: (value) {
                          if (double.parse(value) >
                                  double.parse(widget.data['stok_barang']) ||
                              double.parse(value) < 1) {
                            // print('as');
                            setState(() {
                              simpanStatus = 'disabled';
                            });
                            Get.snackbar("Stok Barang",
                                "Stok Barang Tidak Boleh 0 atau Melebihi Stok Barang Sebelumnya",
                                backgroundColor: Colors.red[600]);
                          } else {
                            jam_kritis();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.3,
                    child: Text(
                      "Kebutuhan Harian",
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
                    child: TextFieldController(
                      child: TextField(
                        style: GoogleFonts.poppins(),
                        controller: _kebutuhan,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Kebutuhan Harian',
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          //fazer o formater para dinheiro
                          CurrencyInputFormatter()
                        ],
                        onChanged: (value) {
                          jam_kritis();
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.3,
                    child: Text(
                      "Surplus / Defisit",
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
                    child: TextFieldController(
                      child: TextField(
                        style: GoogleFonts.poppins(),
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: (surdef == null)
                              ? 'Surplus / Defisit'
                              : surdef.toString(),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          //fazer o formater para dinheiro
                          CurrencyInputFormatter()
                        ],
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    child: TextFieldController(
                      child: TextField(
                        style: GoogleFonts.poppins(),
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: (kritis_jam == null)
                              ? 'Jam Kritis'
                              : kritis_jam.toString() + ' Jam',
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          //fazer o formater para dinheiro
                          CurrencyInputFormatter()
                        ],
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                        },
                      ),
                    ),
                  )
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: width * 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FlatButton(
                      child: Text("Simpan", style: GoogleFonts.poppins()),
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: (simpanStatus == 'disabled')
                          ? Colors.black45
                          : primaryred,
                      onPressed: () {
                        (simpanStatus == 'disabled')
                            ? Get.snackbar('Input Belum Selesai',
                                'Harap Selesaikan Input Terlebih Dahulu')
                            : simpan();
                      },
                    ),
                  ),
                ),
              ),
            ],
          )));
    });
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      // print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.decimalPattern('en');

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
