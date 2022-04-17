'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "faa98a0285e764e5d172ea375d78f00b",
"assets/assets/fonts/NunitoSans_Bold.ttf": "4aa57ec2fb7650165f1f2fef64d61b2e",
"assets/assets/fonts/NunitoSans_ExtraBold.ttf": "6d4e31b91a86fc3766f24db02fac9556",
"assets/assets/fonts/NunitoSans_Light.ttf": "b73b535f97c0f02d92a0648e8ebc10fa",
"assets/assets/fonts/NunitoSans_Regular.ttf": "05f376c99895ad997a49c579d385d589",
"assets/assets/fonts/NunitoSans_SemiBold.ttf": "6c7de16a9fe7eeb51fa02e3532c8c119",
"assets/assets/lottie/error.json": "cf8e2413902cde10664bf6b2d45bb1b1",
"assets/assets/lottie/loading.json": "93cc8a057a539413f28b64337958aff1",
"assets/assets/lottie/search_loading.json": "f1685fb2f72c6176f984055f86ba6605",
"assets/assets/lottie/trophy_loading.json": "86f44212a0a668cd1c632c85dc2df04a",
"assets/assets/lottie/verification_failure.json": "a1ad9a3cd88e61ad43d3db15bbfef0c3",
"assets/assets/lottie/verification_success.json": "28b03a5d19426c9d20e91c7525d64aed",
"assets/assets/rank_1.gif": "c6cd0f65c36478e2d0a4c4885cd359ab",
"assets/assets/rank_2.gif": "d0bb466b24ad1b9698dc86a549af2aff",
"assets/assets/rank_3.gif": "d41b37848ece7d23bbd946aedb4a87b1",
"assets/assets/sycon_logo.png": "344c98ce6cc5400f85d35d1bc34fa846",
"assets/FontManifest.json": "24883dc8507f5ecf5f05fd345d2a4343",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/NOTICES": "9a04e7e6172f29f289aa0252955ef7dc",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"favicon.ico": "8520495b235d86c95c31b3fe0e4fd8e3",
"icons/Icon-192.png": "49262cb4f6dc52ebb9ea4969d722907b",
"icons/Icon-512.png": "a629a8c6566197b4aab9cac68d7ff82d",
"icons/Icon-maskable-192.png": "9a493ced6baec3e141fb2ecf440580c2",
"icons/Icon-maskable-512.png": "3a792e05370da9ceb6255061c9227071",
"index.html": "4bdcb0c65e58bc71f7dcb77d57dc53f3",
"/": "4bdcb0c65e58bc71f7dcb77d57dc53f3",
"main.dart.js": "838bb4a4671898ffc7bc1027a1fa5ee4",
"manifest.json": "438bccbee3c4c2e1fef855f32aca2266",
"version.json": "6e587bcb8496916ec59abd6381536a99"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
