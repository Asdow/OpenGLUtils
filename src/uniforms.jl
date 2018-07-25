# Utility functions for setting uniforms
# Integers and booleans
function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue::Integer)
    uniformLocation = GL.glGetUniformLocation( shaderProgram, uniformName )
    GL.glUniform1i( uniformLocation, uniformValue )
    return nothing
end


function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue1::T, uniformValue2::T) where {T<:Integer}
    uniformLocation = GL.glGetUniformLocation( shaderProgram, uniformName )
    GL.glUniform2i( uniformLocation, uniformValue1, uniformValue2 )
    return nothing
end


# Float32
function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue::Float32)
    uniformLocation = GL.glGetUniformLocation( shaderProgram, uniformName )
    GL.glUniform1f( uniformLocation, uniformValue )
    return nothing
end

function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue1::T, uniformValue2::T) where {T<:Float32}
    uniformLocation = GL.glGetUniformLocation( shaderProgram, uniformName )
    GL.glUniform2f( uniformLocation, uniformValue1, uniformValue2 )
    return nothing
end

function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue1::T, uniformValue2::T, uniformValue3::T) where {T<:Float32}
    uniformLocation = GL.glGetUniformLocation( shaderProgram, uniformName )
    GL.glUniform3f( uniformLocation, uniformValue1, uniformValue2, uniformValue3 )
    return nothing
end

function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue1::T, uniformValue2::T, uniformValue3::T, uniformValue4::T) where {T<:Float32}
    uniformLocation = GL.glGetUniformLocation( shaderProgram, uniformName )
    GL.glUniform4f( uniformLocation, uniformValue1, uniformValue2, uniformValue3, uniformValue4 )
    return nothing
end


function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue::SVec{3, T}) where {T}
    setUniform( shaderProgram, uniformName, uniformValue[1], uniformValue[2], uniformValue[3] )
    return nothing
end


# 4x4 Float32 matrix
function setUniform(shaderProgram::UInt32, uniformName::String, uniformValue::SMat{4,4, Float32, 16}, transpose=GL.GL_FALSE)
    uniformLocation = GL.glGetUniformLocation( shaderProgram, uniformName )
    count = UInt8(1)

    GL.glUniformMatrix4fv( uniformLocation, count, transpose,  uniformValue )
    return nothing
end


###############################################################################
"""
    setUniformBlock(shader, blockName::String, bindingPoint)
Set a uniform block's binding point for a shader.
"""
function setUniformBlock(shader, blockName::String, bindingPoint)
    uniformBlock = GL.glGetUniformBlockIndex( shader, blockName )
    GL.glUniformBlockBinding( shader, uniformBlock, UInt32(bindingPoint) )
    return nothing
end
