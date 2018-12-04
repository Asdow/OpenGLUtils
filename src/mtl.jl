mutable struct Material
    name::String
    Ns::Float32
    Ka::SVec{3,Float32}
    Kd::SVec{3,Float32}
    Ks::SVec{3,Float32}
    Ni::Float32
    d::Float32
    illum::UInt32
end



function loadMTL(path::String)
    defname = "default"
    defNs = 0.0f0
    defKa = SVec3(0.0f0)
    defKd = SVec3(0.0f0)
    defKs = SVec3(0.0f0)
    defNi = 0.0f0
    defd = 0.0f0
    defillum = 0


    materials = Material[]

    stream = open(path)
    for wholeLine in eachline(stream)
        chompped = strip(chomp(wholeLine))

        if !isempty(chompped) && !all(iscntrl, chompped)
            lines = split(chompped)
            command = popfirst!(lines)

            if command == "newmtl"
                push!(materials, Material(defname, defNs, defKa, defKd, defKs, defNi, defd, defillum))

                name = lines[end]
                materials[end].name = name

            elseif command == "Ns"
                Ns = parse(Float32, lines[end])
                materials[end].Ns = Ns

            elseif command == "Ka"
                Ka = SVec3(parse.(Float32, lines))
                materials[end].Ka = Ka

            elseif command == "Kd"
                Kd = SVec3(parse.(Float32, lines))
                materials[end].Kd = Kd

            elseif command == "Ks"
                Ks = SVec3(parse.(Float32, lines))
                materials[end].Ks = Ks

            elseif command == "Ni"
                Ni = parse(Float32, lines[end])
                materials[end].Ni = Ni
            elseif command == "d"
                d = parse(Float32, lines[end])
                materials[end].d = d
            elseif command == "illum"
                illum = parse(UInt32, lines[end])
                materials[end].illum = illum
            end
        end
    end


    return materials
end
