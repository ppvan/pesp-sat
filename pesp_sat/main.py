from pesp_sat.models import PeriodicEventNetwork
from pesp_sat.encoding import direct_encode, DirectEncode

import pycosat



def simple():
    with open("data/simple/test1.txt") as input_file:
        pen = PeriodicEventNetwork.parse(input_file)
        # pool, cnf = direct_encode(pen=pen)

        encoding = DirectEncode(pen=pen)
        cnf = encoding.encode()

        for model in pycosat.itersolve(cnf):
            if isinstance(model, str):
                print(model)
            elif isinstance(model, list):
                # potentials = filter(None, (pool.obj(x) for x in model if x > 0))
                # result = {name:value for (name, value) in potentials}

                # print(result)

                result = encoding.decode(model=model)
                if pen.is_feasible(result):
                    print(result)
                else:
                    print("Verification failed.")

                # if all(con.is_satisfied(cleaned_data) for con in pen.constraints):
                #     print(cleaned_data)


if __name__ == "__main__":
    simple()

    # for model in pycosat.itersolve([[1, 3]]):
    #     print(model)

    pass