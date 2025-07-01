'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "67330d0584687dcb369d21e55faa9518",
"assets/NOTICES": "43ece2455398f3132c738a9dded332e6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "d128558e2588c270a502aad8b39aea24",
"assets/AssetManifest.json": "c3dea75d7ff66b05d239b11e3b1852fa",
"assets/packages/time_picker_spinner_pop_up/assets/date.gif": "f29701d8ee373e849ae92c4786b63965",
"assets/packages/time_picker_spinner_pop_up/assets/date_time.gif": "c07b4a0761173d4c0812c1c3f53d6477",
"assets/packages/time_picker_spinner_pop_up/assets/ic_clock.png": "74d0853f80d6d040596a5fc72170dba3",
"assets/packages/time_picker_spinner_pop_up/assets/ic_calendar.png": "aa1212ec5e0453b1891adaa2a46ee760",
"assets/packages/time_picker_spinner_pop_up/assets/time.gif": "c28311e9196b3eea656d546b1cef8d27",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/AssetManifest.bin.json": "380c940fe77d7938b79845d908be0eb1",
"assets/FontManifest.json": "17768dd2484afdb814a4750cca55a1d6",
"assets/ass/sleep.svg": "2222131c243e2a448f73a63984f908fe",
"assets/ass/Neol.png": "74ea6e2e8f1cbece80d08bc692a12e4f",
"assets/ass/power.svg": "a226aa93043a647c2d59633bd5a2367c",
"assets/ass/signin.jpg": "322cc2dfc618a1edb2d092bb9967aa26",
"assets/ass/Bolt.svg": "3104fa89ae603c5f762baf83ef11ca6a",
"assets/ass/icon.png": "ece96071c1ba63400ea4bde1977ebbbb",
"assets/ass/colorp.svg": "faea079cbef19e5d37a0b924bc2f09f6",
"assets/ass/home.svg": "1e618fcd2fe33c71d03c681aab507d31",
"assets/ass/logo.png": "459cae727a686cba3627db925def6ce3",
"assets/ass/timernav.svg": "7cd4cbb2cfb7e74538b5694b8c3dea5a",
"assets/ass/themes/fish.png": "dc44f5706bb538cca75619d89ac446bc",
"assets/ass/themes/rainbow.png": "1196cc90dd9d8315c6269532e4f416c3",
"assets/ass/themes/circle.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/circle2.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/dance.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/party.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/sea.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/police.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/run.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/static.png": "b183e16cd8f12b935b6a1bb596bb9327",
"assets/ass/themes/fade.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/blink.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/themes/paint.png": "f50be227939c528b73b048ecc44b7668",
"assets/ass/netwana.svg": "2470905d6aa1c6629e8d88fc6a925a1c",
"assets/ass/sun.svg": "a023cec52ba30464b6da5cdf6e6ea3f5",
"assets/ass/lamp.svg": "32416fc8f9a224693efdd0f668720fc1",
"assets/ass/effect.svg": "ceca01a77de8432d8be40ff82f41e384",
"assets/ass/timer.svg": "bc63402236aee6cfdb798fffd099298c",
"assets/fonts/est/Estedad-Regular.ttf": "381bf1cf1f550c6e19a074ad80261717",
"assets/fonts/est/Estedad-SemiBold.ttf": "63492544fa9b1e29f2b43f0fd9d51da2",
"assets/fonts/est/Estedad-Bold.ttf": "73f179dc36128fa8d3360ff1b5792795",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/fonts/abr/AbarLow-Black.ttf": "447b557d825f4daa02256d9741deb5ba",
"assets/fonts/abr/AbarLow-ExtraBold.ttf": "9b9e2c47c27000806c7e83f1ce3a78c0",
"manifest.json": "beaf5b40a6fc06de38818c678e62ef20",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"index.html": "2f9e820ecd8dd966aca939446fe30fb9",
"/": "2f9e820ecd8dd966aca939446fe30fb9",
"main.dart.js": "b3585d68aaf0aacb23694d4fd864720e",
"version.json": "a7b8f27619e516af68695d559337b85e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
