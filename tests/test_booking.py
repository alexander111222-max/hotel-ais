from datetime import date

from src.hotel.booking import Booking, is_room_free


def test_overlapping_booking_is_rejected():
    busy = [Booking(101, date(2026, 11, 1), date(2026, 11, 5))]
    assert not is_room_free(101, date(2026, 11, 4), date(2026, 11, 6), busy)


def test_checkout_day_can_be_booked():
    busy = [Booking(101, date(2026, 11, 1), date(2026, 11, 5))]
    assert is_room_free(101, date(2026, 11, 5), date(2026, 11, 7), busy)
