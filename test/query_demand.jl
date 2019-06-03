using Caiso

d1 = Date(2018, 05, 01)
d2 = Date(2019, 01, 01)
demand = caiso_query_demand(d1, d2)[1]
