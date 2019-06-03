using Pkg
Pkg.add(PackageSpec(url="https://github.com/antonhinneck/Caiso.jl.git"))
using Caiso, Dates, Test

d1 = Date(2018, 05, 01)
d2 = Date(2018, 05, 02)
demand = Caiso.caiso_query_demand(d1, d2, verbose = true)[1]
