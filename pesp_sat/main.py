
import pycosat

cnf = [[1, -5, 4], [-1, 5, 3, 4], [-3, -4]]

model = pycosat.solve(cnf)

print(model)