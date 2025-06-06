Shader "Custom/BloomShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TintColor("TintColor",Color) = (1,1,1,1)
        _BloomIntensifier("Bloom Itensifier",Range(0,1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 2
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed3 _TintColor;
            float _BloomIntensifier;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

             fixed4 sampleColor(sampler2D tex, float2 uv){
                 return tex2D(tex,uv) - _BloomIntensifier;
             }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 a = sampleColor(_MainTex,i.uv + float2(-i.uv.x,0));
                fixed4 b = sampleColor(_MainTex,i.uv + float2(i.uv.x,0));
                fixed4 c = sampleColor(_MainTex,i.uv + float2(0,-i.uv.y));
                fixed4 d = sampleColor(_MainTex,i.uv + float2(0,i.uv.y));

                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 glowing_col = 0.8 * (a+b+c+d);

                fixed4 color = fixed4(col.rgb* _TintColor + glowing_col.rgb* _TintColor,col.a);
                return color;
            }
            ENDCG
        }
    }
}
