"""
    createWindow(width, height, title="LearnOpenGL")
Initialize GLFW, create a window and set it as the current context.
Registers resizing callback function with GLFW.
Registers keycallback function so that pressing 'escape' closes the window.
"""
function createWindow(width, height, title="defaultWindow")
    # Initialize GLFW
    GLFW.Init()
    # Configure GLFW. These two lines tell it that the openGL version we use is 3.
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3)
    # Tells GLFW that we only want openGL core functionality.
    GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)


    # Let's create a window. Returns an openGL context, or C_NULL.
    window = GLFW.CreateWindow(width, height, title)


    # Check if the creation of the window was successful
    if window == C_NULL
        println("Failed to create GLFW window")
        GLFW.Terminate()
        return -1
    end

    GLFW.MakeContextCurrent(window)

    # Register the viewport resizing callback function with GLFW
    GLFW.SetFramebufferSizeCallback(window, framebuffer_size_callback)

    # Set keycallback function, so that GLFW.PollEvents handles closing the window.
    GLFW.SetKeyCallback(window, glfwKeyCallback)

    return window
end


"""
    framebuffer_size_callback(window, width, height)
Resizes the viewport after every size change. Needs to be registered with GLFW.
"""
function framebuffer_size_callback(window, width, heigth)
    GL.glViewport(0, 0, width, heigth)
end
