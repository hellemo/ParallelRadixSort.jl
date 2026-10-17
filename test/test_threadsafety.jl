module TestThreadSafety

using ParallelRadixSort
using Test

# Many parallel sorts at once, from tasks that may migrate between threads
# (and with an interactive thread, thread ids may exceed `nthreads()`).
@testset "concurrent parallel sorts" begin
    alg = ParallelRadixSort.ParallelMSDRadixSort(basesize = 2^10)
    inputs = [rand(UInt64, 2^16) for _ in 1:32]
    results = Vector{Bool}(undef, length(inputs))
    @sync for (i, x) in enumerate(inputs)
        Threads.@spawn results[i] = sort(x; alg = alg) == sort(x)
    end
    @test all(results)
end

end  # module
