mutable struct Mouse{T<:Real}
    firstMouse::Bool
    yaw::T
    pitch::T
    lastXpos::T
    lastYpos::T
    sensitivity::T
end


function Mouse(xRes, yRes)
    firstMouse = true
    yaw = -90.0f0
    pitch = 0.0f0
    # Initialize mouse last position to screen center.
    lastXpos = Float32(xRes) * 0.5f0
    lastYpos = Float32(yRes) * 0.5f0
    sensitivity = 0.05f0

    mouse = Mouse(
        firstMouse,
        yaw,
        pitch,
        lastXpos,
        lastYpos,
        sensitivity
    )
    return mouse
end
