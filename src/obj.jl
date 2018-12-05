struct Vertex <: FieldVector{3,Float32}
    x::Float32
    y::Float32
    z::Float32
end



struct Normal <: FieldVector{3,Float32}
    x::Float32
    y::Float32
    z::Float32
end



struct TextureCoordinate <: FieldVector{2,Float32}
    u::Float32
    v::Float32
end



struct Mesh
    name::String
    vertices::Vector{Vertex}
    normals::Vector{Normal}
    texcoords::Vector{TextureCoordinate}
end



function loadOBJ(path::String)
    names = String[]
    vertices = Array{Vertex,1}[]
    normals = Array{Normal,1}[]
    texturecoords = Array{TextureCoordinate,1}[]


    stream = open(path)
    for wholeLine in eachline(stream)
        chompped = strip( chomp(wholeLine) )

        if !isempty(chompped) && !all(iscntrl, chompped)
            lines = split(chompped)
            command = popfirst!(lines)

            if command == "o"
                name = lines[end]
                push!( names, String(name) )
                push!( vertices, Vertex[] )
                push!( normals, Normal[] )
                push!( texturecoords, TextureCoordinate[] )

            elseif command == "v"
                push!( vertices[end], parse.(Float32,lines) )
            elseif command == "vn"
                push!( normals[end], parse.(Float32,lines) )
            elseif command == "vt"
                push!( texturecoords[end], parse.(Float32,lines) )
            end
        end
    end
    close(stream)


    meshes = Mesh[]
    for i in 1:length(names)
        mesh = Mesh(names[i], vertices[i], normals[i], texturecoords[i])
        push!( meshes, mesh )
    end

    return meshes
end
