"""
    @DBG expression_to_run_only_when_debugging
"""
macro DBG(ex)
    quote
        _debugging() && $(esc(ex))
        nothing
    end
end

_debugging() = false
enable_debug() = (@eval _debugging() = true; nothing)
disable_debug() = (@eval _debugging() = false; nothing)

struct Reduced{T}
    value::T
end

# ad-hoc terminatable foldl:
@inline _afoldl(op, x::Reduced, _...) = x.value
@inline _afoldl(op, acc, x, xs...) = _afoldl(op, op(acc, x), xs...)
@inline _afoldl(op, acc) = acc

static_if_leq(x::Integer, ::Any) = x
static_if_leq(x::StaticInteger, y::StaticInteger) = x <= y ? x : Int(x)
