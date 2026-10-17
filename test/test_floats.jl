module TestFloats

using ParallelRadixSort
using Test

const ALGS = [
    ParallelRadixSort.MSDRadixSort,
    ParallelRadixSort.StableMSDRadixSort,
    ParallelRadixSort.ParallelMSDRadixSort,
    ParallelRadixSort.ParallelStableMSDRadixSort,
]

# `isless` puts every NaN, of either sign, after +Inf; -0.0 before +0.0.
@testset "NaN and signed zeros: $T, $alg" for T in (Float32, Float64), alg in ALGS
    special = T[NaN, -NaN, Inf, -Inf, 0.0, -0.0, floatmin(T), -floatmin(T)]
    for n in (50, 2^16)
        x = T[rand() < 0.2 ? rand(special) : randn(T) for _ in 1:n]
        @test isequal(sort(x; alg = alg), sort(x))
    end
end

end  # module
