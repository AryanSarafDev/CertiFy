import 'package:flutter/material.dart';

import 'constants.dart';

class TextString extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final double hi;
  final double fh;
  final double hs;


  const TextString(
      {Key? key,
        required this.textEditingController,
        this.isPass = false,
        required this.hintText,
        required this.textInputType,
        this.hi = 10,
        this.fh = 20,
        this.hs =20,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(textAlign: TextAlign.center,
      controller: textEditingController,
      decoration: InputDecoration(border: InputBorder.none,
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: hi),

        focusColor: primary,
        hintStyle: TextStyle(fontSize: hs,color: primary),



      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style: TextStyle(fontSize: fh,color: primary),



    );
  }
}
class TextStringWhite extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final double hi;
  final double fh;
  final double hs;


  const TextStringWhite(
      {Key? key,
        required this.textEditingController,
        this.isPass = false,
        required this.hintText,
        required this.textInputType,
        this.hi = 10,
        this.fh = 20,
        this.hs =20,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(border: InputBorder.none,
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: third),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: hi),

        focusColor: third,
        hintStyle: TextStyle(fontSize: hs,color: third),



      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style: TextStyle(fontSize: fh,color: secondary),



    );
  }
}

