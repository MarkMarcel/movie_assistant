// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:movie_assistant/ui/screens/home.dart';
import 'package:movie_assistant/ui/themes/app_theme.dart';

void main() => runApp(MyApp());

//Todo:lay out tabs
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: getAppTheme(context),
      home: Home()
    );
  }
}
