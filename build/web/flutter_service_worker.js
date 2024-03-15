'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/maskable-512.png": "12c78ac19bba9318a0a7c9dea74d4d2b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/192.png": "0c079c44dac30aabe21cf6f616dec9fd",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/maskable-192.png": "0c079c44dac30aabe21cf6f616dec9fd",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/512.png": "12c78ac19bba9318a0a7c9dea74d4d2b",
"16x16.png": "5053161dcb70a2d1f6cf144f2a2ad0c4",
"index.html": "dd37b99836e21b8352f9e0b4c9aaf911",
"/": "dd37b99836e21b8352f9e0b4c9aaf911",
"main.dart.js": "033c75de6ad6a26da78a005658a2e514",
"web_rsnaturopaty.zip": "e5a8c2231d3725b31bcb67bfbf33ca7a",
"flutter.js": "b12cdd674701e8e0d3758e0f6465c1ce",
"version.json": "8cb4c14d3948da72aa7c349135ac1991",
"flutter_bootstrap.js": "8a93e61f4d557baf012d90981a9336c1",
"manifest.json": "060ddf3c4177a8d784c469b762e2f251",
"canvaskit/canvaskit.wasm": "93f4cb370ab8fc13c1daf9bdc845ae10",
"canvaskit/skwasm.wasm": "54457ee1d4e0d93c74a61927a410b350",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js.symbols": "4f1343131c76361b96b3df6f9bf9e438",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/chromium/canvaskit.js": "2f82009588e8a72043db753d360d488f",
"canvaskit/chromium/canvaskit.js.symbols": "fd69e210efad2b27314db9c65d6bd674",
"canvaskit/chromium/canvaskit.wasm": "99fe13761819ef60e73a6724921179bd",
"canvaskit/skwasm.js.symbols": "775fb9c3f20884a5a6d10333ee51d20a",
"canvaskit/canvaskit.js": "7737f5fc722b6a040ac15271ea8d92fb",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/FontManifest.json": "3c6f2aec284ba6e927fd5e00fb6c4257",
"assets/assets/loading.gif": "6cabf23e96bdff8dfc02abfd52381526",
"assets/assets/ic_setting.png": "0f21f3d4b891b52f00471325535ae999",
"assets/assets/loading2.gif": "4734d717053eef5838e0f22882bfbc2e",
"assets/assets/product/1/4.psychedelic.png": "4de5dbda4cd60ce4564f385fecc763c6",
"assets/assets/product/1/3.psychedelic.png": "f9b3a7e5c6915159a7a5f99c80ff91e9",
"assets/assets/product/1/2.psychedelic.png": "854d95a9f43c5c1c500b1af3e871880c",
"assets/assets/product/1/1.psychedelic.png": "a53a7574268e5dfd86282ff373e77ea6",
"assets/assets/product/psychedelic_grape.png": "860e0d6007ba7665b8d82eaf0abcc542",
"assets/assets/product/2/1.Beon.png": "efdb8d5fb8bfff4f2186eedab70b12ee",
"assets/assets/product/2/3.Beon.png": "f885d7c66443c10351ed1b446b139bc7",
"assets/assets/product/2/2.Beon.png": "2be320232c9124121ca0d15fb937c0b0",
"assets/assets/product/3/1.Botanic.png": "4d7548ceb5fa8e2b25d08bf3c8c2d30e",
"assets/assets/product/3/3.Botanic.png": "6e4a5c3ff5c906f7031c9578ad4c80ee",
"assets/assets/product/3/2.Botanic.png": "ee900424db6591550ff471f2a3e9a027",
"assets/assets/icons/ic_eye600.png": "8e92294be58a5a04774ef572f2979f2b",
"assets/assets/icons/ic_eye_slash.png": "d8f00b92a3f7864e4578f5303264c875",
"assets/assets/icons/reward.png": "422a975b60014099994be3a41c3dcd2d",
"assets/assets/icons/LogoRS'n.png": "d1bb46d14646c57faab1a78748b8ddff",
"assets/assets/ic_success.png": "9ddc8fc4eae29269c721e7e5f9fbed62",
"assets/assets/placeholder.png": "38dad255bc8679b9b78bc6a52b0f6169",
"assets/assets/ic_registration_success.png": "ae6e8a134947b7c7b6074e0ccaa6de98",
"assets/assets/images/Indonesia_map.png": "67bb9905f7370f8c4c7c21e22cf90b09",
"assets/assets/images/nophoto.jpg": "d7ccad647c7911ad08b68c79ab491447",
"assets/assets/images/Product.png": "b188cafb4d50580806d743cc321d8cb7",
"assets/assets/placeholder_tap.png": "7601198745a2c7dc8255bfaad7352ca9",
"assets/assets/nophoto.jpg": "d7ccad647c7911ad08b68c79ab491447",
"assets/fonts/MaterialIcons-Regular.otf": "7ad3a568b521efc938d138af066af941",
"assets/packages/progress_dialog_null_safe/assets/double_ring_loading_io.gif": "a03b96c4f7bef9fd9ed90eb516267a11",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "1fe4bafae853c8e4c2b0e43f5c6bcf96",
"assets/packages/iconsax/lib/assets/fonts/iconsax.ttf": "071d77779414a409552e0584dcbfd03d",
"assets/NOTICES": "6a562cb3d112a90d884b069f3828f905",
"assets/AssetManifest.json": "15741b9ffb54ed9a0df228e3138a35e9",
"assets/AssetManifest.bin": "040fec7b943c69ad00a285c1a7c21519",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "2299374c8d8d7371b472bd4393e29e8e"};
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
