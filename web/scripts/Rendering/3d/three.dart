@JS('THREE')
library three;

import "dart:html";
import "dart:js";
import "dart:typed_data";

import "package:js/js.dart";

export "three_extensions.dart";

@JS()
class Object3D {
	external Object3D();

	external void lookAt(Vector3 vector);
	external Object3D add(Object3D object);
	external Object3D remove(Object3D object);

	external Vector3 get position;
	external Vector3 get scale;
	external Euler get rotation;

	external Vector3 get up;

	external Object3D clone([bool recursive]);
}

@JS()
class Vector2 {
	external Vector2(num x, num y);
	factory Vector2.zero() {
		return new Vector2(0,0);
	}

	external num get x;
	external void set x(num x);

	external num get y;
	external void set y(num y);
}

@JS()
class Vector3 {
	external Vector3(num x, num y, num z);
	factory Vector3.zero() {
		return new Vector3(0,0,0);
	}

	external num get x;
	external void set x(num x);

	external num get y;
	external void set y(num y);

	external num get z;
	external void set z(num z);
}

@JS()
class Euler {
	external Euler(num x, num y, num z, [String order]);

	external void set(num x, num y, num z, [String order]);

	external num get x;
	external void set x(num x);

	external num get y;
	external void set y(num y);

	external num get z;
	external void set z(num z);
}

@JS()
class Face3 {
	external int get a;
	external void set a(int a);

	external int get b;
	external void set b(int b);

	external int get c;
	external void set c(int c);

	external Vector3 get normal;
	external void set normal(Vector3 normal);
}

@JS()
class Color {

}

// Renderer ################################################################

@JS()
class Scene extends Object3D {
	external Scene();
}

@JS()
class WebGLRenderer {
	external WebGLRenderer([WebGLRendererOptions parameters]);
	external CanvasElement get domElement;

	external bool get autoClear;
	external void set autoClear(bool value);

	external void setClearColor(num color, num alpha);
	external void render(Scene scene, Camera camera, [WebGLRenderTarget renderTarget, bool forceClear]);
	external void clear(bool color, bool depth, bool stencil);
	external void clearTarget(WebGLRenderTarget renderTarget, bool color, bool depth, bool stencil);

	external void setSize(int width, int height, [bool updateStyle]);
}

@anonymous
@JS()
class WebGLRendererOptions {
	external factory WebGLRendererOptions ({
		CanvasElement canvas,
		bool alpha : false,
		bool antialias : false
	});
}

// Camera ################################################################

@JS()
abstract class Camera extends Object3D {
	external Camera();
}

@JS()
class PerspectiveCamera extends Camera {
	external PerspectiveCamera( num fov, num aspect, num near, num far );
}

@JS()
class OrthographicCamera extends Camera {
	external OrthographicCamera( num left, num right, num top, num bottom, num near, num far );

	factory OrthographicCamera.flat(int width, int height) {
		return new OrthographicCamera(0, width, 0, height, 0.1, 1000.0);
	}

	external void updateProjectionMatrix();

	external num get left;
	external void set left(num val);
	external num get right;
	external void set right(num val);
	external num get top;
	external void set top(num val);
	external num get bottom;
	external void set bottom(num val);

}

// Lights  ################################################################

@JS()
abstract class Light extends Object3D {
	external num get color;
	external void set color(num val);

	external num get intensity;
	external void set intensity(num val);
}

@JS()
class DirectionalLight extends Light {
	external DirectionalLight([int color, double intensity]);
}

@JS()
class AmbientLight extends Light {
	external AmbientLight([int color, double intensity]);
}

// Geometry ################################################################

@anonymous
@JS()
abstract class AbstractGeometry {}

@JS()
abstract class Geometry implements AbstractGeometry {
	external JsArray<Vector3> get vertices;
	external JsArray<Face3> get faces;
	external JsArray get faceVertexUvs;

	external void set dynamic(bool flag);

	external void set verticesNeedUpdate(bool flag);
	external void set elementsNeedUpdate(bool flag);
	external void set uvsNeedUpdate(bool flag);
	external void set normalsNeedUpdate(bool flag);
	external void set colorsNeedUpdate(bool flag);
	external void set groupsNeedUpdate(bool flag);
	external void set lineDistancesNeedUpdate(bool flag);

	external void computeFaceNormals();
	external void computeVertexNormals([bool areaWeighted]);
	external void computeBoundingBox();
	external void computeBoundingSphere();

