 #version 440 core

#include <flutter/runtime_effect.glsl>
precision highp float;
 
// varying vec3 fPosition;
// varying vec3 fNormal;
// varying vec3 rawX;
out vec4 fragColor;

const vec3  lightV1    = vec3(0.0,1.0,0.0); // stationary light
const float lightI     = 1.0;               // only for diffuse component
const float ambientC   = 0.15;
const float time = 2.0;
const vec2 resolution = vec2(1,1);
const float diffuseC   = 0.7;
const float specularC1 = 1.0;               // For stationary light
const float specularE1 = 64.0;
const float specularE2 = 16.0;
const vec3  lightCol   = vec3(1.0,1.0,1.0);
const vec3  objectCol  = vec3(1.0,0.6,0.0); // yellow-ish orange
const vec3  fPosition  = vec3(1.0,0.6,0.0); // yellow-ish orange
const vec3  fNormal  = vec3(1.0,0.6,0.0); // yellow-ish orange
const vec3  rawX  = vec3(1.0,0.6,0.0); // yellow-ish orange

vec2 blinnPhongDir(vec3 lightDir, float lightInt, float Ka, float Kd, float Ks, float shininess)

{
  vec3 s = normalize(lightDir);
  vec3 v = normalize(-fPosition);
  vec3 n = normalize(fNormal);
  vec3 h = normalize(v+s);
  float diffuse = Ka + Kd * lightInt * max(0.0, dot(n, s));
  float spec =  Ks * pow(max(0.0, dot(n,h)), shininess);
  return vec2(diffuse, spec);
}

void main()
{
  float angle      = 25.0*time;
  vec3 lightV2     = vec3(sin(angle),-0.5,cos(angle));
  float specularC2 = 0.7;  // For moving light -- make this zero to keep only stationary light

  vec3 ColorS1 = blinnPhongDir(lightV1,0.0   ,0.0,     0.0,     specularC1,specularE1).y*lightCol;
  vec3 ColorS2 = blinnPhongDir(lightV2,0.0   ,0.0,     0.0,     specularC2,specularE2).y*lightCol;
  vec3 ColorAD = blinnPhongDir(lightV1,lightI,ambientC,diffuseC,0.0      ,1.0       ).x*objectCol;
  fragColor = vec4(ColorAD+ColorS1+ColorS2,1.0);
  
}