#version 310 es
//SG_REFLECTION_BEGIN(100)
//attribute vec4 position 0
//output float outAo 1
//output vec4 outColor 0
//sampler sampler aoBufferTextureSmp 2:15
//sampler sampler colorInputSmp 2:17
//sampler sampler hitDistanceSmp 2:19
//sampler sampler receivers0Smp 2:21
//sampler sampler receivers1Smp 2:22
//sampler sampler searchParamResultsSmp 2:24
//sampler sampler z_rayDirectionsSmp 2:29
//texture texture2D aoBufferTexture 2:0:2:15
//texture texture2D colorInput 2:2:2:17
//texture utexture2D hitDistance 2:4:2:19
//texture utexture2D receivers0 2:6:2:21
//texture utexture2D receivers1 2:7:2:22
//texture texture2D searchParamResults 2:9:2:24
//texture texture2D z_rayDirections 2:14:2:29
//SG_REFLECTION_END
#if defined VERTEX_SHADER
uniform vec4 searchParamResultsSize;
uniform vec4 colorInputSize;
uniform vec3 cameraPosition;
uniform vec3 OriginNormalizationScale;
uniform vec3 OriginNormalizationScaleInv;
uniform vec3 OriginNormalizationOffset;
uniform float distanceNormalizationScale;
uniform bool stochasticEnabled;
uniform vec2 kernel_mask;
uniform float diMaxRayLen;
uniform float aoMaxRayLen;
uniform float diffuseIntensity;
in vec4 position;
void main()
{
gl_Position=vec4(position.xy,-1.0,1.0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
precision highp float;
precision highp int;
uniform vec4 searchParamResultsSize;
uniform vec4 colorInputSize;
uniform vec3 OriginNormalizationScaleInv;
uniform vec3 OriginNormalizationOffset;
uniform float distanceNormalizationScale;
uniform float diMaxRayLen;
uniform float aoMaxRayLen;
uniform float diffuseIntensity;
uniform vec2 kernel_mask;
uniform vec3 cameraPosition;
uniform vec3 OriginNormalizationScale;
uniform bool stochasticEnabled;
uniform highp sampler2D searchParamResults;
uniform highp usampler2D receivers0;
uniform highp usampler2D receivers1;
uniform highp sampler2D z_rayDirections;
uniform highp usampler2D hitDistance;
uniform highp sampler2D colorInput;
uniform highp sampler2D aoBufferTexture;
layout(location=1) out float outAo;
layout(location=0) out vec4 outColor;
void gather(ivec2 p,vec2 kernel,float coverageWS)
{
ivec2 l9_0=p;
vec3 l9_1=(vec3(texelFetch(receivers0,l9_0,0).xyz)*OriginNormalizationScaleInv)+OriginNormalizationOffset;
ivec2 l9_2=p;
uvec4 l9_3=texelFetch(receivers1,l9_2,0);
vec2 l9_4=unpackHalf2x16(l9_3.x);
mediump float l9_5=l9_4.x;
vec2 l9_6=unpackHalf2x16(l9_3.y);
mediump float l9_7=l9_6.x;
float l9_8=(1.0-abs(l9_5))-abs(l9_7);
vec3 l9_9=vec3(l9_5,l9_7,l9_8);
float l9_10=max(-l9_8,0.0);
float l9_11;
if (l9_5>=0.0)
{
l9_11=-l9_10;
}
else
{
l9_11=l9_10;
}
float l9_12;
if (l9_7>=0.0)
{
l9_12=-l9_10;
}
else
{
l9_12=l9_10;
}
vec2 l9_13=vec2(l9_11,l9_12);
vec2 l9_14=l9_9.xy+l9_13;
vec3 l9_15=normalize(vec3(l9_14.x,l9_14.y,l9_9.z));
kernel=ceil(kernel);
kernel-=(vec2(1.0)-vec2(ivec2(kernel)%ivec2(2)));
kernel=clamp(kernel,vec2(0.0),vec2(255.0));
vec2 l9_16=kernel;
vec4 l9_17;
float l9_18;
float l9_19;
float l9_20;
l9_20=0.0001;
l9_19=0.0;
l9_18=0.0001;
l9_17=vec4(0.0);
vec4 l9_21;
float l9_22;
float l9_23;
float l9_24;
int l9_25=0;
float l9_26;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_25<int(max(kernel.x,kernel.y)))
{
ivec2 l9_27=p;
vec2 l9_28=kernel;
ivec2 l9_29=ivec2(l9_25);
ivec2 l9_30=(l9_27-ivec2(floor(l9_28*vec2(0.5))))+(l9_29*ivec2(clamp(l9_16,vec2(0.0),vec2(1.0))));
vec4 l9_31=texelFetch(z_rayDirections,l9_30,0);
uvec4 l9_32=texelFetch(hitDistance,l9_30,0);
uint l9_33=l9_32.x;
if (all(equal(l9_31.xy,vec2(0.0)))||(l9_33==0u))
{
l9_24=l9_20;
l9_23=l9_19;
l9_22=l9_18;
l9_21=l9_17;
l9_20=l9_24;
l9_19=l9_23;
l9_18=l9_22;
l9_17=l9_21;
l9_25++;
continue;
}
vec3 l9_34=(vec3(texelFetch(receivers0,l9_30,0).xyz)*OriginNormalizationScaleInv)+OriginNormalizationOffset;
float l9_35=l9_31.x;
float l9_36=l9_31.y;
float l9_37=(1.0-abs(l9_35))-abs(l9_36);
vec3 l9_38=vec3(l9_35,l9_36,l9_37);
float l9_39=max(-l9_37,0.0);
float l9_40;
if (l9_35>=0.0)
{
l9_40=-l9_39;
}
else
{
l9_40=l9_39;
}
float l9_41;
if (l9_36>=0.0)
{
l9_41=-l9_39;
}
else
{
l9_41=l9_39;
}
vec2 l9_42=vec2(l9_40,l9_41);
vec2 l9_43=l9_38.xy+l9_42;
vec3 l9_44=(l9_34+(normalize(vec3(l9_43.x,l9_43.y,l9_38.z))*(float(l9_33)/distanceNormalizationScale)))-l9_1;
float l9_45=length(l9_44);
float l9_46=clamp(dot(l9_15,normalize(l9_44)),0.0,1.0);
uvec4 l9_47=texelFetch(receivers1,l9_30,0);
vec2 l9_48=unpackHalf2x16(l9_47.x);
mediump float l9_49=l9_48.x;
vec2 l9_50=unpackHalf2x16(l9_47.y);
mediump float l9_51=l9_50.x;
float l9_52=(1.0-abs(l9_49))-abs(l9_51);
vec3 l9_53=vec3(l9_49,l9_51,l9_52);
float l9_54=max(-l9_52,0.0);
float l9_55;
if (l9_49>=0.0)
{
l9_55=-l9_54;
}
else
{
l9_55=l9_54;
}
float l9_56;
if (l9_51>=0.0)
{
l9_56=-l9_54;
}
else
{
l9_56=l9_54;
}
vec2 l9_57=vec2(l9_55,l9_56);
vec2 l9_58=l9_53.xy+l9_57;
float l9_59=clamp(dot(l9_15,normalize(vec3(l9_58.x,l9_58.y,l9_53.z))),0.0,1.0);
vec4 l9_60=texture(colorInput,(vec2(l9_30)+vec2(0.5))*colorInputSize.zw);
vec4 l9_61=clamp(l9_60,vec4(0.0),vec4(10000.0));
float l9_62=length(l9_34-l9_1);
float l9_63;
float l9_64;
float l9_65;
vec4 l9_66;
if (kernel.x!=0.0)
{
l9_66=l9_61*sqrt(1.0-clamp(l9_45/diMaxRayLen,0.0,1.0));
l9_65=sqrt(1.0-clamp(l9_45/aoMaxRayLen,0.0,1.0));
l9_64=1.0-(l9_46*l9_59);
l9_63=1.0-l9_46;
}
else
{
float l9_67=1.0-l9_59;
l9_66=l9_61;
l9_65=texelFetch(aoBufferTexture,l9_30,0).x;
l9_64=l9_67;
l9_63=l9_67;
}
float l9_68=pow(2.71828,(clamp(l9_62/aoMaxRayLen,0.0,1.0)*(-2.0))-(l9_63*2.0));
float l9_69=pow(2.71828,(clamp(l9_62/diMaxRayLen,0.0,1.0)*(-2.0))-(l9_64*2.0));
float l9_70=l9_69*l9_66.w;
vec3 l9_71=l9_17.xyz+(l9_66.xyz*l9_70);
vec4 l9_72=vec4(l9_71.x,l9_71.y,l9_71.z,l9_17.w);
l9_72.w=l9_17.w+l9_70;
l9_24=l9_20+l9_68;
l9_23=l9_19+(l9_68*l9_65);
l9_22=l9_18+l9_69;
l9_21=l9_72;
l9_20=l9_24;
l9_19=l9_23;
l9_18=l9_22;
l9_17=l9_21;
l9_25++;
continue;
}
else
{
break;
}
}
vec4 l9_73=vec4(l9_18);
vec4 l9_74=l9_17/l9_73;
outAo=l9_19/l9_20;
if (kernel.x!=0.0)
{
outAo+=0.00392157;
}
float l9_75=l9_74.w;
vec4 l9_76;
if (l9_75<0.01)
{
l9_76=vec4(0.0);
}
else
{
l9_76=vec4(l9_74.xyz/vec3(l9_75),l9_75);
}
outColor=l9_76;
if (kernel.x==0.0)
{
outColor.w*=outColor.w;
}
if (outColor.w<=0.1)
{
}
else
{
float l9_77=(1.0-pow(10.0,1.0-diffuseIntensity))*0.111111;
outColor.w=pow(((1.0+l9_77)*outColor.w)-l9_77,1.0/diffuseIntensity);
}
}
void main()
{
ivec2 l9_0=ivec2(gl_FragCoord.xy);
if (textureLod(searchParamResults,(vec2(l9_0)+vec2(0.5))*searchParamResultsSize.zw,3.0).x==0.0)
{
outColor=vec4(0.0);
outAo=0.0;
}
else
{
gather(l9_0,kernel_mask*55.0,0.0);
}
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
