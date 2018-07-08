from typing import Tuple, List


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
