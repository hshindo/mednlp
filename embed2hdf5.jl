using HDF5

function embed2hdf5(filename::String)
    words = String[]
    vecs = Float32[]
    lines = open(readlines, filename)
    for i = 2:length(lines)
        line = lines[i]
        items = split(line, " ")
        word = items[1]
        vec = [parse(Float32,items[k]) for k = 2:length(items)]
        @assert length(vec) == 100
        push!(words, word)
        append!(vecs, vec)
    end
    h5write("a.h5", "words", words)
    h5write("a.h5", "vectors", vecs)
end
embed2hdf5("jawiki_20180420_100d.txt")
