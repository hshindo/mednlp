using JSON

function readdata(filename::String)
    data = String[]
    lines = open(readlines, filename)
    for line in lines
        dict = JSON.parse(line)
        pid = dict["pid"]
        gender = dict["gender"]
        opinion = dict["opinion"]
        opinion = replace(opinion, "\\n"=>"")
        diagnosis = dict["diagnosis"]
        diagnosis = replace(diagnosis, "\\n"=>"")
        label = dict["label"]
        label == "0" || label == "1" || label == "2" || continue
        push!(data, "$gender\t$opinion$diagnosis\t$label")
    end
    open("opinion_diagnosis.txt","w") do io
        for x in data
            println(io, x)
        end
    end
end

function embed2hdf5(filename::String)
    
end
