Shader "Custom/BiColorShader"
{
    Properties
    {
        _ColorA("ColorA",Color) = (1,1,1,1)
        _ColorB("ColorB",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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

            fixed4 _ColorA;
            fixed4 _ColorB;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 texCoord = i.uv;
                texCoord -= float2(0.5,0.5);
                if(texCoord.x < 0.01) {
                    return _ColorA;
                    }
                else{
                    return _ColorB;
                }
            }
            ENDCG
        }
    }
}
