Shader "postEffectsShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Overlay" }
        LOD 100

        Pass // 0s
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
                float4 screenPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _DistortionTexture;
            float _DistortionIntensity;
            //sampler2D _GlobalRenderTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                //distort
                float4 distortionValue = (tex2D(_DistortionTexture, i.uv) *2) -1;
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv + (distortionValue * _DistortionIntensity));
                return col;
                //return distortionValue;
            }
            ENDCG
        }
    }
}
