import 'package:home_widget/home_widget.dart';

class WidgetService {
  Future<void> updateWidgetData(Map<String, dynamic> data) async {
    for (var entry in data.entries) {
      await HomeWidget.saveWidgetData<String>(entry.key, entry.value.toString());
    }
    await HomeWidget.updateWidget(name: 'BatteryWidget2x1');
    await HomeWidget.updateWidget(name: 'BatteryWidget4x2');
  }
}