	external void dispose();
}

@JS()
class BufferGeometry implements AbstractGeometry {
	external void fromGeometry(Geometry source);

	external BufferGeometryAttributes get attributes;

	external void set verticesNeedUpdate(bool flag);
	external void set uvsNeedUpdate(bool flag);
	external void set normalsNeedUpdate(bool flag);
	external void set colorsNeedUpdate(bool flag);
	external void set groupsNeedUpdate(bool flag);
}

@anonymous
@JS()
class BufferGeometryAttributes {
	external BufferAttribute get position;
}

@JS()
class BufferAttribute {
	external Float32List get array;
	external int get itemSize;
	external int get count;
}

@JS()
class PlaneBufferGeometry extends BufferGeometry {
	external PlaneBufferGeometry(num width, num height, [num widthSegments, num heightSegments]);
}

@JS()
class SphereGeometry extends Geometry {
	external SphereGeometry( num radius, [num widthSegments, num heightSegments, num phiStart, num phiLength, num thetaStart, num thetaLength]);
}

@JS()
class PlaneGeometry extends Geometry {
	external PlaneGeometry(num width, num height, [num widthSegments, num heightSegments]);
}

// Textures ################################################################

@JS()
abstract class TextureBase {
	external void dispose();

	external num get minFilter;
	external void set minFilter(int val);
	external num get magFilter;
	external void set magFilter(int val);
	external num get wrapS;
	external void set wrapS(int val);
	external num get wrapT;
	external void set wrapT(int val);
	external num get format;
	external void set format(int val);
	external num get type;
	external void set type(int val);
	external num get anisotropy;
	external void set anisotropy(int val);
}

@JS()
class Texture extends TextureBase {
	external Texture(CanvasImageSource image, [int mapping, int wrapS, int wrapT, int magFilter, int minFilter, int format, int type, int anisotropy, int encoding]);

	external void set needsUpdate(bool flag);

	external CanvasImageSource get image;
	external void set image(CanvasImageSource img);

	external void set flipY(bool flag);
}

@JS()
class DataTexture extends TextureBase {
	external DataTexture(TypedData data, int width, int height, int format, int type, [int mapping, int wrapS, int wrapT, int magFilter, int minFilter, int anisotropy, int encoding]);

	external void set needsUpdate(bool flag);

	external DataTextureImage get image;
	external void set image(DataTextureImage img);

	external void set flipY(bool flag);
}

@anonymous
@JS()
class DataTextureImage {
	external TypedData get data;
	external int get width;
	external int get height;
}

@JS()
class WebGLRenderTarget extends TextureBase {
	external WebGLRenderTarget(int width, int height);

	external void setSize(int width, int height);
	external int get width;
	external int get height;

	external Texture get texture;
}

// Material ################################################################

@JS()
abstract class Material {
	external void dispose();

	external bool get transparent;
	external void set transparent(bool flag);
}

@JS()
class MeshBasicMaterial extends Material {
	external MeshBasicMaterial([MeshBasicMaterialProperties parameters]);
}

@anonymous
@JS()
class MeshBasicMaterialProperties {
	external factory MeshBasicMaterialProperties ({
		int color : 0xffffff,
		Texture map,
	});
}


@JS()
class MeshStandardMaterial extends Material {
	external MeshStandardMaterial([MeshStandardMaterialParameters parameters]);
}

@anonymous
@JS()
class MeshStandardMaterialParameters {
	external factory MeshStandardMaterialParameters ({
		num color : 0xffffff,
		num roughness : 0.5,
		num metalness : 0.5,
		Texture map,
		Texture lightmap,
		num lightMapIntensity : 1.0,
		Texture aoMap,
		num aoMapIntensity : 1.0,
		num emissive : 0x000000,
		Texture emissiveMap,
		num emissiveIntensity : 1.0,
		Texture bumpMap,
		num bumpMapScale : 1.0,
		Texture normalMap,
		// normalMapScale
		Texture displacementMap,
		num displacementScale : 1.0,
		num displacementBias : 0.0,
		Texture roughnessMap,
		Texture metalnessMap,
		Texture alphaMap,
		Texture envMap,
		num envMapIntensity : 1.0,
		num refractionRatio : 0.98,
		bool fog : true,
		num shading,
		bool wireframe : false,
		num wireframeLinewidth : 1.0,
		String wireframeLinecap : "round",
		String wireframeLinejoin : "round",
		num vertexColors,
		bool skinning : false,
		bool morphTargets : false,
		bool morphNormals : false
	});
}

