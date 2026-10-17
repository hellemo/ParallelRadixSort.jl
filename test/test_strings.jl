module TestStrings

using ParallelRadixSort
using Test

const ALGS = [
    ParallelRadixSort.MSDRadixSort,
    ParallelRadixSort.StableMSDRadixSort,
    ParallelRadixSort.ParallelMSDRadixSort,
    ParallelRadixSort.ParallelStableMSDRadixSort,
]

# A string sorts before its extensions, also when they continue with '\0'.
@testset "embedded NUL: $alg" for alg in ALGS
    x = vcat(fill("a\0", 100), fill("a", 100), fill("a\0\0", 100), fill("", 100))
    @test sort(x; alg = alg) == sort(x)
    @test sort(x; alg = alg, rev = true) == sort(x; rev = true)
    y = [join(rand(['a', '\0'], rand(0:6))) for _ in 1:2^16]
    @test sort(y; alg = alg) == sort(y)
    @test sort(y; alg = alg, rev = true) == sort(y; rev = true)
end

end  # module
