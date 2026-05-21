import 'package:flutter_riverpod/flutter_riverpod.dart';

class WritingReminderSettings {
  const WritingReminderSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  final bool enabled;
  final int hour;
  final int minute;

  String get timeLabel {
    final hourText = hour.toString().padLeft(2, '0');
    final minuteText = minute.toString().padLeft(2, '0');
    return '$hourText:$minuteText';
  }

  WritingReminderSettings copyWith({bool? enabled, int? hour, int? minute}) {
    return WritingReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

class WritingReminderController extends StateNotifier<WritingReminderSettings> {
  WritingReminderController()
    : super(const WritingReminderSettings(enabled: true, hour: 21, minute: 30));

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
  }

  void setTime({required int hour, required int minute}) {
    state = state.copyWith(hour: hour, minute: minute);
  }
}
