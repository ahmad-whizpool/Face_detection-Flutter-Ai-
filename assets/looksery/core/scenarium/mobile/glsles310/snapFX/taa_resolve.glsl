#version 310 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler sc_TAAColorTextureSmpSC 2:5
//texture texture2D sc_TAAColorTexture 2:2:2:5
//texture texture2DArray sc_TAAColorTextureArrSC 2:8:2:5
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#include <required2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform vec4 sc_TAAColorTextureDims;
uniform vec4 sc_TAAAHistoryTextureDims;
uniform vec4 sc_TAAADepthTextureDims;
uniform vec4 sc_TAAColorTextureSize;
uniform vec4 sc_TAAColorTextureView;
uniform mat3 sc_TAAColorTextureTransform;
uniform vec4 sc_TAAColorTextureUvMinMax;
uniform vec4 sc_TAAColorTextureBorderColor;
uniform vec4 sc_TAAAHistoryTextureSize;
uniform vec4 sc_TAAAHistoryTextureView;
uniform mat3 sc_TAAAHistoryTextureTransform;
uniform vec4 sc_TAAAHistoryTextureUvMinMax;
uniform vec4 sc_TAAAHistoryTextureBorderColor;
uniform vec4 sc_TAAADepthTextureSize;
uniform vec4 sc_TAAADepthTextureView;
uniform mat3 sc_TAAADepthTextureTransform;
uniform vec4 sc_TAAADepthTextureUvMinMax;
uniform vec4 sc_TAAADepthTextureBorderColor;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=vec4(position.xy,0.0,1.0);
vec2 l9_2=(l9_1.xy*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
sc_ProcessVertex(sc_Vertex_t(l9_1,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <required2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 0
#elif sc_TAAColorTextureHasSwappedViews==1
#undef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 1
#endif
#ifndef sc_TAAColorTextureLayout
#define sc_TAAColorTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAColorTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAColorTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 1
#endif
uniform vec4 sc_TAAColorTextureDims;
uniform vec4 sc_TAAAHistoryTextureDims;
uniform vec4 sc_TAAADepthTextureDims;
uniform mat3 sc_TAAColorTextureTransform;
uniform vec4 sc_TAAColorTextureUvMinMax;
uniform vec4 sc_TAAColorTextureBorderColor;
uniform vec4 sc_TAAColorTextureSize;
uniform vec4 sc_TAAColorTextureView;
uniform vec4 sc_TAAAHistoryTextureSize;
uniform vec4 sc_TAAAHistoryTextureView;
uniform mat3 sc_TAAAHistoryTextureTransform;
uniform vec4 sc_TAAAHistoryTextureUvMinMax;
uniform vec4 sc_TAAAHistoryTextureBorderColor;
uniform vec4 sc_TAAADepthTextureSize;
uniform vec4 sc_TAAADepthTextureView;
uniform mat3 sc_TAAADepthTextureTransform;
uniform vec4 sc_TAAADepthTextureUvMinMax;
uniform vec4 sc_TAAADepthTextureBorderColor;
uniform mediump sampler2DArray sc_TAAColorTextureArrSC;
uniform mediump sampler2D sc_TAAColorTexture;
void main()
{
vec4 l9_0;
#if (sc_TAAColorTextureLayout==2)
{
int l9_1;
#if (sc_TAAColorTextureHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
l9_0=sc_SampleTextureBiasOrLevel(sc_TAAColorTextureDims.xy,sc_TAAColorTextureLayout,l9_1,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTextureArrSC);
}
#else
{
int l9_2;
#if (sc_TAAColorTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
l9_0=sc_SampleTextureBiasOrLevel(sc_TAAColorTextureDims.xy,sc_TAAColorTextureLayout,l9_2,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTexture);
}
#endif
sc_writeFragData0(vec4(l9_0.xyz,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
