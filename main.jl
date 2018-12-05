include("dataset.jl")
include("nn.jl")
include("model.jl")

using JSON

config = JSON.parsefile(ARGS[1])

if config["training"]
    model = Model(config)
    #LightNLP.save("ner.jld2", ner)
else
end
println("Finish.")
