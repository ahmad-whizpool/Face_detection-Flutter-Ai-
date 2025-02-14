#version 310 es
//SG_REFLECTION_BEGIN(100)
//attribute vec4 position 0
//output vec4 sc_FragData0 0
//sampler sampler colorInputSmp 2:17
//sampler sampler hitDistanceSmp 2:19
//sampler sampler microNormalsSmp 2:20
//sampler sampler receivers0Smp 2:21
//sampler sampler receivers1Smp 2:22
//sampler sampler searchParamResultsSmp 2:24
//sampler sampler z_hitIdAndBarycentricSmp 2:28
//sampler sampler z_rayDirectionsSmp 2:29
//texture texture2D colorInput 2:2:2:17
//texture utexture2D hitDistance 2:4:2:19
//texture texture2D microNormals 2:5:2:20
//texture utexture2D receivers0 2:6:2:21
//texture utexture2D receivers1 2:7:2:22
//texture texture2D searchParamResults 2:9:2:24
//texture utexture2D z_hitIdAndBarycentric 2:13:2:28
//texture texture2D z_rayDirections 2:14:2:29
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#ifndef lray_ProgramIndex
#define lray_ProgramIndex 0
#endif
uniform vec4 searchParamResultsSize;
uniform vec4 colorInputSize;
uniform float depthRef;
uniform vec3 cameraPosition;
uniform vec3 OriginNormalizationScale;
uniform vec3 OriginNormalizationScaleInv;
uniform vec3 OriginNormalizationOffset;
uniform float distanceNormalizationScale;
uniform bool stochasticEnabled;
uniform vec2 kernel_mask;
uniform float scene_dimensions;
uniform float max_distance;
uniform float maxPlanarFilterDiameter;
uniform float minStochFilterDiameter;
uniform float maxStochFilterDiameter;
uniform vec2 planarReceiverData[32];
uniform float missedRayDepthStencilValue;
uniform float DepthStencilNormalization;
uniform float maxRayLen;
in vec4 position;
void main()
{
#if (lray_ProgramIndex==0)
{
gl_Position=vec4(position.xy,depthRef,1.0);
}
#else
{
#if (lray_ProgramIndex==1)
{
gl_Position=vec4(position.xy,-1.0,1.0);
}
#else
{
#if (lray_ProgramIndex==2)
{
gl_Position=vec4(position.xy,-1.0,1.0);
}
#else
{
#if (lray_ProgramIndex==3)
{
gl_Position=vec4(position.xy,0.0,1.0);
}
#else
{
gl_Position=vec4(position.xy,0.0,1.0);
}
#endif
}
#endif
}
#endif
}
#endif
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
precision highp float;
precision highp int;
#ifndef sc_UseFragDepth
#define sc_UseFragDepth 0
#elif sc_UseFragDepth==1
#undef sc_UseFragDepth
#define sc_UseFragDepth 1
#endif
const float g9_6[55]=float[](0.0109392,0.0151898,0.0208324,0.0282195,0.0377555,0.0498921,0.0651183,0.0839449,0.106882,0.134412,0.166951,0.204814,0.24817,0.297002,0.351066,0.409863,0.472616,0.538267,0.605491,0.672725,0.738224,0.800127,0.856543,0.905648,0.945777,0.975524,0.993821,1.0,0.993821,0.975524,0.945777,0.905648,0.856543,0.800127,0.738224,0.672725,0.605491,0.538267,0.472616,0.409863,0.351066,0.297002,0.24817,0.204814,0.166951,0.134412,0.106882,0.0839449,0.0651183,0.0498921,0.0377555,0.0282195,0.0208324,0.0151898,0.0109392);
const ivec2 g9_7[33]=ivec2[](ivec2(0),ivec2(0,1),ivec2(0,-1),ivec2(-1,0),ivec2(1,0),ivec2(-1),ivec2(1),ivec2(-1,1),ivec2(1,-1),ivec2(2,-2),ivec2(-2,2),ivec2(2),ivec2(-2),ivec2(-3,-1),ivec2(-1,-3),ivec2(1,-3),ivec2(3,-1),ivec2(3,1),ivec2(1,3),ivec2(-1,3),ivec2(-3,1),ivec2(-2,-4),ivec2(0,-4),ivec2(2,-4),ivec2(-2,4),ivec2(0,4),ivec2(2,4),ivec2(-4,-2),ivec2(-4,0),ivec2(-4,2),ivec2(4,-2),ivec2(4,0),ivec2(4,2));
#ifndef lray_ProgramIndex
#define lray_ProgramIndex 0
#endif
uniform vec4 searchParamResultsSize;
uniform vec4 colorInputSize;
uniform vec3 OriginNormalizationScaleInv;
uniform vec3 OriginNormalizationOffset;
uniform float distanceNormalizationScale;
uniform bool stochasticEnabled;
uniform vec2 kernel_mask;
uniform float max_distance;
uniform float scene_dimensions;
uniform float maxPlanarFilterDiameter;
uniform float minStochFilterDiameter;
uniform float maxStochFilterDiameter;
uniform vec3 cameraPosition;
uniform vec2 planarReceiverData[32];
uniform float missedRayDepthStencilValue;
uniform float DepthStencilNormalization;
uniform float maxRayLen;
uniform vec3 OriginNormalizationScale;
uniform float depthRef;
uniform highp usampler2D hitDistance;
uniform highp usampler2D receivers0;
uniform highp usampler2D z_hitIdAndBarycentric;
uniform highp usampler2D receivers1;
uniform highp sampler2D microNormals;
uniform highp sampler2D searchParamResults;
uniform highp sampler2D z_rayDirections;
uniform highp sampler2D colorInput;
layout(location=0) out vec4 sc_FragData0;
bool stochastic_reflections;
void fs_lray_resolve()
{
ivec2 l9_0=ivec2(gl_FragCoord.xy);
if (all(equal(texelFetch(receivers0,l9_0,0),uvec4(0u))))
{
#if (sc_UseFragDepth)
{
gl_FragDepth=0.0;
}
#endif
return;
}
uvec4 l9_1=texelFetch(z_hitIdAndBarycentric,l9_0,0);
uint l9_2=l9_1.x;
if (l9_2==0u)
{
#if (sc_UseFragDepth)
{
gl_FragDepth=missedRayDepthStencilValue;
}
#endif
return;
}
#if (sc_UseFragDepth)
{
gl_FragDepth=float(l9_2)*DepthStencilNormalization;
}
#endif
}
float get_normalized_distance(ivec2 p)
{
ivec2 l9_0=p;
uvec4 l9_1=texelFetch(hitDistance,l9_0,0);
uint l9_2=l9_1.x;
if (l9_2==4294967295u)
{
if (stochastic_reflections)
{
return 10.0;
}
else
{
return 1.0;
}
}
return clamp((float(l9_2)/distanceNormalizationScale)/max_distance,0.0,1.0);
}
vec2 parameter_search(ivec2 p,vec3 normal0,float roughness)
{
ivec2 l9_0=p;
vec3 l9_1=(vec3(texelFetch(receivers0,l9_0,0).xyz)*OriginNormalizationScaleInv)+OriginNormalizationOffset;
vec2 l9_2=vec2(0.0);
l9_2.y=0.00116012*length(l9_1-cameraPosition);
float l9_3;
float l9_4;
l9_4=0.0;
l9_3=0.0;
float l9_5;
float l9_6;
int l9_7=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_7<33)
{
ivec2 l9_8=p;
ivec2 l9_9=g9_7[l9_7];
ivec2 l9_10=l9_8+l9_9;
if (!(!all(equal(texelFetch(receivers0,l9_10,0),uvec4(0u)))))
{
l9_6=l9_4;
l9_5=l9_3;
l9_4=l9_6;
l9_3=l9_5;
l9_7++;
continue;
}
float l9_11=get_normalized_distance(l9_10);
if (stochastic_reflections)
{
if (l9_11==10.0)
{
l9_6=l9_4;
l9_5=l9_3;
l9_4=l9_6;
l9_3=l9_5;
l9_7++;
continue;
}
}
float l9_12=length(l9_1-((vec3(texelFetch(receivers0,l9_10,0).xyz)*OriginNormalizationScaleInv)+OriginNormalizationOffset));
float l9_13;
if (stochastic_reflections)
{
vec3 l9_14=normal0;
vec4 l9_15=texelFetch(microNormals,l9_10,0);
float l9_16=l9_15.x;
float l9_17=l9_15.y;
float l9_18=(1.0-abs(l9_16))-abs(l9_17);
vec3 l9_19=vec3(l9_16,l9_17,l9_18);
float l9_20=max(-l9_18,0.0);
float l9_21;
if (l9_16>=0.0)
{
l9_21=-l9_20;
}
else
{
l9_21=l9_20;
}
float l9_22;
if (l9_17>=0.0)
{
l9_22=-l9_20;
}
else
{
l9_22=l9_20;
}
vec2 l9_23=l9_19.xy+vec2(l9_21,l9_22);
l9_13=1.0-dot(l9_14,normalize(vec3(l9_23.x,l9_23.y,l9_19.z)));
}
else
{
vec3 l9_24=normal0;
uvec4 l9_25=texelFetch(receivers1,l9_10,0);
vec2 l9_26=unpackHalf2x16(l9_25.x);
mediump float l9_27=l9_26.x;
vec2 l9_28=unpackHalf2x16(l9_25.y);
mediump float l9_29=l9_28.x;
float l9_30=(1.0-abs(l9_27))-abs(l9_29);
vec3 l9_31=vec3(l9_27,l9_29,l9_30);
float l9_32=max(-l9_30,0.0);
float l9_33;
if (l9_27>=0.0)
{
l9_33=-l9_32;
}
else
{
l9_33=l9_32;
}
float l9_34;
if (l9_29>=0.0)
{
l9_34=-l9_32;
}
else
{
l9_34=l9_32;
}
vec2 l9_35=l9_31.xy+vec2(l9_33,l9_34);
l9_13=1.0-dot(l9_24,normalize(vec3(l9_35.x,l9_35.y,l9_31.z)));
}
float l9_36=pow(2.71828,(((-l9_12)*l9_12)*5.0)-((l9_13*l9_13)*5.0));
l9_6=l9_4+(l9_36*l9_11);
l9_5=l9_3+l9_36;
l9_4=l9_6;
l9_3=l9_5;
l9_7++;
continue;
}
else
{
break;
}
}
vec2 l9_37;
if (l9_3<0.0001)
{
vec2 l9_38=l9_2;
l9_38.x=0.0;
l9_37=l9_38;
}
else
{
vec2 l9_39=l9_2;
l9_39.x=l9_4/l9_3;
l9_37=l9_39;
}
return l9_37;
}
void fs_lray_param_search()
{
ivec2 l9_0=ivec2(gl_FragCoord.xy);
if (!(!all(equal(texelFetch(receivers0,l9_0,0),uvec4(0u)))))
{
sc_FragData0=vec4(0.0);
return;
}
uvec4 l9_1=texelFetch(receivers1,l9_0,0);
vec2 l9_2=unpackHalf2x16(l9_1.x);
mediump float l9_3=l9_2.x;
vec2 l9_4=unpackHalf2x16(l9_1.y);
mediump float l9_5=l9_4.x;
float l9_6=(1.0-abs(l9_3))-abs(l9_5);
vec3 l9_7=vec3(l9_3,l9_5,l9_6);
float l9_8=max(-l9_6,0.0);
float l9_9;
if (l9_3>=0.0)
{
l9_9=-l9_8;
}
else
{
l9_9=l9_8;
}
float l9_10;
if (l9_5>=0.0)
{
l9_10=-l9_8;
}
else
{
l9_10=l9_8;
}
vec2 l9_11=vec2(l9_9,l9_10);
vec2 l9_12=l9_7.xy+l9_11;
uint l9_13=l9_1.w;
uint l9_14=l9_13&1023u;
float l9_15;
if (l9_14==1023u)
{
l9_15=-1.0;
}
else
{
l9_15=float(l9_14)*0.001;
}
bool l9_16;
if (stochasticEnabled)
{
l9_16=!((texelFetch(receivers0,l9_0,0).w&2047u)==0u);
}
else
{
l9_16=stochasticEnabled;
}
stochastic_reflections=l9_16;
vec2 l9_17;
if (l9_15<=0.0)
{
l9_17=vec2(0.0);
}
else
{
vec2 l9_18=parameter_search(l9_0,normalize(vec3(l9_12.x,l9_12.y,l9_7.z)),l9_15);
vec2 l9_19;
float l9_20;
if (!stochastic_reflections)
{
uint l9_21=l9_13>>10u;
float l9_22=l9_18.x;
vec2 l9_23=l9_18;
l9_23.x=mix(l9_22,l9_22*l9_22,planarReceiverData[l9_21].x);
float l9_24;
if (planarReceiverData[l9_21].y>0.1)
{
l9_24=pow(l9_15,planarReceiverData[l9_21].y);
}
else
{
l9_24=l9_15;
}
l9_20=l9_24;
l9_19=l9_23;
}
else
{
l9_20=l9_15;
l9_19=l9_18;
}
float l9_25=l9_20*0.218166;
float l9_26=(2.0*(l9_19.x*scene_dimensions))*tan(l9_25);
float l9_27;
float l9_28;
if (stochastic_reflections)
{
l9_28=maxStochFilterDiameter;
l9_27=minStochFilterDiameter;
}
else
{
l9_28=maxPlanarFilterDiameter;
l9_27=3.0;
}
l9_17=vec2(clamp(l9_26/l9_19.y,l9_27,l9_28),clamp(l9_26,1.0,255.0))*vec2(0.00392157);
}
sc_FragData0=vec4(l9_17,0.0,0.0);
}
float sampleGauss(float x)
{
return g9_6[int(round(x*55.0))];
}
vec4 gather(ivec2 p,vec2 kernel,float coverageWS)
{
ivec2 l9_0=p;
ivec2 l9_1=p;
uvec4 l9_2=texelFetch(receivers1,l9_1,0);
vec2 l9_3=unpackHalf2x16(l9_2.x);
mediump float l9_4=l9_3.x;
vec2 l9_5=unpackHalf2x16(l9_2.y);
mediump float l9_6=l9_5.x;
float l9_7=(1.0-abs(l9_4))-abs(l9_6);
vec3 l9_8=vec3(l9_4,l9_6,l9_7);
float l9_9=max(-l9_7,0.0);
float l9_10;
if (l9_4>=0.0)
{
l9_10=-l9_9;
}
else
{
l9_10=l9_9;
}
float l9_11;
if (l9_6>=0.0)
{
l9_11=-l9_9;
}
else
{
l9_11=l9_9;
}
vec2 l9_12=vec2(l9_10,l9_11);
vec2 l9_13=l9_8.xy+l9_12;
kernel=ceil(kernel);
kernel-=(vec2(1.0)-vec2(ivec2(kernel)%ivec2(2)));
kernel=clamp(kernel,vec2(0.0),vec2(255.0));
vec2 l9_14=kernel;
vec4 l9_15;
float l9_16;
l9_16=0.0001;
l9_15=vec4(0.0);
vec4 l9_17;
float l9_18;
int l9_19=0;
float l9_20;
float l9_21;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_19<int(max(kernel.x,kernel.y)))
{
ivec2 l9_22=p;
vec2 l9_23=kernel;
ivec2 l9_24=ivec2(l9_19);
ivec2 l9_25=(l9_22-ivec2(floor(l9_23*vec2(0.5))))+(l9_24*ivec2(clamp(l9_14,vec2(0.0),vec2(1.0))));
if (all(equal(texelFetch(z_rayDirections,l9_25,0).xy,vec2(0.0)))||(texelFetch(hitDistance,l9_25,0).x==0u))
{
l9_18=l9_16;
l9_17=l9_15;
l9_16=l9_18;
l9_15=l9_17;
l9_19++;
continue;
}
uvec4 l9_26=texelFetch(receivers1,l9_25,0);
vec2 l9_27=unpackHalf2x16(l9_26.x);
mediump float l9_28=l9_27.x;
vec2 l9_29=unpackHalf2x16(l9_26.y);
mediump float l9_30=l9_29.x;
float l9_31=(1.0-abs(l9_28))-abs(l9_30);
vec3 l9_32=vec3(l9_28,l9_30,l9_31);
float l9_33=max(-l9_31,0.0);
float l9_34;
if (l9_28>=0.0)
{
l9_34=-l9_33;
}
else
{
l9_34=l9_33;
}
float l9_35;
if (l9_30>=0.0)
{
l9_35=-l9_33;
}
else
{
l9_35=l9_33;
}
vec2 l9_36=vec2(l9_34,l9_35);
vec2 l9_37=l9_32.xy+l9_36;
float l9_38=length(((vec3(texelFetch(receivers0,l9_0,0).xyz)*OriginNormalizationScaleInv)+OriginNormalizationOffset)-((vec3(texelFetch(receivers0,l9_25,0).xyz)*OriginNormalizationScaleInv)+OriginNormalizationOffset));
float l9_39=clamp(dot(normalize(vec3(l9_13.x,l9_13.y,l9_8.z)),normalize(vec3(l9_37.x,l9_37.y,l9_32.z))),0.0,1.0);
float l9_40=coverageWS;
float l9_41=coverageWS;
float l9_42=pow(2.71828,((((-l9_38)*l9_38)*5.0)/(l9_40*l9_41))+(((l9_39-1.0)*(1.0-l9_39))*5.0));
float l9_43;
if (!stochastic_reflections)
{
l9_43=l9_42*sampleGauss(float(l9_19)/max(kernel.x,kernel.y));
}
else
{
l9_43=l9_42;
}
vec4 l9_44=clamp(texture(colorInput,(vec2(l9_25)+vec2(0.5))*colorInputSize.zw),vec4(0.0),vec4(10000.0));
float l9_45=l9_43*l9_44.w;
vec3 l9_46=l9_15.xyz+(l9_44.xyz*l9_45);
vec4 l9_47=vec4(l9_46.x,l9_46.y,l9_46.z,l9_15.w);
l9_47.w=l9_15.w+l9_45;
l9_18=l9_16+l9_43;
l9_17=l9_47;
l9_16=l9_18;
l9_15=l9_17;
l9_19++;
continue;
}
else
{
break;
}
}
vec4 l9_48=vec4(l9_16);
vec4 l9_49=l9_15/l9_48;
float l9_50=l9_49.w;
vec4 l9_51;
if (l9_50<0.01)
{
l9_51=vec4(0.0);
}
else
{
l9_51=vec4(l9_49.xyz/vec3(l9_50),l9_50);
}
return l9_51;
}
void fs_lray_glossy_filter()
{
ivec2 l9_0=ivec2(gl_FragCoord.xy);
bool l9_1;
if (stochasticEnabled)
{
l9_1=!((texelFetch(receivers0,l9_0,0).w&2047u)==0u);
}
else
{
l9_1=stochasticEnabled;
}
stochastic_reflections=l9_1;
if (!(!all(equal(texelFetch(receivers0,l9_0,0),uvec4(0u)))))
{
sc_FragData0=vec4(0.0);
return;
}
bool l9_2=stochastic_reflections;
vec2 l9_3=vec2(l9_0)+vec2(0.5);
vec2 l9_4=textureLod(searchParamResults,l9_3*searchParamResultsSize.zw,l9_2 ? 3.0 : 0.0).xy*255.0;
float l9_5=l9_4.x;
if (l9_5==0.0)
{
sc_FragData0=clamp(texture(colorInput,l9_3*colorInputSize.zw),vec4(0.0),vec4(10000.0));
}
else
{
sc_FragData0=gather(l9_0,kernel_mask*l9_5,l9_4.y+0.0001);
}
}
void main()
{
stochastic_reflections=false;
#if (lray_ProgramIndex==0)
{
sc_FragData0=vec4(0.0);
}
#else
{
#if (lray_ProgramIndex==1)
{
fs_lray_glossy_filter();
}
#else
{
#if (lray_ProgramIndex==2)
{
fs_lray_param_search();
}
#else
{
#if (lray_ProgramIndex==3)
{
fs_lray_resolve();
}
#else
{
uint l9_0;
l9_0=0u;
uint l9_1;
uint l9_2=0u;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_2<33u)
{
ivec2 l9_3=g9_7[l9_2];
uvec4 l9_4=texelFetch(hitDistance,ivec2(gl_FragCoord.xy)+l9_3,0);
uint l9_5=l9_4.x;
if (l9_5==0u)
{
l9_1=l9_0;
l9_0=l9_1;
l9_2++;
continue;
}
uint l9_6;
if ((float(l9_5)/distanceNormalizationScale)<=maxRayLen)
{
l9_6=l9_0+1u;
}
else
{
l9_6=l9_0;
}
l9_1=l9_6;
l9_0=l9_1;
l9_2++;
continue;
}
else
{
break;
}
}
sc_FragData0=mix(vec4(1.0,0.0,0.0,0.0),vec4(0.0),bvec4(l9_0<1u));
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
