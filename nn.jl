using Merlin

mutable struct NN <: Functor
    wordembeds
    linear1
    linear2
end

function NN(wordembeds::Matrix{T}, ntags::Int) where T
    wordembeds = parameter(wordembeds)
    hsize = size(wordembeds, 1)
    linear1 = Linear(T, hsize, hsize)
    linear2 = Linear(T, hsize, ntags)
    NN(wordembeds, linear1, linear2)
end

function (nn::NN)(x::NamedTuple)
    h = lookup(nn.wordembeds, x.w)
    h = dropout(h, 0.5, x.training)
    h = nn.linear1(h)
    h = relu(h)
    h = average(h, 2)
    h = nn.linear2(h)
    if x.training
        softmax_crossentropy(x.t, h)
    else
        y = Array{Int}(Array(x.t.data))
        z = Array{Int}(Array(argmax(h.data,1)))
        vec(y), vec(z)
    end
end
