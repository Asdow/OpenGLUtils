"""
    offsetof(dt::DataType, sym::Symbol)
Find the byte offset of a given fieldname in a struct.
"""
function offsetof(dt::DataType, sym::Symbol)
    # Find the position of a given fieldname in the struct
    position = find( x->x==sym, fieldnames(dt) )
    @assert length(position) != 0 "No fieldname $sym found in Type $dt"

    index = position[]

    # get byte offset of said field
    offset = fieldoffset( dt, index )
    return offset
end


"""
    calculateFrameTime(lastFrame)
Calculates the time elapsed since last frame.
Returns frameTime in seconds (Float32) and lastFrame in DateTime
"""
function calculateFrameTime(lastFrame)
    currentFrame = now()
    frameTime = convert( Float32, Dates.value(currentFrame - lastFrame) ) * 0.001f0
    lastFrame = currentFrame
    return frameTime, lastFrame
end


"""
    calculateFrameTime2(LastFrame)
Calculates the time elapsed since last frame.
Returns frameTime in milliseconds (Int64) and lastFrame in DateTime
"""
function calculateFrameTime2(lastFrame)
    currentFrame = now()
    frameTime = Dates.value(currentFrame - lastFrame)
    lastFrame = currentFrame
    return frameTime, lastFrame
end
