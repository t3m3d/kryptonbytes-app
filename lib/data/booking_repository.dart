import '../domain/booking_models.dart';

abstract interface class BookingRepository {
  Future<BookingReceipt> createBooking(BookingRequest request);
}

class PreviewBookingRepository implements BookingRepository {
  final List<BookingRequest> _bookings = <BookingRequest>[];

  List<BookingRequest> get bookings => List<BookingRequest>.unmodifiable(_bookings);

  @override
  Future<BookingReceipt> createBooking(BookingRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final overlaps = _bookings.any(
      (booking) =>
          request.startsAt.isBefore(booking.endsAt) &&
          request.endsAt.isAfter(booking.startsAt),
    );
    if (overlaps) {
      throw const BookingException(
        'That time was just reserved. Please choose another opening.',
      );
    }
    _bookings.add(request);
    final date = request.startsAt;
    final sequence = _bookings.length.toString().padLeft(3, '0');
    return BookingReceipt(
      reference:
          'KB-${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}-$sequence',
      request: request,
      isPreview: true,
    );
  }
}

class BookingException implements Exception {
  const BookingException(this.message);

  final String message;

  @override
  String toString() => message;
}