@JS()
class ShaderMaterial extends Material {
	external ShaderMaterial([ShaderMaterialParameters parameters]);

	external JsObject get uniforms;
	external void set uniforms(JsObject uniforms);
}

@anonymous
@JS()
class ShaderMaterialParameters {
	external factory ShaderMaterialParameters({
		JsObject uniforms,
		String vertexShader,
		String fragmentShader
	});
}

@anonymous
@JS()
class ShaderUniform<T> {
	external factory ShaderUniform({T value});

	external T get value;
	external void set value(T value);
}

// Meshes ################################################################

@JS()
class Mesh extends Object3D {
	external Mesh(AbstractGeometry geometry, Material material);

	external Material get material;
	external void set material(Material material);
	external Geometry get geometry;
	external void set geometry(Geometry geometry);
}

// Controls ################################################################

@JS()
class OrbitControls {
	external OrbitControls(Object3D object, Element domElement);

	external bool update();

	external bool get enabled;
	external void set enabled(bool flag);

	external Vector3 get target;

	external void set enableDamping(bool flag);
	external void set dampingFactor(num val);
	external void set enableZoom(bool flag);
	external void set zoomSpeed(num val);
	external void set enableRotate(bool flag);
	external void set rotateSpeed(num val);
	external void set enablePan(bool flag);
	external void set keyPanSpeed(num val);
	external void set autoRotate(bool flag);
	external void set autoRotateSpeed(num val);
	external void set enableKeys(bool flag);
}

// Constants ################################################################

