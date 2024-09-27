import 'package:flutter_dotenv/flutter_dotenv.dart';

const bool kProdMode = false;
final env = dotenv.env;
final String localPort = env['localPort']!;
final String prodPort = env['prodPort']!;
final String socketPort = env['socketPort']!;

final String emulator = env['emulator']!;
final String local = env['local']!;
final String prod = env['prod']!;

final String baseUrl = kProdMode ? "$prod:$prodPort" : "$local:$localPort";
final String socketUrl =
    kProdMode ? "$prod:$socketPort" : "$emulator:$socketPort";
