import '../services/battery_service.dart';
import '../../domain/models/battery_reading.dart';

class BatteryRepository {
  final BatteryService _batteryService;
  
  BatteryRepository(this._batteryService);
  
  Stream<BatteryReading> get batteryStream => _batteryService.batteryStream;
  
  Future<int> getDesignCapacity() => _batteryService.getDesignCapacity();
}
