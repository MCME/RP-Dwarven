#version 150

in vec2 texCoord;

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;
uniform vec3 ViewerPosition; // Position of the viewer (camera)

out vec4 fragColor;

const float FOG_DENSITY = 0.05;
const vec3 FOG_COLOR = vec3(0.55, 0.55, 0.75);

void main() {
    // Sample depth from the depth map
    float depth = 1.0 - (1.0 - texture(DiffuseDepthSampler, texCoord).r) * FOG_DENSITY;
    
    // Calculate the distance from the viewer to the fragment
    float distance = length(ViewerPosition - vec3(texCoord, depth));
    
    // Calculate the fog factor based on the distance
    float fogFactor = smoothstep(0.0, 1.0, distance);
    
    // Sample the color from the texture
    vec4 texColor = texture(DiffuseSampler, texCoord);
    
    // Blend the texture color with the fog color based on fog factor
    vec3 finalColor = mix(texColor.rgb, FOG_COLOR, fogFactor);
    
    // Set the final color
    fragColor = vec4(finalColor, texColor.a);
}
