module TestReverse

using ParallelRadixSort
using Test

const ALGS = [
    ParallelRadixSort.MSDRadixSort,
    ParallelRadixSort.StableMSDRadixSort,
    ParallelRadixSort.ParallelMSDRadixSort,
    ParallelRadixSort.ParallelStableMSDRadixSort,
]
const STABLE = [ParallelRadixSort.StableMSDRadixSort, ParallelRadixSort.ParallelStableMSDRadixSort]

randstr(maxlen) = join(rand('a':'c', rand(0:maxlen)))

@testset "rev = true: $alg" for alg in ALGS
    for n in (50, 2^16)
        for x in (rand(UInt64, n), vcat(rand(UInt64, n), UInt64[0, typemax(UInt64)]),
                  rand(UInt8, n), rand(Int32, n), rand(Int8, n),
                  [rand() < 0.1 ? NaN : randn() for _ in 1:n], rand(Char, n),
                  [randstr(5) for _ in 1:n])
            @test isequal(sort(x; alg = alg, rev = true), sort(x; rev = true))
        end
        x = rand(Int16, n)
        @test sort(x; alg = alg, by = abs, rev = true) == sort(x; by = abs, rev = true) ||
              issorted(sort(x; alg = alg, by = abs, rev = true); by = abs, rev = true)
        @test isequal(sort(x; alg = alg, order = Base.Order.By(abs, Base.Reverse)),
                      sort(x; order = Base.Order.By(abs, Base.Reverse))) ||
              issorted(sort(x; alg = alg, order = Base.Order.By(abs, Base.Reverse));
                       order = Base.Order.By(abs, Base.Reverse))
    end
end

@testset "rev = true is stable: $alg" for alg in STABLE
    y = [(rand(1:20), i) for i in 1:2^16]
    @test sort(y; alg = alg, by = first, rev = true) == sort(y; by = first, rev = true)
    s = [(randstr(3), i) for i in 1:2^16]
    @test sort(s; alg = alg, by = first, rev = true) == sort(s; by = first, rev = true)
end

end  # module
