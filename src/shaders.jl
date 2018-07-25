"""
    createShader(shaderSource::Array{UInt8,1}, shaderType)
Create a shader from a .glsl source, compile and return it. shaderSource should be a byte array literal.
shaderType tells what kind of a shader we are creating, eg. GL.GL_VERTEX_SHADER.
"""
function createShader(shaderSource::Array{UInt8,1}, shaderType)
    shader = GL.glCreateShader( shaderType )

    # NOTE ShaderSource needs to be converted into a pointer with this montrosity because of Julia. It then goes into the glShaderSource argument as a source.
    shaderSourcePointer = convert( Ptr{UInt8}, pointer( [ pointer(shaderSource) ] ) )

    # Link the shader sourcecode into the newly created shader so it can be compiled.
    GL.glShaderSource( shader, 1, shaderSourcePointer, C_NULL )

    GL.glCompileShader( shader )
    # Check if the compilation was successful. If not, raise an error.
	if validateShaderCompilation(shader) == false
        error( "Shader creation error: ", GetShaderInfoLog(shader) )
    end

    return shader
end


"""
    validateShaderCompilation(shader)
Checks the shader's compilation status. Returns true if it was successful.
"""
function validateShaderCompilation(shader)
	success = GL.GLint[0]
    # Query the shader of its compile status.
	GL.glGetShaderiv(shader, GL.GL_COMPILE_STATUS, success)
	success[] == GL.GL_TRUE
end


"""
    GetShaderInfoLog(shader)
Get a shader's infoLog and convert it into a string.
"""
function GetShaderInfoLog(shader)
    # Get the length of the shader's infoLog
    infoLogLength = GL.GLint[0]
    GL.glGetShaderiv(shader, GL.GL_INFO_LOG_LENGTH, infoLogLength)

    # Read the shader infoLog and store it into infoLogBuffer.
    infoLogBuffer = zeros(GL.GLchar, infoLogLength[])
    GL.glGetShaderInfoLog(shader, infoLogLength[], C_NULL, infoLogBuffer)

    # Turn it into a string that can be printed out.
    infoLogMessage = unsafe_string( pointer(infoLogBuffer) )
    return infoLogMessage
end


"""
    createShaderProgram(vertexShader, FragmentShader)
Create a shader program with the supplied vertex and fragment shaders.
Raises an error if creation was not successful.
"""
function createShaderProgram(vertexShader, FragmentShader)
    shaderProgram = GL.glCreateProgram()

    # Attach shaders to the shader program
    GL.glAttachShader( shaderProgram, vertexShader )
    GL.glAttachShader( shaderProgram, FragmentShader )

    # Link the attached shaders to the shader program.
    GL.glLinkProgram( shaderProgram )
    # Check if linking the shaders was successful
    if validateShaderLinking(shaderProgram) == false
        error( "Shader linking error: ", GetShaderInfoLog(shader) )
    end

    # After successful inking, the created shader objects can be safely deleted.
    GL.glDetachShader( shaderProgram, vertexShader )
    GL.glDetachShader( shaderProgram, FragmentShader )
    GL.glDeleteShader( vertexShader )
    GL.glDeleteShader( FragmentShader )

    return shaderProgram
end


"""
    createShaderProgram(vertexShaderPath::T, FragmentShaderPath::T) where {T<:string}
Create a shader program with the supplied paths to vertex and fragment shader sourcecodes.
Raises an error if creation was not successful.
"""
function createShaderProgram(vertexShaderPath::String, FragmentShaderPath::String)
    vertexShaderSource = read(vertexShaderPath);
    vertShader = createShader( vertexShaderSource, GL.GL_VERTEX_SHADER )

    fragmentShaderSource = read(FragmentShaderPath);
    fragShader = createShader( fragmentShaderSource, GL.GL_FRAGMENT_SHADER )

    shaderProgram = createShaderProgram( vertShader, fragShader )

    return shaderProgram
end


"""
    validateShaderLinking(shaderProgram)
Checks the shader programs linking status. Returns true if it was successful.
"""
function validateShaderLinking(shaderProgram)
	success = GL.GLint[0]
    # Query the shaderProgram of its linking status.
	GL.glGetProgramiv(shaderProgram, GL.GL_LINK_STATUS, success)
	success[] == GL.GL_TRUE
end


"""
    GetShaderProgramInfoLog(shaderProgram)
Get a shaderProgram's infoLog and convert it into a string.
"""
function GetShaderProgramInfoLog(shaderProgram)
    # Get the length of the shader's infoLog
    infoLogLength = GL.GLint[0]
    GL.glGetProgramiv(shaderProgram, GL.GL_INFO_LOG_LENGTH, infoLogLength)

    # Read the shaderProgram infoLog and store it into infoLogBuffer.
    infoLogBuffer = zeros(GL.GLchar, infoLogLength[])
    GL.glGetProgramInfoLog(shaderProgram, infoLogLength[], C_NULL, infoLogBuffer)

    # Turn it into a string that can be printed out.
    infoLogMessage = unsafe_string( pointer(infoLogBuffer) )
    return infoLogMessage
end
