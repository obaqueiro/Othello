from othello.bit_board import BitBoard
import pytest


class TestBitBoardValidation:
    def test_invalid_value_lower(self):
        with pytest.raises(ValueError):
            BitBoard(-1)

    def test_invalid_value_higher(self):
        with pytest.raises(ValueError):
            BitBoard(64)

    def test_invalid_cell_lower(self):
        with pytest.raises(ValueError):
            BitBoard(cells=[1, 6, 8, -1])

    def test_invalid_cell_higher(self):
        with pytest.raises(ValueError):
            BitBoard(cells=[2, 64, 1])

    def test_happy_path_value(self):
        b = BitBoard(3)
        assert (b.value == 0b11)

    def test_happy_path_cells(self):
        b = BitBoard(cells=[1, 4, 6])
        assert (b.value == 0b1010010)
