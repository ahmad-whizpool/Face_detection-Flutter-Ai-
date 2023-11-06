import 'package:flutter/material.dart';

BTN(
    {required String btntext,
    required double sizetext,
    required double sizebtn,
    required void Function()? onPressed}) {
  return Container(
    width: sizebtn,
    child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          "$btntext",
          style: TextStyle(fontSize: sizetext),
        )),
  );
}

Text CustomTXT(
  String? text,
  double Size,
) {
  return Text(
    "${text}",
    style: TextStyle(fontSize: Size),
  );
}
