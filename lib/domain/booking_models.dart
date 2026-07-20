enum ServiceMode { remote, houseCall, inOffice }

extension ServiceModeLabel on ServiceMode {
  String get label => switch (this) {
    ServiceMode.remote => 'Phone / remote',
    ServiceMode.houseCall => 'House call',
    ServiceMode.inOffice => 'In-office',
  };

  String get description => switch (this) {
    ServiceMode.remote => 'Support by phone or secure remote session.',
    ServiceMode.houseCall => 'On-site help in the supported service area.',
    ServiceMode.inOffice => 'Lower-cost drop-off or appointment at the office.',
  };
}

enum ServiceCategory { computers, networks, security, support }

extension ServiceCategoryLabel on ServiceCategory {
  String get label => switch (this) {
    ServiceCategory.computers => 'Computers',
    ServiceCategory.networks => 'Networks',
    ServiceCategory.security => 'Security',
    ServiceCategory.support => 'IT support',
  };
}

class BookingService {
  const BookingService({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.category,
    required this.durationOptions,
    required this.supportedModes,
    required this.upfrontCents,
    required this.dueAtAppointmentCents,
    required this.pricingNote,
  });

  final String id;
  final String name;
  final String shortDescription;
  final ServiceCategory category;
  final List<int> durationOptions;
  final List<ServiceMode> supportedModes;
  final int upfrontCents;
  final int dueAtAppointmentCents;
  final String pricingNote;

  String get upfrontPrice => formatMoney(upfrontCents);
  String get duePrice => formatMoney(dueAtAppointmentCents);
}

class TimeWindow {
  const TimeWindow(this.startMinute, this.endMinute);

  final int startMinute;
  final int endMinute;
}

class TimeSlot {
  const TimeSlot({required this.startMinute, required this.durationMinutes});

  final int startMinute;
  final int durationMinutes;

  int get endMinute => startMinute + durationMinutes;
  String get label => '${formatTime(startMinute)} – ${formatTime(endMinute)}';
}

class BookingRequest {
  const BookingRequest({
    required this.service,
    required this.durationMinutes,
    required this.mode,
    required this.serviceArea,
    required this.date,
    required this.startMinute,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.details,
  });

  final BookingService service;
  final int durationMinutes;
  final ServiceMode mode;
  final String serviceArea;
  final DateTime date;
  final int startMinute;
  final String customerName;
  final String email;
  final String phone;
  final String details;

  DateTime get startsAt => DateTime(
    date.year,
    date.month,
    date.day,
    startMinute ~/ 60,
    startMinute % 60,
  );

  DateTime get endsAt => startsAt.add(Duration(minutes: durationMinutes));
}

class BookingReceipt {
  const BookingReceipt({
    required this.reference,
    required this.request,
    required this.isPreview,
  });

  final String reference;
  final BookingRequest request;
  final bool isPreview;
}

String formatMoney(int cents) {
  final dollars = cents ~/ 100;
  final remainder = cents % 100;
  return '\$$dollars.${remainder.toString().padLeft(2, '0')}';
}

String formatTime(int totalMinutes) {
  final normalized = totalMinutes % (24 * 60);
  final hour24 = normalized ~/ 60;
  final minute = normalized % 60;
  final suffix = hour24 >= 12 ? 'PM' : 'AM';
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  return '$hour12:${minute.toString().padLeft(2, '0')} $suffix';
}

String formatDuration(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (remainder == 0) return hours == 1 ? '1 hour' : '$hours hours';
  return '$hours hr $remainder min';
}

String formatDate(DateTime date) {
  const weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
}
