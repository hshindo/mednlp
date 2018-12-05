struct Dataset
    data::Vector
    training::Bool
end

Base.length(dataset::Dataset) = length(dataset.data)

function Base.getindex(dataset::Dataset, indexes::Vector{Int})
    data = dataset.data[indexes]
    data = sort(data, by=x->length(x[1]), rev=true)
    ws = map(x -> x[1], data)
    dims_w = length.(ws)
    w = cat(ws..., dims=1)
    w = reshape(w, 1, length(w))
    t = cat(map(x -> x[2], data)..., dims=1)
    (w=Var(w), dims_w=dims_w, t=Var(t), training=dataset.training)
end

function readdata(path::String, worddict)
    data = []
    unkword = worddict["UNKNOWN"]
    lines = open(readlines, path)
    for line in lines
        isempty(line) && continue
        items = split(line, "\t")
        genderid = worddict[items[1]]
        words = split(items[2], "_")
        wordids = map(w -> get(worddict,w,unkword), words)
        entities = split(items[3], "_")
        entityids = map(e -> get(worddict,"ENTITY/$e",unkword), entities)
        w = Int[genderid, wordids..., entityids...]
        label = parse(Int,items[4]) + 1
        @assert 1 <= label <= 3
        push!(data, (w,label))
    end
    data = Vector{typeof(data[1])}(data)
    shuffle!(data)
    m = length(data) ÷ 10
    traindata = Dataset(data[1:9m], true)
    testdata = Dataet(data[9m+1:end], false)
    traindata, testdata
end
