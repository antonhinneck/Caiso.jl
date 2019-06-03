using Pkg, Caiso, Dates, Test
Pkg.add(PackageSpec(url="https://github.com/antonhinneck/Caiso.jl.git"))

d1 = Date(2018, 05, 01)
d2 = Date(2018, 05, 01)
demand = Caiso.caiso_query_demand(d1, d2)

@testset "assertions" begin

    test_1_d1 = Date(2018, 05, 02)
    test_1_d2 = Date(2018, 05, 01)
    @test_throws AssertionError Caiso.caiso_query_demand(test_1_d1, test_1_d2)

    test_1_d2 = Date(2018, 04, 09)
    @test_throws AssertionError Caiso.caiso_query_demand(test_1_d1, test_1_d2)

end
