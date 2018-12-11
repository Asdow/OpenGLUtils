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
    vindices::Vector{SVec{3,UInt32}} # vertex indices
    nindices::Vector{SVec{3,UInt32}} # normal indices
    tindices::Vector{SVec{3,UInt32}} # texture indices
end



function loadOBJ(path::String)
    names = String[]
    vertices = Array{Vertex,1}[]
    normals = Array{Normal,1}[]
    texturecoords = Array{TextureCoordinate,1}[]
    vertexFaces = Array{SVec{3,UInt32},1}[]
    normalFaces = Array{SVec{3,UInt32},1}[]
    textureFaces = Array{SVec{3,UInt32},1}[]


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
                push!( vertexFaces, SVec{3,UInt32}[] )
                push!( normalFaces, SVec{3,UInt32}[] )
                push!( textureFaces, SVec{3,UInt32}[] )
            elseif command == "v"
                push!( vertices[end], parse.(Float32,lines) )
            elseif command == "vn"
                push!( normals[end], parse.(Float32,lines) )
            elseif command == "vt"
                push!( texturecoords[end], parse.(Float32,lines) )
            # Handle faces
        elseif command == "f"
                # Handle missing texture coordinate indices case, ie.
                # f v1//vn1 v2//vn2 v3//vn3 ...
                if any( x->occursin("//", x), lines )
                    indexes = split.(lines, "//")

                    vertIndices = UInt32[]
                    normalIndices = UInt32[]
                    for i in 1:length(indexes)
                        parsed = parse.(UInt32, indexes[i])
                        push!(vertIndices, parsed[1])
                        push!(normalIndices, parsed[2])
                    end

                    vertexTriangle = SVec3( vertIndices )
                    push!( vertexFaces[end], vertexTriangle )
                    normalTriangle = SVec3( normalIndices )
                    push!( normalFaces[end], normalTriangle )
                # Handle full indices case, ie.
                # f v1/vt1/vn1 v2/vt2/vn2 v3/vt2/vn3 ...
            elseif any(x->occursin("/", x), lines)
                    indexes = split.(lines, "/")

                    vertIndices = UInt32[]
                    texCoordinateIndices =  UInt32[]
                    normalIndices = UInt32[]
                    for i in 1:length(indexes)
                        parsed = parse.(UInt32, indexes[i])
                        push!(vertIndices, parsed[1])
                        push!(texCoordinateIndices, parsed[2])
                        push!(normalIndices, parsed[3])
                    end
                    push!( vertexFaces[end],  SVec3( vertIndices ) )
                    push!( normalFaces[end], SVec3( normalIndices ) )
                    push!( textureFaces[end], SVec3( texCoordinateIndices ) )
                # Handle only vertex indices
                else
                    parsed = parse.(UInt32, lines)
                    push!( vertexFaces[end],  SVec3( parsed ) )
                end
            end
        end
    end
    close(stream)


    meshes = Mesh[]
    for i in 1:length(names)
        mesh = Mesh(
            names[i],
            vertices[i],
            normals[i],
            texturecoords[i],
            vertexFaces[i],
            normalFaces[i],
            textureFaces[i]
        )
        push!( meshes, mesh )
    end

    return meshes
end
