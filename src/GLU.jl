__precompile__()
module GLU

using StaticArrays
using StaticArrayUtils

import FileIO
import ModernGL
global const GL = ModernGL;
import GLFW

import LinearAlgebra
global const linAlg = LinearAlgebra

import Dates


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

include("mtl.jl")
include("obj.jl")

end # module
