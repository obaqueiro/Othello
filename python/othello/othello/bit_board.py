from typing import Generator, Iterator, List
from itertools import zip_longest


class BitBoard:
    """Bit Board as data structure"""

    def __init__(self, value: int = 0, cells: List[int] = None) -> None:
        if cells is not None:
            if not all(0 <= v <= 63 for v in cells):
                raise ValueError("Values must be between (0,63)")

            cs = map(lambda x: 2**x, cells)
            self.value = sum(cs)

        else:
            if not 0 <= value <= 63:
                raise ValueError("Values must be between (0,63)")

            self.value = value

    def gen(self, x: int) -> Generator[int, None, None]:
        for _ in range(64):
            yield x & 0b1
            x = x >> 1

    def __iter__(self) -> Iterator:
        return self.gen(self.value)

    def __repr__(self):
        return "{}".format(bin(self.value))

    def __str__(self):
        groups = [self.gen(self.value)] * 8
        groups = zip_longest(*groups)
        groups = map(lambda x: " ".join(map(lambda y: str(y), x)), groups)
        return "\n".join(groups)


print(repr(BitBoard(20)))
print(BitBoard(20))
