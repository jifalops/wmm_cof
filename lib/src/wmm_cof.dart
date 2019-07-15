import 'dart:io';
import 'package:meta/meta.dart' show required;
import 'package:intl/intl.dart' show DateFormat;

/// Represents the data in a WMM.COF file.
class WmmCof {
  WmmCof(
      {@required this.epoch,
      @required this.model,
      @required this.modelDate,
      @required List<WmmCofLineData> wmm})
      : wmm = List.unmodifiable(wmm),
        date = modelDateFormat.parse(modelDate);

  final double epoch;
  final String model;
  final String modelDate;
  final DateTime date;
  final List<WmmCofLineData> wmm;

  static final fieldSplitterRegex = RegExp(r'\s+');
  static final modelDateFormat = DateFormat('MM/dd/yyyy');

  factory WmmCof.fromFileSync(File wmmCof) =>
      WmmCof.fromLines(wmmCof.readAsLinesSync());

  static Future<WmmCof> fromFile(File wmmCof) async =>
      WmmCof.fromLines(await wmmCof.readAsLines());

  /// Parse a WMM.COF file as a string.
  factory WmmCof.fromString(String wmmCof) =>
      WmmCof.fromLines(wmmCof.split('\n'));

  /// Parse a WMM.COF file line by line.
  factory WmmCof.fromLines(List<String> lines) {
    double epoch;
    String model;
    String modelDate;
    List<WmmCofLineData> data;
    lines.forEach((line) {
      final linevals = line.trim().split(fieldSplitterRegex);
      if (linevals.length == 3) {
        epoch = double.parse(linevals[0]);
        model = linevals[1];
        modelDate = linevals[2];
      } else if (linevals.length == 6) {
        data.add(WmmCofLineData.fromParts(linevals));
      }
    });
    return WmmCof(epoch: epoch, model: model, modelDate: modelDate, wmm: data);
  }
}

/// Represents a data line in a WMM.COF file.
class WmmCofLineData {
  const WmmCofLineData(
      this.n, this.m, this.gnm, this.hnm, this.dgnm, this.dhnm);

  WmmCofLineData.fromParts(List<String> parts)
      : assert(parts.length == 6),
        n = int.parse(parts[0]),
        m = int.parse(parts[1]),
        gnm = double.parse(parts[2]),
        hnm = double.parse(parts[3]),
        dgnm = double.parse(parts[4]),
        dhnm = double.parse(parts[5]);

  final int n;
  final int m;
  final double gnm;
  final double hnm;
  final double dgnm;
  final double dhnm;
}
