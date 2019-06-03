using Test, Pkg
Pkg.add(PackageSpec(url="https://github.com/antonhinneck/Caiso.jl.git"))
using Caiso

d1 = Date(2018, 05, 01)
d2 = Date(2019, 05, 02)
demand = caiso_query_demand(d1, d2, true)[1]
