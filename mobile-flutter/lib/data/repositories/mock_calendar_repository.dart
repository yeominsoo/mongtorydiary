import 'package:mongtory_diary/data/datasources/mock/mock_calendar_datasource.dart';
import 'package:mongtory_diary/data/mappers/calendar_mapper.dart';
import 'package:mongtory_diary/domain/models/calendar_month.dart';
import 'package:mongtory_diary/domain/repositories/calendar_repository.dart';

class MockCalendarRepository implements CalendarRepository {
  const MockCalendarRepository(this._dataSource);

  final MockCalendarDataSource _dataSource;

  @override
  Future<CalendarMonth> getCalendarMonth({
    required int year,
    required int month,
  }) async {
    final dto = await _dataSource.getCalendarMonth(year: year, month: month);
    return CalendarMapper.toDomain(dto);
  }
}
