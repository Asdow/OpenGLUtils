function loadTexture(path::String)
    # load the texture file so we can create a texture from it.
    image = FileIO.load(path)
    imageSize = size(image)
    # HACK, FIXME
    # determine if texture is RGB or RGBA
    if length(image[1]) == 4
        colorType = GL.GL_RGBA
    else
        colorType = GL.GL_RGB
    end

    GL.glTexImage2D(GL.GL_TEXTURE_2D, 0, colorType, imageSize[1], imageSize[2], 0, colorType, GL.GL_UNSIGNED_BYTE, image);
    GL.glGenerateMipmap(GL.GL_TEXTURE_2D);
    return nothing
end
