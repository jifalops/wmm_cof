import 'dart:convert' show utf8;
import 'package:resource/resource.dart' show Resource;
// import 'package:wmm_cof/wmm_cof.dart';

main() async {
  var resource = Resource("package:wmm_cof/WMM.COF");
  var string = await resource.readAsString(encoding: utf8);
  print(string);
}
