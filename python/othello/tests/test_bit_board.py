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
