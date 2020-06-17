// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:movie_assistant/ui/app_state.dart';
import 'package:movie_assistant/ui/screens/home/home.dart';
import 'package:movie_assistant/ui/screens/routes.dart';
import 'package:movie_assistant/ui/themes/app_theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create:(BuildContext context) => AppState(),
    child: MyApp(),
    )
);

class MyApp extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: appRoutes,
      theme: getAppTheme(context),
      title: 'Vietant',
    );
  }
}

