import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/database/app_database.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportSessionsUseCase {
  Future<String> exportToCsv(List<Session> sessions) async {
    List<List<dynamic>> rows = [
      ['ID', 'Start', 'End', 'Start%', 'End%', 'AvgW', 'PeakW', 'MaxTemp', 'ChargerType'],
    ];
    for (var s in sessions) {
      rows.add([
        s.id,
        s.startTs,
        s.endTs,
        s.startPct,
        s.endPct,
        s.avgW,
        s.peakW,
        s.maxTemp,
        s.chargerType,
      ]);
    }
    String csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sessions_export.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  Future<String> exportToPdf(List<Session> sessions) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text("ChargeEasy Sessions Report"),
        );
      },
    ),);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sessions_export.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
