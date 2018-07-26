"""
    createVertexArrayObject(n=1)
Create n amount of vertex array objects. Returns an array of length n.
"""
function createVertexArrayObject(n=1)
    VAO = GL.GLuint[0 for i in 1:n]
    GL.glGenVertexArrays(n, VAO)

    return VAO
end


"""
    createBufferObject(n=1)
Create n amount of vertex buffer objects. Returns an array of length n.
"""
function createBufferObject(n=1)
    VBO = GL.GLuint[0 for i in 1:n]
    GL.glGenBuffers(n, VBO)

    return VBO
end


"""
    createTextureObject(n=1)
Create n amount of texture buffer objects. Returns an array of length n.
"""
function createTextureObject(n=1)
    texture = GL.GLuint[0 for i in 1:n]
    GL.glGenTextures(n, texture)

    return texture
end


function setVertexAttribute!(layout, dataLength, dataStride, dataOffset)
    # NOTE dataOffset needs to be in Ptr{Void} form and using the intrinsic bitcast function makes it work.
    cOffset = Base.bitcast( Ptr{Nothing}, dataOffset )

    GL.glVertexAttribPointer(
        layout,
        dataLength,
        GL.GL_FLOAT,
        GL.GL_FALSE,
        dataStride,
        cOffset
    )
    GL.glEnableVertexAttribArray( layout )
    return nothing
end
