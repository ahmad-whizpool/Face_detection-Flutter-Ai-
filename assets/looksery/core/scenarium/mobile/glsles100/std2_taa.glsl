#pragma once
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#include <std2.glsl>
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
vec4 computeMotionVector(vec3 surfacePosObjectSpace,vec4 surfacePosScreenSpace)
{
vec4 prevFramePos=(sc_PrevFrameViewProjectionMatrixArray[sc_GetStereoViewIndex()]*sc_PrevFrameModelMatrix)*vec4(surfacePosObjectSpace,1.0);
prevFramePos/=vec4(prevFramePos.w);
vec3 motion=surfacePosScreenSpace.xyz-prevFramePos.xyz;
motion*=3.0;
vec4 result=vec4(0.0,0.0,0.0,1.0);
result.x=clamp(motion.x,0.0,1.0);
result.y=clamp(-motion.x,0.0,1.0);
return result;
}
vec4 processTAA(vec3 surfacePosObjectSpace,vec4 surfacePosScreenSpace,vec4 shaderOutputColor)
{
#if (sc_MotionVectorsPass)
{
return computeMotionVector(surfacePosObjectSpace,surfacePosScreenSpace);
}
#else
{
return shaderOutputColor;
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
