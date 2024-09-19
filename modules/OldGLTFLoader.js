// Define the GLTFLoader within the THREE namespace if it doesn't already exist
THREE.GLTFLoader = THREE.GLTFLoader || function (manager) {
	this.manager = (manager !== undefined) ? manager : THREE.DefaultLoadingManager;
};

THREE.GLTFLoader.prototype = {
	constructor: THREE.GLTFLoader,

	load: function (url, onLoad, onProgress, onError) {
		var loader = new THREE.FileLoader(this.manager);
		loader.setResponseType('arraybuffer');
		loader.load(url, function (data) {
			try {
				var gltf = new THREE.GLTFLoader().parse(data);
				onLoad(gltf);
			} catch (error) {
				if (onError) {
					onError(error);
				} else {
					console.error('Error parsing GLTF file:', error);
				}
			}
		}, onProgress, onError);
	},

	parse: function (data) {
		var decoder = new TextDecoder('utf-8');
		var json = JSON.parse(decoder.decode(new Uint8Array(data, 0, data.length)));
		return json; 
	}
};

var containerId = 'model-container';
var modelUrl = 'path/to/model.gltf';

var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
var renderer = new THREE.WebGLRenderer();
document.getElementById(containerId).appendChild(renderer.domElement);

var loader = new THREE.GLTFLoader();
loader.load(modelUrl, function (gltf) {
	scene.add(gltf.scene);
	render();
}, undefined, function (error) {
	console.error('Failed to load the GLTF model:', error);
});

function render() {
	requestAnimationFrame(render);
	renderer.render(scene, camera);
}

camera.position.z = 5;