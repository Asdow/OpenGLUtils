mutable struct Camera{T<:Real}
    projection::SMat{4,4,T,16}
    position::SVec{3,T}
    target::SVec{3,T} # ViewDirection
    upVector::SVec{3,T}
    speed::T
end


function Camera(xRes, yRes)
    cameraWorldPos = SVec3(0.5f0, 0.5f0, 3.0f0)
    cameraTarget = SVec3z(-1.0f0)
    worldUpVector = SVec3y(1.0f0)
    cameraSpeed = 1.0f0;

    aspectRatio = Float32(xRes/yRes)
    FoV = deg2rad(45.0f0)
    zNear = 0.05f0
    zFar = 20.0f0
    projectionMatrix = perspective( FoV, aspectRatio, zNear, zFar )

    camera = Camera(
        projectionMatrix,
        cameraWorldPos,
        cameraTarget,
        worldUpVector,
        cameraSpeed
    )
    return camera
end


lookAtMatrix(camera::Camera{T}) where {T} = lookAtMatrix( camera.position, camera.position+camera.target, camera.upVector )
