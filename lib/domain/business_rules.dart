import 'booking_models.dart';

abstract final class BusinessRules {
  static const String timeZoneLabel = 'Eastern Time';
  static const int minimumNoticeDays = 3;
  static const int bookingWindowDays = 60;
  static const int slotIncrementMinutes = 15;
  static const String confirmationEmail = 't3m3d@kryptonbytes.com';
  static const List<String> serviceAreas = <String>[
    'Louisville, Kentucky',
    'New Albany, Indiana',
    'Jeffersonville, Indiana',
  ];

  static List<TimeWindow> windowsFor(DateTime date) {
    if (date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday) {
      return const <TimeWindow>[TimeWindow(0, 24 * 60)];
    }
    return const <TimeWindow>[
      TimeWindow(8 * 60, 10 * 60),
      TimeWindow(19 * 60 + 14, 23 * 60),
    ];
  }

  static DateTime earliestBookableMoment(DateTime now) =>
      now.add(const Duration(days: minimumNoticeDays));

  static DateTime latestBookableDate(DateTime now) {
    final date = DateTime(now.year, now.month, now.day);
    return date.add(const Duration(days: bookingWindowDays));
  }

  static List<TimeSlot> slotsFor({
    required DateTime date,
    required int durationMinutes,
    required DateTime now,
    List<({DateTime start, DateTime end})> blocked = const [],
  }) {
    final lastDate = latestBookableDate(now);
    final day = DateTime(date.year, date.month, date.day);
    if (day.isAfter(lastDate)) return const <TimeSlot>[];

    final earliest = earliestBookableMoment(now);
    final slots = <TimeSlot>[];
    for (final window in windowsFor(day)) {
      for (
        var minute = window.startMinute;
        minute + durationMinutes <= window.endMinute;
        minute += slotIncrementMinutes
      ) {
        final start = DateTime(
          day.year,
          day.month,
          day.day,
          minute ~/ 60,
          minute % 60,
        );
        final end = start.add(Duration(minutes: durationMinutes));
        if (start.isBefore(earliest)) continue;
        final overlaps = blocked.any(
          (period) => start.isBefore(period.end) && end.isAfter(period.start),
        );
        if (!overlaps) {
          slots.add(
            TimeSlot(
              startMinute: minute,
              durationMinutes: durationMinutes,
            ),
          );
        }
      }
    }
    return slots;
  }

  static String hoursSummaryFor(DateTime date) {
    if (date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday) {
      return 'Available 24 hours';
    }
    return '8:00–10:00 AM and 7:14–11:00 PM';
  }
}
