"""
    glfwKeyCallback(window, key, scancode, action, mods)
Process key inputs. Needs to be registered with GLFW. After registering, the GLFW.PollEvents handles closing the window without a need for processInput(window) function.
"""
function glfwKeyCallback(window, key, scancode, action, mods)
    if (key == GLFW.KEY_ESCAPE && action == GLFW.PRESS)
        GLFW.SetWindowShouldClose( window, true )
    end
end


function handleInput(window, mouse, camera, frameTime)
    # Handle mouse input
    mouseCallback(window, mouse, camera)
    # Handle input for camera movement.
    WASD(window, camera, frameTime)
    return nothing
end


"""
    mouseCallback( window, lastXpos, lastYpos, yaw, pitch, firstMouse )
Implements a basic flying FPS style mouse input.
"""
function mouseCallback(window, mouse, camera)
    mousePos = GLFW.GetCursorPos(window)
    Xpos = Float32(mousePos[1])
    Ypos = Float32(mousePos[2])
    # Check if this is the first time we receive mouse input.
    firstMouse = mouse.firstMouse
    if firstMouse == true
        mouse.lastXpos = Xpos
        mouse.lastYpos = Ypos
        mouse.firstMouse = false
    end


    lastXpos = mouse.lastXpos
    lastYpos = mouse.lastYpos

    Xoffset = Xpos - lastXpos
    Yoffset = lastYpos - Ypos

    mouse.lastXpos = Xpos
    mouse.lastYpos = Ypos


    sensitivityMouse = mouse.sensitivity
    Xoffset *= sensitivityMouse
    Yoffset *= sensitivityMouse


    yaw = mouse.yaw
    yaw += Xoffset
    pitch = mouse.pitch
    pitch += Yoffset
    # Constrain pitch to prevent camera issues
    if pitch > 89.0f0
        pitch = 89.0f0
    elseif pitch < -89.0f0
        pitch = -89.0f0
    end

    mouse.yaw = yaw
    mouse.pitch = pitch

    yawRad = deg2rad(yaw)
    pitchRad = deg2rad(pitch)
    cosPitch = cos( pitchRad )

    frontX = cos( yawRad ) * cosPitch
    frontY = sin( pitchRad )
    frontZ = sin(yawRad) * cosPitch

    camera.target = linAlg.normalize( SVec3(frontX, frontY, frontZ) )
    return nothing
end


"""
    WASD(window, camera::Camera{T}, frameTime) where {T}
Implements a basic flying FPS style WASD input.
"""
function WASD(window, camera::Camera{T}, frameTime) where {T}
    # Calculate the cameraSpeed for smooth camera movement
    speedFactor = camera.speed
    cameraSpeed = speedFactor * frameTime

    # Handle input for camera movement.
    cameraWorldPos = camera.position
    cameraTarget = camera.target
    worldUpVector = camera.upVector

    if GLFW.GetKey( window, GLFW.KEY_W )
        cameraWorldPos += cameraSpeed*cameraTarget
    end
    if GLFW.GetKey( window, GLFW.KEY_S )
        cameraWorldPos -= cameraSpeed*cameraTarget
    end
    if GLFW.GetKey( window, GLFW.KEY_A )
        cameraWorldPos -= linAlg.normalize( linAlg.cross(cameraTarget, worldUpVector) ) * cameraSpeed
    end
    if GLFW.GetKey( window, GLFW.KEY_D )
        cameraWorldPos += linAlg.normalize( linAlg.cross(cameraTarget, worldUpVector) ) * cameraSpeed
    end

    camera.position = cameraWorldPos;
    return nothing
end
