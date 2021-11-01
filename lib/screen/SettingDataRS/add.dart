import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Penerimaan/index.dart';
import 'package:joss/screen/SettingDataRS/index.dart';
import 'package:joss/screen/Widgets/navigationbar.screen.dart';
import 'package:joss/utils/TextFieldController.dart';
import 'package:joss/utils/warna.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddSettingDataRS extends StatefulWidget {
  final data;
  AddSettingDataRS({Key key, this.data}) : super(key: key);

  @override
  _AddSettingDataRSState createState() => _AddSettingDataRSState();
}

class _AddSettingDataRSState extends State<AddSettingDataRS> {
  TextEditingController _stok = TextEditingController();
  TextEditingController _volKritis = TextEditingController();
  TextEditingController _volCukup = TextEditingController();
  TextEditingController _jumlahBarang = TextEditingController();
  var surdef;
  var kritis_jam;
  var stok_barang;
  var jumlah_barang;
  var volume_cukup;
  var volume_kritis;
  var simpanStatus = 'enalbled';
  List<String> countries = new List();
  var valBarang = null;
  var isLoading = true;
  @override
  void initState() {
    // print(widget.data);
    getBarang();
    super.initState();
  }

  jam_kritis() {
    // print("ddsdsddsdsdsddddddddd");

    var s = _stok.text.replaceAll(',', '');
    var jb = _jumlahBarang.text.replaceAll(',', '');
    var vc = _volCukup.text.replaceAll(',', '');
    var vk = _volKritis.text.replaceAll(',', '');
    setState(() {
      stok_barang = double.parse(s);
      jumlah_barang = double.parse(jb);
      volume_cukup = double.parse(vc);
      volume_kritis = double.parse(vk);
    });
  }

  simpan() async {
    jam_kritis();
    String myurl =
        'https://apijoss.linas-media.com/public/api/add_setting_data_rs';
    final prefs = await SharedPreferences.getInstance();
    var id_cust = prefs.get('id_customer');

    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1'
      // 'authorization': 'pass your key(optional)'
    }, body: {
      'id_customer': id_cust.toString(),
      'nama_barang': valBarang,
      'stok_barang': stok_barang.toString(),
      'jumlah_barang': jumlah_barang.toString(),
      'volume_cukup': volume_cukup.toString(),
      'volume_kritis': volume_kritis.toString(),
    }).then((response) {
      // print(response.body);
      final data = jsonDecode(response.body);
      Get.offAll(NavigationBarPage());
      Get.to(SettingDataRS());
      Get.snackbar("Update Berhasil", "Update Data Barang Berhasil",
          backgroundColor: Colors.greenAccent[100]);
    });
  }

  getBarang() async {
    final prefs = await SharedPreferences.getInstance();
    var a = prefs.get('token').toString();
    String myurl = "https://apijoss.linas-media.com/public/api/barang";
    var id_cust = prefs.get('id_customer');
    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1',
      'Authorization': 'Bearer ' + a
    }, body: {
      'id_customer': id_cust.toString()
    }).then((response) {
      // // print(idk);
      final data = jsonDecode(response.body);
      // print(data);
      if (data['status'] == 'Token is Expired') {
        // // progressDialog.hide();
        // alertTokenValidation(context);
      } else {
        var nm = data['data'];

        for (int i = 0; i < nm.length; i++) {
          countries.add(nm[i]['nama_barang']);
        }

        setState(() {
          isLoading = false;
        });
        // print(countries);
        // // print(localData);
        // return countries;
      }
    });
  }

  getSearchableDropdown(List<String> listData) {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < countries.length; i++) {
      items.add(new DropdownMenuItem(
        child: new Text(
          countries[i],
        ),
        value: countries[i],
      ));
    }

    return new SearchableDropdown.single(
      items: items,

      isExpanded: true,
      // value: selectedValueMap,
      isCaseSensitiveSearch: false,
      // style: GoogleFonts.poppins(),
      hint: new Text('Pilih Barang', overflow: TextOverflow.ellipsis),
      // searchHint: new Text(
      //   'Pilih Kelas',
      //    overflow: TextOverflow.ellipsis),

      onChanged: (value) {
        setState(() {
          valBarang = value;
        });
        if (valBarang == null) {
          // print("KOSONG");
        } else {
          // print(valBarang);
        }
      },
    );
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
                    child: (isLoading == true)
                        ? Text("Loading...", style: GoogleFonts.poppins())
                        : Container(
                            padding: EdgeInsets.only(bottom: 10, top: 5),
                            // margin: EdgeInsets.only(
                            //     left: 20, right: 20, top: 20),
                            // alignment:
                            //     Alignment.centerLeft, // 5 top and bottom

                            child: getSearchableDropdown(countries),
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
                      "Jumlah Barang",
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
                        controller: _jumlahBarang,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Jumlah Barang',
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
                      "Stok Barang",
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
                          hintText: 'Stok Barang',
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
                      "Volume Kritis",
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
                        controller: _volKritis,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Volume Kritis',
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
                      "Volume Cukup",
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
                        controller: _volCukup,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Volume Cukup',
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
