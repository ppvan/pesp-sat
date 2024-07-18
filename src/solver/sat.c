#include "sat.h"
#include "kissat.h"
#include <bits/types/cookie_io_functions_t.h>
#include <stdlib.h>

enum { UNSATISFIABLE = 20, SATISFIABLE = 10 };

sat_t *sat_init() {
    sat_t *self = malloc(sizeof(sat_t));

    self->clauses = 0;
    self->max_var = 0;
    self->_cnf = vec_init();
    self->s = kissat_init();
    kissat_set_option(self->s, "quiet", 1);
    kissat_set_option(self->s, "sat", 1);

    return self;
}
void sat_add(sat_t *self, int lit) {
    if (abs(lit) > self->max_var) {
        self->max_var = abs(lit);
    }

    kissat_add(self->s, lit);
}

bool sat_solve(sat_t *self) {
    int result = kissat_solve(self->s);
    return result == SATISFIABLE;
}

vec_t *sat_values(sat_t *self) { return NULL; }

int sat_value(sat_t *self, int lit) { return kissat_value(self->s, lit); }

void sat_free(sat_t *self) {
    free(self);
    kissat_terminate(self->s);
}