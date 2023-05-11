import 'package:flutter_dotenv/flutter_dotenv.dart';

const bool _kProdMode = true;
final String localPort = dotenv.env['localPort']!;
final String prodPort = dotenv.env['prodPort']!;
final String socketPort = dotenv.env['socketPort']!;

final String emulator = dotenv.env['emulator']!;
final String local = dotenv.env['local']!;
final String prod = dotenv.env['prod']!;

final String baseUrl = _kProdMode ? "$prod:$prodPort" : "$local:$localPort";
final String socketUrl =
    _kProdMode ? "$prod:$socketPort" : "$local:$socketPort";
