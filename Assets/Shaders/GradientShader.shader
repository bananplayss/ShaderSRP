Shader "Custom/GradientShader"
{
    Properties
    {
       _ColorA ("ColorA",Color) = (1,1,1,1)
       _ColorB ("ColorB",Color) = (1,1,1,1)
       _IntensityA ("IntensityA",Range(0.1,1)) = 0.5
       _IntensityB ("IntensityB",Range(0.1,1)) = 0.5
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

            float4 _ColorA;
            float4 _ColorB;

            float _IntensityA;
            float _IntensityB;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float distfromcenter=distance(float2(0.5,0.5),i.uv);
                i.uv *=_IntensityA;
                float4 rColor = lerp(_ColorA * _IntensityA,_ColorB * _IntensityB,saturate(distfromcenter));
                return rColor;
            }
            ENDCG
        }
    }
}
