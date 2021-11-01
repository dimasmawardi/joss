import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joss/utils/warna.dart';
import 'package:relative_scale/relative_scale.dart';

class AddSettingDataRS extends StatefulWidget {
  AddSettingDataRS({Key key}) : super(key: key);

  @override
  _AddSettingDataRSState createState() => _AddSettingDataRSState();
}

class _AddSettingDataRSState extends State<AddSettingDataRS> {
  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "Add Setting Data RS",
              style: GoogleFonts.poppins(),
            ),
            centerTitle: true,
            backgroundColor: primaryColor,
          ),
          body: Column(
            children: [],
          ));
    });
  }
}
