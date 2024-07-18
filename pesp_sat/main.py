from pesp_sat.models import PeriodicEventNetwork


with open("data/simple/test1.txt") as input_file:
    pen = PeriodicEventNetwork.parse(input_file)

    print(pen)