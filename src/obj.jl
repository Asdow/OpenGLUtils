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
    # vindices::Vector{SVec{3,UInt32}} # vertex indices
    # nindices::Vector{SVec{3,UInt32}} # normal indices
    # tindices::Vector{SVec{3,UInt32}} # texture indices
end



function loadOBJ(path::String)
    names = String[]
    temp_vertices = Vertex[]
    temp_normals = Normal[]
    temp_texturecoords = TextureCoordinate[]
    vertexFaces = Array{UInt32,1}[]
    normalFaces = Array{UInt32,1}[]
    textureFaces = Array{UInt32,1}[]


    stream = open(path)
    for wholeLine in eachline(stream)
        chompped = strip( chomp(wholeLine) )

        if !isempty(chompped) && !all(iscntrl, chompped)
            lines = split(chompped)
            command = popfirst!(lines)

            if command == "o"
                name = lines[end]
                push!( names, String(name) )
                # push!( temp_vertices, Vertex[] )
                # push!( temp_normals, Normal[] )
                # push!( temp_texturecoords, TextureCoordinate[] )
                push!( vertexFaces, UInt32[] )
                push!( normalFaces, UInt32[] )
                push!( textureFaces, UInt32[] )
            elseif command == "v"
                push!( temp_vertices, parse.(Float32,lines) )
            elseif command == "vn"
                push!( temp_normals, parse.(Float32,lines) )
            elseif command == "vt"
                uvw = parse.(Float32, lines)
                # HACK strip the w coordinate if encountered. TODO save appropriate uvw type texture coordinate.
                if length(uvw) > 2
                    push!( temp_texturecoords, TextureCoordinate(uvw[1], uvw[2]) )
                else
                    push!( temp_texturecoords, uvw )
                end
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

                    append!( vertexFaces[end], vertIndices )
                    append!( normalFaces[end], normalIndices )
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
                    append!( vertexFaces[end], vertIndices )
                    append!( normalFaces[end], normalIndices )
                    append!( textureFaces[end], texCoordinateIndices )
                # Handle only vertex indices
                else
                    parsed = parse.(UInt32, lines)
                    append!( vertexFaces[end],  parsed )
                end
            end
        end
    end
    close(stream)


    # Go through objects' indices and push correct vertex data into their vectors
    vertices = Array{Vertex,1}[]
    normals = Array{Normal,1}[]
    texturecoords = Array{TextureCoordinate,1}[]

    #FIXME Handles only .objs with full indices v1/vt1/vn1 case
    for name in 1:length(names)
        push!( vertices, Vertex[] )
        push!( normals, Normal[] )
        push!( texturecoords, TextureCoordinate[] )
        for i in 1:length(vertexFaces[name])
            vFace = vertexFaces[name][i]
            nFace = normalFaces[name][i]
            uvFace = textureFaces[name][i]

            vertexPos = temp_vertices[vFace]
            vertexNormal = temp_normals[nFace]
            vertexUV = temp_texturecoords[uvFace]

            # Add the vertex to the object's data
            push!(vertices[name], vertexPos)
            push!(normals[name], vertexNormal)
            push!(texturecoords[name], vertexUV)
        end
    end


    meshes = Mesh[]
    for i in 1:length(names)
        mesh = Mesh(
            names[i],
            vertices[i],
            normals[i],
            texturecoords[i],
        )
        push!( meshes, mesh )
    end

    return meshes
end
