import 'package:finalyearproject/app/app.dart';
import 'package:finalyearproject/app/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}