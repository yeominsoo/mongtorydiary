import 'package:mongtory_diary/data/datasources/remote/remote_calendar_datasource.dart';
import 'package:mongtory_diary/data/mappers/calendar_mapper.dart';
import 'package:mongtory_diary/domain/models/calendar_month.dart';
import 'package:mongtory_diary/domain/repositories/calendar_repository.dart';

class ApiCalendarRepository implements CalendarRepository {
  const ApiCalendarRepository(this._dataSource);

  final RemoteCalendarDataSource _dataSource;

  @override
  Future<CalendarMonth> getCalendarMonth({
    required int year,
    required int month,
  }) async {
    final dto = await _dataSource.getCalendarMonth(year: year, month: month);
    return CalendarMapper.toDomain(dto);
  }
}
