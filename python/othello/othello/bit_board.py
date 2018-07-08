from typing import List


class BitBoard:
    def __init__(self, value: int = 0, cells: List[int] = None) -> None:
        if not 0 <= value <= 63:
            raise ValueError("Values must be between (0,63)")
        if cells is not None:
            if all(0 <= v <= 63 for v in cells):
                cs = map(lambda x: 2**x, cells)
                self.value = sum(cs)
            else:
                raise ValueError("Values must be between (0,63)")
        else:
            self.value = value


b = BitBoard(1)
c = BitBoard(2)
