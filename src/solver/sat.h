

#include <kissat.h>
#include <stdbool.h>
#include "../types/vec.h"


typedef struct {
    kissat* s;
    int max_var;
    int clauses;

    vec_t* _cnf;
} sat_t;


sat_t* sat_init();
void sat_add(sat_t* self, int lit);
bool sat_solve(sat_t* self);
vec_t* sat_values(sat_t* self);
int sat_value(sat_t *self, int lit);

void sat_free(sat_t* self);