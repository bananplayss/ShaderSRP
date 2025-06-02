Shader "Custom/DissolveShader"
{
    Properties
    {
       _DissolveThreshold("Dissolve Threshold",Range(-0.1,1.1)) = 0.2
       _MainTex("Texture",2D) = "white" {}
       _Color("Color",Color) = (1,1,1,1)
       _FillColor("Fill Color",Color) = (1,1,1,1)
       _TransparentDissolve("Transparent Dissolve",Range(0,1)) = 0
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
           float _DissolveThreshold;
           fixed4 _Color;
           fixed4 _FillColor;
           bool _TransparentDissolve;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target 
            {
                _DissolveThreshold *= frac(_SinTime.y);
                float noiseValue = tex2D(_MainTex, i.uv).r;
                if(noiseValue < _DissolveThreshold/2+0.05){
                    
                    if(_TransparentDissolve < 0.5) {
                        discard;
                    }
                    else{
                        return _FillColor;
                    }
                }
                return _Color;

            }
            ENDCG
        }
    }
}
