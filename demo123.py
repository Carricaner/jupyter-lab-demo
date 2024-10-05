from abc import ABC
from datetime import datetime
from typing import List


class Condition(ABC):
    def validated(self) -> bool: ...


class MondayCondition(Condition):

    def __init__(self, time: datetime) -> None:
        self.time = time

    def validated(self) -> bool:
        return self.time.weekday() == 0


class PriceTooHighCondition(Condition):

    def __init__(self, stock_price: int, history_prices: List[int]) -> None:
        self.stock_price = stock_price
        self.history_prices = history_prices
        self._diff = 10

    def validated(self) -> bool:
        return self.stock_price > sum(self.history_prices) / len(self.history_prices) + self._diff


if __name__ == "__main__":
    print("demo")
