from typing import Tuple, Generator, Iterable, List
from itertools import zip_longest


def grouper(iterable: Iterable, n: int):
    args = [iter(iterable)] * n
    return zip_longest(*args)


def bit_board(x: int) -> Generator[int, None, None]:
    for _ in range(64):
        yield x & 0b1
        x = x >> 1


def which_piece(v: Tuple[int, int]) -> int:
    x, y = v
    if x == 1:
        return 1
    elif y == 1:
        return 2
    else:
        return 0


def gen_bit_board(pos: List[int]):
    pass
