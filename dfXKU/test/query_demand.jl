using Pkg
Pkg.add(PackageSpec(url="https://github.com/antonhinneck/Caiso.jl.git"))
using Caiso, Dates, Test

d1 = Date(2018, 05, 01)
d2 = Date(2018, 05, 01)
demand = Caiso.caiso_query_demand(d1, d2, verbose = true)[1]

@testset logic begin

    test_1_d1 = Date(2018, 05, 02)
    test_1_d2 = Date(2018, 05, 01)
    @test_throws ArgumentError Caiso.caiso_query_demand(test_1_d1, test_1_d1)

end
