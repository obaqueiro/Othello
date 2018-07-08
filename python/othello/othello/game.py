from pprint import pprint
from typing import Iterator
from utils import grouper, which_piece, bit_board


class Game():
    def __init__(self):
        self.boards = {"black": 2**27 + 2**36, "white": 0x810000000}
        self.masks = {
            "right": 0X7F7F7F7F7F7F7F7F,
            "left": 0xFEFEFEFEFEFEFEFE,
            "up": 0xFFFFFFFFFFFFFF00,
            "down": 0x00FFFFFFFFFFFFFF,
            "lower right": 0x007F7F7F7F7F7F7F,
            "upper right": 0X7F7F7F7F7F7F7F00,
            "lower left": 0x00FEFEFEFEFEFEFE,
            "upper left": 0xFEFEFEFEFEFEFE00
        }

    @property
    def board(self) -> Iterator[int]:
        board = zip(
            bit_board(self.boards["black"]), bit_board(self.boards["white"]))

        return map(which_piece, board)


# & 0x7e7e7e7e7e7e7e7e

g = Game()
pprint(list(grouper(bit_board(0xFEFEFEFEFEFEFE00), 8)))
