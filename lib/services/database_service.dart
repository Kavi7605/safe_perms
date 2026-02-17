import 'package:hive_flutter/hive_flutter.dart';
import '../models/schedule_model.dart';

class DatabaseService {
  final _box = Hive.box('schedules');

  // CREATE: Add a new schedule
  Future<void> addSchedule(Schedule schedule) async {
    await _box.put(schedule.key, schedule.toMap());
  }

  // READ: Get all schedules
  List<Schedule> getSchedules() {
    return _box.values.map((e) => Schedule.fromMap(e)).toList();
  }

  // UPDATE: Modify an existing schedule (e.g., toggle active status)
  Future<void> updateSchedule(Schedule schedule) async {
    await _box.put(schedule.key, schedule.toMap());
  }

  // DELETE: Remove a schedule
  Future<void> deleteSchedule(String key) async {
    await _box.delete(key);
  }
}