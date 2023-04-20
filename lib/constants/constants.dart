import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

const bool _kProdMode = false;
final String localPort =
    _kProdMode ? Platform.environment["localPort"]! : dotenv.env['localPort']!;
final String prodPort =
    _kProdMode ? Platform.environment["prodPort"]! : dotenv.env['prodPort']!;
final String socketPort = _kProdMode
    ? Platform.environment["socketPort"]!
    : dotenv.env['socketPort']!;

final String emulator =
    _kProdMode ? Platform.environment["emulator"]! : dotenv.env['emulator']!;
final String local =
    _kProdMode ? Platform.environment["local"]! : dotenv.env['local']!;
final String prod =
    _kProdMode ? Platform.environment["prod"]! : dotenv.env['prod']!;

final String baseUrl = _kProdMode ? "$prod:$prodPort" : "$local:$localPort";
final String socketUrl =
    _kProdMode ? "$prod:$socketPort" : "$local:$socketPort";
