# Animation-System technical details

## animation.lua
used to save an animation to the registry

the script is based on a system of keyframes and transforms

the animation will be saved to the registry, and all physical parts will be deleted on startup


### keyframes
a keyframe is represented by a body with the tag "frame"

the order of the keyframes depends on their order in the editor (top is 1st, bottom last)

the body may also have a tag "time=somenumber" to choose how long it should take to finish the keyframe (default 1)

the position of the body is the origin point for the frame, all transforms are relative to it.

This means that each keyframe can be freely moved in the editor without affecting the animation, making for an easier animation process.

### transforms
the transforms are also represented by bodies

each body should be tagged with unique ids starting from 1

the bodies may have a shape as a child to help with the animating process, but this is not necessary


### structure in the editor
```
[script] animation.lua
    [body] tags:frame
        [body] tags:id=1
            [vox] (optional, but helps a lot when animating)
            
        [body] tags:id=2
            ...
    
    [body] tags:frame
      ...
      
    ...
    
    [body] tags:end
```



## animation_handler.lua
WIP
