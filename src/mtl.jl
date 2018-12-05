mutable struct mMaterial
    name::String
    Ka::SVec{3,Float32}
    Kd::SVec{3,Float32}
    Ks::SVec{3,Float32}
    Ns::Float32
    Ni::Float32
    d::Float32
    illum::UInt32
end



struct Material
    name::String
    Ka::SVec{3,Float32}
    Kd::SVec{3,Float32}
    Ks::SVec{3,Float32}
    Ns::Float32
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

    mutablematerials = mMaterial[]

    stream = open(path)
    for wholeLine in eachline(stream)
        chompped = strip(chomp(wholeLine))

        if !isempty(chompped) && !all(iscntrl, chompped)
            lines = split(chompped)
            command = popfirst!(lines)

            if command == "newmtl"
                push!(mutablematerials, mMaterial(defname, defKa, defKd, defKs, defNs, defNi, defd, defillum))

                name = lines[end]
                mutablematerials[end].name = name
            elseif command == "Ns"
                Ns = parse(Float32, lines[end])
                mutablematerials[end].Ns = Ns
            elseif command == "Ka"
                Ka = SVec3(parse.(Float32, lines))
                mutablematerials[end].Ka = Ka
            elseif command == "Kd"
                Kd = SVec3(parse.(Float32, lines))
                mutablematerials[end].Kd = Kd
            elseif command == "Ks"
                Ks = SVec3(parse.(Float32, lines))
                mutablematerials[end].Ks = Ks
            elseif command == "Ni"
                Ni = parse(Float32, lines[end])
                mutablematerials[end].Ni = Ni
            elseif command == "d"
                d = parse(Float32, lines[end])
                mutablematerials[end].d = d
            elseif command == "illum"
                illum = parse(UInt32, lines[end])
                mutablematerials[end].illum = illum
            end
        end
    end
    close(stream)


    materials = Material[]
    for material in mutablematerials
        push!(materials, Material(material.name, material.Ka, material.Kd, material.Ks, material.Ns, material.Ni, material.d, material.illum))
    end
    return materials
end
