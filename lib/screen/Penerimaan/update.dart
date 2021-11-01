import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/screen/Penerimaan/index.dart';
import 'package:joss/screen/UpdateStokRS/index.dart';
import 'package:joss/screen/Widgets/navigationbar.screen.dart';
import 'package:joss/utils/TextFieldController.dart';
import 'package:joss/utils/warna.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PEnerimaanStokDataRS extends StatefulWidget {
  final data;
  PEnerimaanStokDataRS({Key key, this.data}) : super(key: key);

  @override
  _PEnerimaanStokDataRSState createState() => _PEnerimaanStokDataRSState();
}

class _PEnerimaanStokDataRSState extends State<PEnerimaanStokDataRS> {
  TextEditingController _stok = TextEditingController();
  TextEditingController _kebutuhan = TextEditingController();
  TextEditingController _keterangan = TextEditingController();
  var surdef;
  var kritis_jam;
  var stok_barang;
  var kebutuhan_harian;
  var simpanStatus = 'disabled';
  List<String> countries = new List();
  var valSupplier = null;
  var isLoading = true;
  @override
  void initState() {
    // print(widget.data);
    getSupplier();
    super.initState();
  }

  jam_kritis() async {
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

    var k = (widget.data['kebutuhan_saat_ini'] == null)
        ? 1
        : widget.data['kebutuhan_saat_ini'];
    var s = _stok.text.replaceAll(',', '');
    // print(s);
    // print(k);
    var defesit = double.parse(s) - double.parse(k);
    var var_kritis = double.parse(k) / 24;
    var jam_kritis = double.parse(s) / var_kritis;

    print(jam_kritis);
    print('jam_kritis');
    setState(() {
      surdef = defesit;
      stok_barang = double.parse(s);
      kebutuhan_harian = k;
      simpanStatus = 'enabled';
      kritis_jam = jam_kritis.ceil();
    });
  }

  simpan() async {
    String myurl =
        'https://apijoss.linas-media.com/public/api/penerimaan_store';
    final prefs = await SharedPreferences.getInstance();
    var id_cust = prefs.get('id_customer');

    await http.post(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1'
      // 'authorization': 'pass your key(optional)'
    }, body: {
      'id_customer': id_cust.toString(),
      'id_barang_detail': widget.data['id_barang_detail'].toString(),
      'stok_barang': stok_barang.toString(),
      'kebutuhan_harian': kebutuhan_harian.toString(),
      'jam_kritis': kritis_jam.toString(),
      'keterangan': _keterangan.text.toString(),
      'id_supplier': valSupplier.toString(),
    }).then((response) {
      // print(response.body);
      final data = jsonDecode(response.body);
      Get.offAll(NavigationBarPage());
      Get.to(PenerimaanDataRS());
      Get.snackbar("Update Berhasil", "Update Stok Barang Berhasil",
          backgroundColor: Colors.greenAccent[100]);
    });
  }

  getSupplier() async {
    final prefs = await SharedPreferences.getInstance();
    var a = prefs.get('token').toString();
    String myurl = "https://apijoss.linas-media.com/public/api/supplier";

    await http.get(myurl, headers: {
      'Accept': 'application/json',
      'X-Authorization':
          'QbxU3Rbo7qhbPRz6jpRxvSBo2HmCVAPDROjxfCoajXTJDrxrndZnlhoGAVOMFrO1',
      'Authorization': 'Bearer ' + a
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
          countries.add(nm[i]['nama_supplier']);
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
      hint: new Text('Pilih Supplier', overflow: TextOverflow.ellipsis),
      // searchHint: new Text(
      //   'Pilih Kelas',
      //    overflow: TextOverflow.ellipsis),

      onChanged: (value) {
        setState(() {
          valSupplier = value;
        });
        if (valSupplier == null) {
          // print("KOSONG");
        } else {
          // print(valSupplier);
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
              "Penerimaan Data Barang RS",
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
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: (widget.data['kebutuhan_saat_ini'] == null)
                              ? 'belum di isi'
                              : widget.data['kebutuhan_saat_ini'].toString(),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          //fazer o formater para dinheiro
                          CurrencyInputFormatter()
                        ],
                        onChanged: (value) {},
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
                      "Supplier",
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
                      "Jumlah Barang Diterima",
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
                          hintText: 'Jumlah Barang Diterima',
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
                          // print(value);
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.3,
                    child: Text(
                      "Keterangan",
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
                        maxLines: 10,
                        controller: _keterangan,
                        decoration: InputDecoration(
                          hintText: 'Keterangan',
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
