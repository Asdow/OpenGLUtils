"""
    rotmatX(angle::T) where {T}
Creates a rotation matrix around X-axis.
angle must be in radians.
"""
function rotmatX(angle::T) where {T}
    T0, T1 = zero(T), one(T)
    ca = cos(angle)
    sa = sin(angle)
    SMat44(
        T1, T0, T0, T0,
        T0, ca, sa, T0,
        T0, -sa, ca, T0,
        T0, T0, T0, T1
    )
end


"""
    rotmatY(angle::T) where {T}
Creates a rotation matrix around Y-axis.
angle must be in radians.
"""
function rotmatY(angle::T) where {T}
    T0, T1 = zero(T), one(T)
    ca = cos(angle)
    sa = sin(angle)
    SMat44(
        ca, T0, -sa, T0,
        T0, T1, T0, T0,
        sa, T0, ca, T0,
        T0, T0, T0, T1
    )
end


"""
    rotmatZ(angle::T) where {T}
Creates a rotation matrix around Z-axis.
angle must be in radians.
"""
function rotmatZ(angle::T) where {T}
    T0, T1 = zero(T), one(T)
    ca = cos(angle)
    sa = sin(angle)
    SMat44(
        ca, sa, T0, T0,
        -sa, ca,  T0, T0,
        T0, T0, T1, T0,
        T0, T0, T0, T1
    )
end


"""
    translationMatrix(t::AbstractVector{T}) where {T}
Creates a 4x4 translationmatrix out of a vector specifying the translation.
"""
function translationMatrix(t::AbstractVector{T}) where {T}
    T0, T1 = zero(T), one(T)
    SMat44(
        T1,  T0,  T0,  T0,
        T0,  T1,  T0,  T0,
        T0,  T0,  T1,  T0,
        t[1],t[2],t[3],T1,
    )
end


"""
    scaleMatrix(t::AbstractVector{T}) where {T}
Creates a 4x4 scaling matrix out of a vector specifying the scale values.
"""
function scaleMatrix(t::AbstractVector{T}) where {T}
    T0, T1 = zero(T), one(T)
    SMat44(
        t[1], T0, T0, T0,
        T0, t[2], T0, T0,
        T0, T0, t[3], T0,
        T0, T0, T0, T1,
    )
end


"""
    ortho(left::T, right::T, bottom::T, top::T, zNear::T, zFar::T) where {T}
Creates an orthographic projection matrix.
left, right, bottom & up define the frustum coordinates.
zNear & zFar define the near and far planes.
"""
function ortho(
        left::T,
        right::T,
        bottom::T,
        top::T,
        zNear::T,
        zFar::T
    ) where {T}
    @assert left != right "left must not be equal to right!"
    @assert bottom != top "bottom must not be equal to top!"
    @assert zNear != zFar "zNear must not be equal to zFar!"


    T0 = zero(T)
    T1 = one(T)
    T2 = T(2.0)

    R11 = T2 / (right-left)

    R22 = T2 / (top-bottom)

    R33 = -T2 / (zFar-zNear)

    R14 = -(right+left) / (right-left)
    R24 = -(top+bottom) / (top-bottom)
    R34 = -(zFar+zNear) / (zFar-zNear)


    orthoMatrix = SMat44(
        R11, T0, T0, T0,
        T0, R22, T0, T0,
        T0, T0, R33, T0,
        R14, R24, R34, T1
    )
    return orthoMatrix
end


"""
    perspective(fovVertical::T, aspectRatio::T, zNear::T, zFar::T) where {T}
Creates a perspective projection matrix.
fovVertical specifies the vertical field of view angle in radians.
aspectRatio defines the aspect ratio of the scene and sets the height of the perspective frustum.
zNear & zFar define the near and far planes, and should be > 0.
Never set zNear = 0 !!!
"""
function perspective(
        fovVertical::T,
        aspectRatio::T,
        zNear::T,
        zFar::T
    ) where {T}
    @assert zNear > zero(T) && zFar > zero(T) "zNear and zFar must be positive!"

    tanHalfFov = tan( fovVertical*T(0.5) )
    T0 = zero(T)
    T1 = one(T)
    T2 = T(2.0)

    R11 = T1 / ( aspectRatio*tanHalfFov )

    R22 = T1 / tanHalfFov

    R33 = -(zFar + zNear) / (zFar - zNear)

    R43 = -T1

    R34 = -(T2 * zFar * zNear) / (zFar - zNear)

    perspectiveMatrix = SMat44(
        R11, T0, T0, T0,
        T0, R22, T0, T0,
        T0, T0, R33, R43,
        T0, T0, R34, T0
    )
    return perspectiveMatrix
end


"""
    perspective(left::T, right::T, bottom::T, top::T, zNear::T, zFar::T) where {T}
Creates a perspective projection matrix.
left, right, bottom & up define the frustum coordinates.
zNear & zFar define the near and far planes, and should be > 0.
Never set zNear = 0 !!!
"""
function perspective(
        left::T,
        right::T,
        bottom::T,
        top::T,
        zNear::T,
        zFar::T
    ) where {T}

    #NOTE Tällä ei tuu samoja tuloksia kuin fovVertical-versiolla. Kaikki laskenta pitäisi olla oikein. Käytetäänkö tätä jossain eri tarkoituksessa openGL:ssä???
    T0 = zero(T)
    T1 = one(T)
    T2 = T(2.0)

    R11 = (T2*zNear) / (right-left)

    R22 = (T2*zNear) / (top-bottom)

    R13 = (right + left) / (right - left)
    R23 = (top + bottom) / (top - bottom)
    R33 = -(zFar + zNear) / (zFar - zNear)
    R43 = -T1

    R34 = -(T2 * zFar * zNear) / (zFar - zNear)


    perspectiveMatrix = SMat44(
        R11, T0, T0, T0,
        T0, R22, T0, T0,
        R13, R23, R33, R43,
        T0, T0, R34, T0
    )
    return perspectiveMatrix
end


"""
    lookAtMatrix( cameraWorldPos, cameraTarget, worldUpVector )
Calculates a lookAt transformation matrix that transforms world coordinates to view space.
cameraWorldPos = camera's location in world coordinates.
cameraTarget = direction vector where the camera is looking at in world coordinates.
worldUpVector = direction vector specifying the up vector in world coordinates.
"""
function lookAtMatrix( cameraWorldPos::AbstractVector{T}, cameraTarget::AbstractVector{T}, worldUpVector::AbstractVector{T} ) where {T}
    # cameraDirection points FROM the cameraTarget TO the cameraWorldPos. Unintuitive, but whatevs.
    cameraDirection = linAlg.normalize( cameraWorldPos - cameraTarget )
    # Directionvector defining the camera's right vector is defined through an up vector in world coordinates.
    cameraRightVector = linAlg.normalize( linAlg.cross( worldUpVector, cameraDirection ) )
    # Camera up vector can then be calculated from direction and right vectors
    cameraUpVector = linAlg.cross( cameraDirection, cameraRightVector )

    # Create a lookAt matrix that transforms the world coordinates to view space.
    T0 = zero(T)
    T1 = one(T)

    rotationMatrix = SMat44(
        SVec4(cameraRightVector, T0),
        SVec4(cameraUpVector, T0),
        SVec4(cameraDirection, T0),
        SVec4w(T1)
    )

    rotationMatrix = rotationMatrix'

    translationMatrix = SMat44(
        SVec4x(T1),
        SVec4y(T1),
        SVec4z(T1),
        SVec4(-cameraWorldPos, T1)
    )

    lookAt = rotationMatrix * translationMatrix

    return lookAt
end
