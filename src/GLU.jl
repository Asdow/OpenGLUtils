__precompile__()
module GLU

using StaticArrayUtils

import FileIO
import ModernGL
global const GL = ModernGL;
import GLFW

include("BufferObjects.jl")
include("shaders.jl")
include("textures.jl")
include("uniforms.jl")

include("transformations.jl")
include("camera.jl")
include("mouse.jl")
include("input.jl")

include("window.jl")

include("misc.jl")

end # module
