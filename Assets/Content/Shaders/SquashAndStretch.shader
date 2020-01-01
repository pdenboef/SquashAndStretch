// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SquashAndStretch"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Squash("Squash", Float) = 0
		_Radius("Radius", Float) = 1
		_SquashEffect("SquashEffect", Float) = 1
		_SquashCurve("SquashCurve", Float) = 0
		_StretchEffect("StretchEffect", Float) = 1
		_StretchCurve("StretchCurve", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Radius;
		uniform float _StretchCurve;
		uniform float _StretchEffect;
		uniform float _Squash;
		uniform float _SquashEffect;
		uniform float _SquashCurve;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 break49_g1 = ase_vertex3Pos;
			float xPos52_g1 = break49_g1.x;
			float yPos50_g1 = break49_g1.y;
			float Radius329 = _Radius;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float temp_output_22_0_g1 = ( 1.0 - ( ( sin( ( ( ( abs( yPos50_g1 ) / ( Radius329 / ase_objectScale.x ) ) * ( 0.5 * UNITY_PI ) ) - ( 0.5 * UNITY_PI ) ) ) + 1.0 ) / 2.0 ) );
			float StretchCurve333 = _StretchCurve;
			float StretchEffect332 = _StretchEffect;
			float Squash328 = _Squash;
			float SquashInput77_g1 = Squash328;
			float clampResult18_g1 = clamp( SquashInput77_g1 , -10.0 , 1.0 );
			float Squas23_g1 = clampResult18_g1;
			float lerpResult41_g1 = lerp( 1.0 , ( ( 1.0 - ( temp_output_22_0_g1 * StretchCurve333 ) ) * StretchEffect332 ) , ( atan( ( abs( Squas23_g1 ) * 2.0 ) ) / ( 0.5 * UNITY_PI ) ));
			float StretchMultiplierXZZ45_g1 = lerpResult41_g1;
			float SquashEffect330 = _SquashEffect;
			float SquashCurve331 = _SquashCurve;
			float lerpResult38_g1 = lerp( 0.0 , ( SquashEffect330 * ( 1.0 - ( SquashCurve331 * temp_output_22_0_g1 ) ) ) , Squas23_g1);
			float SquashMultiplierXZZ43_g1 = ( lerpResult38_g1 + 1.0 );
			float clampResult66_g1 = clamp( ( ( Squas23_g1 * 1000.0 ) + 0.5 ) , 0.0 , 1.0 );
			float lerpResult69_g1 = lerp( StretchMultiplierXZZ45_g1 , SquashMultiplierXZZ43_g1 , clampResult66_g1);
			float SquashMultiplierYY47_g1 = ( ( 1.0 - Squas23_g1 ) * yPos50_g1 );
			float zPos51_g1 = break49_g1.z;
			float3 appendResult75_g1 = (float3(( xPos52_g1 * lerpResult69_g1 ) , SquashMultiplierYY47_g1 , ( zPos51_g1 * lerpResult69_g1 )));
			v.vertex.xyz = appendResult75_g1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode173 = tex2D( _MainTex, uv_MainTex );
			o.Emission = tex2DNode173.rgb;
			o.Alpha = tex2DNode173.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
-1913;152.2;1906;1011;1780.59;-900.8679;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;154;-1623.435,2146.656;Float;False;Property;_StretchEffect;StretchEffect;5;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1626.63,1779.717;Float;False;Property;_Squash;Squash;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1627.613,1955.967;Float;False;Property;_SquashEffect;SquashEffect;3;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1622.342,1868.239;Float;False;Property;_Radius;Radius;2;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1624.789,2054.804;Float;False;Property;_SquashCurve;SquashCurve;4;0;Create;True;0;0;False;0;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1622.294,2236.43;Float;False;Property;_StretchCurve;StretchCurve;6;0;Create;True;0;0;False;0;0;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;332;-1319.506,2146.68;Float;False;StretchEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-1320.904,1868.881;Float;False;Radius;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;328;-1323.702,1780.28;Float;False;Squash;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;331;-1318.504,2054.479;Float;False;SquashCurve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;326;-1305.03,1619.703;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;-1318.906,2236.88;Float;False;StretchCurve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;330;-1319.702,1956.279;Float;False;SquashEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-1589.506,1254.253;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;175;-2143.509,1172.252;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;173;-972.077,1119.61;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;-1;cadb484151570cc409c732981288cd10;424405543882eb84e8a220fc4f7770f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-1859.508,1150.252;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;336;-886.8337,1760.4;Inherit;False;SquashAndStretch;-1;;1;f8d354f41350d51489ee32fd0240afc5;0;7;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MVMatrixNode;186;-2094.509,1085.253;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-1154.504,1151.252;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-1357.505,1150.252;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;183;-1641.506,1145.252;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;340;-490.6772,1298.696;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SquashAndStretch;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;332;0;154;0
WireConnection;329;0;14;0
WireConnection;328;0;5;0
WireConnection;331;0;42;0
WireConnection;333;0;87;0
WireConnection;330;0;61;0
WireConnection;185;0;186;0
WireConnection;185;1;175;0
WireConnection;336;1;326;0
WireConnection;336;2;328;0
WireConnection;336;4;329;0
WireConnection;336;5;330;0
WireConnection;336;3;331;0
WireConnection;336;6;332;0
WireConnection;336;7;333;0
WireConnection;182;0;177;0
WireConnection;182;1;178;0
WireConnection;177;0;183;0
WireConnection;177;1;178;0
WireConnection;183;0;185;0
WireConnection;340;2;173;0
WireConnection;340;9;173;4
WireConnection;340;11;336;0
ASEEND*/
//CHKSM=3010D6C98320618392377B95C52F0D2E7E8D688A