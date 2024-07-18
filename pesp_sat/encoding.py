from typing import Tuple
import math

def pair(x: int, y: int) -> int:
    if x < y:
        return y * y + x + 1
    else:
        return x * x + x + y + 1

def unpair(z: int) -> Tuple[int, int]:
    z -= 1
    tmp = math.floor(math.sqrt(z))
    if z < tmp * tmp + tmp:
        x = z - tmp * tmp
        y = tmp
    else:
        x = tmp
        y = z - tmp * tmp - tmp
    return x, y

