import 'package:flutter/material.dart';

TableRow tableInfo(String text, String value) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    const Text(':'),
    Text(
      value,
    ),
  ]);
}
