Shader "Lines"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"RenderType" = "Opaque"}
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float3 fancyGrad (float t){
                //reference https://iquilezles.org/articles/palettes/
                float3 a = float3(0.5,0.5,0.5);
                float3 b = float3(0.5,0.5,0.5);
                float3 c = float3(1.0,1.0,1.0);
                float3 d = float3(0.0,0.3,0.5);
                
                return a + b*cos(6.283185*(c*t+d));
            }
            v2f vert(appdata v)
            {
                v2f o;
                //v.vertex.y += sin(v.vertex.x + _Time*10.0);
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                //stretch out uv to form -1 to 1
                float2 uv = i.uv;
                uv = (uv-0.5)*2.0;
                //uv = frac(uv*1.5) - 0.5;
                float3 col = float3(0.0,0.0,0.0);
                col = fancyGrad(length(uv) + _Time*8.0);

                //use distance to calculate colour
                float d = 0.0;
                d = abs(sin((length(uv)*2.0)*16.0 +_Time*32.0)/16.0);
                if(d <= 0)
                    d = 0.1;
                //luminosity
                d = 0.01/d;

                col *= d;
                return float4(col,1.0);
                
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
