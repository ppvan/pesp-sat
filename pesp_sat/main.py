from pesp_sat.models import PeriodicEventNetwork
from pesp_sat.encoding import direct_encode, unpair

import pycosat
import pprint
import time


def simple():
    with open("data/simple/test1.txt") as input_file:
        pen = PeriodicEventNetwork.parse(input_file)
        print(pen)
        cnf = direct_encode(pen=pen)

        # return 
        for model in pycosat.itersolve(cnf):
            if isinstance(model, str):
                print(model)
            elif isinstance(model, list):
                sorted_model = sorted(model)
                potentials = [unpair(x) for x in sorted_model if x > 0]
                # print(potentials)
                cleaned_data = {
                    index: value for (index, value) in potentials if 0 < index <= pen.n
                }

                if all(con.is_satisfied(cleaned_data) for con in pen.constraints):
                    print(cleaned_data)


if __name__ == "__main__":
    simple()

    # for model in pycosat.itersolve([[1, 3]]):
    #     print(model)

    pass