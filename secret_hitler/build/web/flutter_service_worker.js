'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "af4152876f48d2e3fd29a34f186ad363",
"index.html": "65c8e1e796982c9d84c4fc86299d318e",
"/": "65c8e1e796982c9d84c4fc86299d318e",
"main.dart.js": "59f9a4fd6cc5b6b0a36bb1f4820755c9",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon1.png": "5dcef449791fa27946b3d35ad8803796",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"ic_launcher.png": "82193994793aaca833ca7374d8800769",
"icons/favicon-16x16.png": "fe7bb1027c7bbc634d98d8f2d5707741",
"icons/Icon-maskable-5121.png": "301a7604d45b3e739efc881eb04896ea",
"icons/favicon.ico": "df5950d9f60390254bbee135676ba741",
"icons/apple-icon.png": "375e9315721b36dc0835514b053f4520",
"icons/apple-icon-144x144.png": "ea5dac9bbeccdbbdf4cdca8333fa9ce4",
"icons/android-icon-192x192.png": "5992cc89b304ed20775a510c90c9e15f",
"icons/apple-icon-precomposed.png": "49f7b741f06a709309138e2be8ffa311",
"icons/apple-icon-114x114.png": "720f9fbd578ddf218a5887be792421c1",
"icons/ms-icon-310x310.png": "72724050e8b599f6ff941f139349a49a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/ms-icon-144x144.png": "f4d8ad2f8ee69763c8e6f4f317cedf98",
"icons/Icon-5121.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/apple-icon-57x57.png": "bcf265f61791c27db6e58b9cef700124",
"icons/apple-icon-152x152.png": "e821bd641c442df1dc4b4f2aaa24576e",
"icons/ms-icon-150x150.png": "0d5b98327af01694f3f7999f4dbd6ecd",
"icons/android-icon-72x72.png": "f2e9dc48f8c855fe865ba000d22734d7",
"icons/android-icon-96x96.png": "37abef7b3a305777a93a4859b4c6ff73",
"icons/android-icon-36x36.png": "99433c6dfd52ddb5573c9c2bc34e37b6",
"icons/apple-icon-180x180.png": "f92903a6a0ee75e991efdbde13319b39",
"icons/Icon-maskable-1921.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/favicon-96x96.png": "c1c33f1bd8d75851b505704f216e51ce",
"icons/android-icon-48x48.png": "aff1a3e3b2fb31eaeb7b677225ed9316",
"icons/apple-icon-76x76.png": "1736954e28c9574bb1187dbc03cafda1",
"icons/apple-icon-60x60.png": "4e57ee808bfd3c3e18f2aba490780202",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/android-icon-144x144.png": "ea5dac9bbeccdbbdf4cdca8333fa9ce4",
"icons/apple-icon-72x72.png": "f2e9dc48f8c855fe865ba000d22734d7",
"icons/apple-icon-120x120.png": "e9bcff8c9c6166c1e19de9bb0fb6e4b7",
"icons/Icon-1921.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/favicon-32x32.png": "10abefbab9ebcdb51fdd1aa2f6a94117",
"icons/ms-icon-70x70.png": "df0de88fe4766696a5ae43e536dbd3d6",
"manifest.json": "3354723bcfe15cb226caefb4d91a9ec8",
"assets/AssetManifest.json": "afa13bef88b34b59071572ee53c1a378",
"assets/NOTICES": "7bc965813427b97cb0a9ad86d43db9d7",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "f7c3404c6a6ca98c64e9c95941b8e7ac",
"assets/fonts/MaterialIcons-Regular.otf": "01145b379d656a381e682271bac3e316",
"assets/assets/top-three.png": "76547d5ab97f5e37446254fac68f64b5",
"assets/assets/kill.png": "10a5c1fe40c4cdd55b5f294a79660833",
"assets/assets/next-persident.png": "f86358a5146d85550daaa73806a009cb",
"assets/assets/kill_veto.png": "2ba0b7ebcb6c58617e8e966245683d61",
"assets/assets/fash.png": "c91b8046132c811e4ca7dc91e91e6d59",
"assets/assets/box.gif": "086e26762d760625a33ed12577f1645f",
"assets/assets/Search.png": "62fc12ab087df1173bbd4055458542e3",
"assets/assets/logo.png": "be877b8d7512f425275c38bc898f26ae",
"assets/assets/lib.png": "03b7cc5bf6ff2090ed7ec4ab5dcbfd37",
"assets/assets/fash_policy.png": "2df9f10733553c30c813f990ef6649d2",
"assets/assets/lib_policy.png": "8b3338e0bd621f3929382579fd42c995",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
