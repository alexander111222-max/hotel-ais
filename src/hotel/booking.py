"""Условная модель бронирования номера (иллюстрация бизнес-правила БП-1)."""
from dataclasses import dataclass
from datetime import date

ACTIVE = {"Создана", "Подтверждена", "Заселено"}


@dataclass
class Booking:
    room: int
    check_in: date
    check_out: date
    status: str = "Создана"

    def overlaps(self, other: "Booking") -> bool:
        """Брони одного номера пересекаются, если их интервалы дат накладываются."""
        return (self.room == other.room
                and self.status in ACTIVE and other.status in ACTIVE
                and self.check_in < other.check_out and other.check_in < self.check_out)


def is_room_free(room: int, check_in: date, check_out: date, bookings: list[Booking]) -> bool:
    """Номер свободен, если новая бронь не пересекается ни с одной активной (БП-1)."""
    new = Booking(room, check_in, check_out)
    return not any(new.overlaps(b) for b in bookings)
