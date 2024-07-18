from pesp_sat.models import PeriodicEventNetwork
from pesp_sat.encoding import direct_encode, unpair

import pycosat
import time

with open("data/simple/test1.txt") as input_file:
    pen = PeriodicEventNetwork.parse(input_file)
    print(pen)
    cnf = direct_encode(pen=pen)

    for model in pycosat.itersolve(cnf):
        if isinstance(model, str):
            print(model)
        elif isinstance(model, list):
            sorted_model = sorted(model)
            potentials = [unpair(x) for x in sorted_model if x > 0]
            cleaned_data = {
                index: value for (index, value) in potentials if index <= pen.n
            }

            print(cleaned_data)

            other = {
                1: 50,
                2: 40,
                3: 30
            }
            print(all(con.is_satisfied(other) for con in pen.constraints))

        break