@JS() external num get REVISION;
@anonymous @JS() class MouseButtons {
	external int get LEFT;
	external int get MIDDLE;
	external int get RIGHT;
}
@JS() external MouseButtons get MOUSE;
@JS() external num get CullFaceNone;
@JS() external num get CullFaceBack;
@JS() external num get CullFaceFront;
@JS() external num get CullFaceFrontBack;
@JS() external num get FrontFaceDirectionCW;
@JS() external num get FrontFaceDirectionCCW;
@JS() external num get BasicShadowMap;
@JS() external num get PCFShadowMap;
@JS() external num get PCFSoftShadowMap;
@JS() external num get FrontSide;
@JS() external num get BackSide;
@JS() external num get DoubleSide;
@JS() external num get FlatShading;
@JS() external num get SmoothShading;
@JS() external num get NoColors;
@JS() external num get FaceColors;
@JS() external num get VertexColors;
@JS() external num get NoBlending;
@JS() external num get NormalBlending;
@JS() external num get AdditiveBlending;
@JS() external num get SubtractiveBlending;
@JS() external num get MultiplyBlending;
@JS() external num get CustomBlending;
@anonymous @JS() class BlendingModeEnum {
	external num get NoBlending;
	external num get NormalBlending;
	external num get AdditiveBlending;
	external num get SubtractiveBlending;
	external num get MultiplyBlending;
	external num get CustomBlending;
}
@JS() external BlendingModeEnum get BlendingMode;
@JS() external num get AddEquation;
@JS() external num get SubtractEquation;
@JS() external num get ReverseSubtractEquation;
@JS() external num get MinEquation;
@JS() external num get MaxEquation;
@JS() external num get ZeroFactor;
@JS() external num get OneFactor;
@JS() external num get SrcColorFactor;
@JS() external num get OneMinusSrcColorFactor;
@JS() external num get SrcAlphaFactor;
@JS() external num get OneMinusSrcAlphaFactor;
@JS() external num get DstAlphaFactor;
@JS() external num get OneMinusDstAlphaFactor;
@JS() external num get DstColorFactor;
@JS() external num get OneMinusDstColorFactor;
@JS() external num get SrcAlphaSaturateFactor;
@JS() external num get NeverDepth;
@JS() external num get AlwaysDepth;
@JS() external num get LessDepth;
@JS() external num get LessEqualDepth;
@JS() external num get EqualDepth;
@JS() external num get GreaterEqualDepth;
@JS() external num get GreaterDepth;
@JS() external num get NotEqualDepth;
@JS() external num get MultiplyOperation;
@JS() external num get MixOperation;
@JS() external num get AddOperation;
@JS() external num get NoToneMapping;
@JS() external num get LinearToneMapping;
@JS() external num get ReinhardToneMapping;
@JS() external num get Uncharted2ToneMapping;
@JS() external num get CineonToneMapping;
@JS() external num get UVMapping;
@JS() external num get CubeReflectionMapping;
@JS() external num get CubeRefractionMapping;
@JS() external num get EquirectangularReflectionMapping;
@JS() external num get EquirectangularRefractionMapping;
@JS() external num get SphericalReflectionMapping;
@JS() external num get CubeUVReflectionMapping;
@JS() external num get CubeUVRefractionMapping;
@anonymous @JS() class TextureMappingEnum {
	external num get UVMapping;
	external num get CubeReflectionMapping;
	external num get CubeRefractionMapping;
	external num get EquirectangularReflectionMapping;
	external num get EquirectangularRefractionMapping;
	external num get SphericalReflectionMapping;
	external num get CubeUVReflectionMapping;
	external num get CubeUVRefractionMapping;
}
@JS() external TextureMappingEnum get TextureMapping;
@JS() external num get RepeatWrapping;
@JS() external num get ClampToEdgeWrapping;
@JS() external num get MirroredRepeatWrapping;
@anonymous @JS() class TextureWrappingEnum {
	external num get RepeatWrapping;
	external num get ClampToEdgeWrapping;
	external num get MirroredRepeatWrapping;
}
@JS() external TextureMappingEnum get TextureWrapping;
@JS() external num get NearestFilter;
@JS() external num get NearestMipMapNearestFilter;
@JS() external num get NearestMipMapLinearFilter;
@JS() external num get LinearFilter;
@JS() external num get LinearMipMapNearestFilter;
@JS() external num get LinearMipMapLinearFilter;
@anonymous @JS() class TextureFilterEnum {
	external num get NearestFilter;
	external num get NearestMipMapNearestFilter;
	external num get NearestMipMapLinearFilter;
	external num get LinearFilter;
	external num get LinearMipMapNearestFilter;
	external num get LinearMipMapLinearFilter;
}
@JS() external TextureFilterEnum get TextureFilter;
@JS() external num get UnsignedByteType;
@JS() external num get ByteType;
@JS() external num get ShortType;
@JS() external num get UnsignedShortType;
@JS() external num get IntType;
@JS() external num get UnsignedIntType;
@JS() external num get FloatType;
@JS() external num get HalfFloatType;
@JS() external num get UnsignedShort4444Type;
@JS() external num get UnsignedShort5551Type;
@JS() external num get UnsignedShort565Type;
@JS() external num get UnsignedInt248Type;
@JS() external num get AlphaFormat;
@JS() external num get RGBFormat;
@JS() external num get RGBAFormat;
@JS() external num get LuminanceFormat;
@JS() external num get LuminanceAlphaFormat;
@JS() external num get RGBEFormat;
@JS() external num get DepthFormat;
@JS() external num get DepthStencilFormat;
@JS() external num get RGB_S3TC_DXT1_Format;
@JS() external num get RGBA_S3TC_DXT1_Format;
@JS() external num get RGBA_S3TC_DXT3_Format;
@JS() external num get RGBA_S3TC_DXT5_Format;
@JS() external num get RGB_PVRTC_4BPPV1_Format;
@JS() external num get RGB_PVRTC_2BPPV1_Format;
@JS() external num get RGBA_PVRTC_4BPPV1_Format;
@JS() external num get RGBA_PVRTC_2BPPV1_Format;
@JS() external num get RGB_ETC1_Format;
@JS() external num get LoopOnce;
@JS() external num get LoopRepeat;
@JS() external num get LoopPingPong;
@JS() external num get InterpolateDiscrete;
@JS() external num get InterpolateLinear;
@JS() external num get InterpolateSmooth;
@JS() external num get ZeroCurvatureEnding;
@JS() external num get ZeroSlopeEnding;
@JS() external num get WrapAroundEnding;
@JS() external num get TrianglesDrawMode;
@JS() external num get TriangleStripDrawMode;
@JS() external num get TriangleFanDrawMode;
@JS() external num get LinearEncoding;
@JS() external num get sRGBEncoding;
@JS() external num get GammaEncoding;
@JS() external num get RGBEEncoding;
@JS() external num get LogLuvEncoding;
@JS() external num get RGBM7Encoding;
@JS() external num get RGBM16Encoding;
@JS() external num get RGBDEncoding;
@JS() external num get BasicDepthPacking;
@JS() external num get RGBADepthPacking;