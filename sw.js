const CACHE_NAME = 'lupus-cache-v12';

// Lista di tutti i file da precacheare
const FILES_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',

  // Script principali
  './game.js',

  // Fogli di stile (se ne hai)
  './stile.css',

  // Icone
  './icon-192.png',
  './icon-512.png',

  // Altri file statici che usa la tua app
  './sw.js',

  // Se usi altre risorse (audio, immagini, ecc.) aggiungile qui, ad esempio:
  // './audio/click.mp3',
  // './img/background.png',

];

// Installa e cache i file
self.addEventListener('install', evt => {
  console.log('[SW] Install');
  evt.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(FILES_TO_CACHE))
  );
  self.skipWaiting(); // forza subito l'activation
});

// Attiva e elimina cache vecchi
self.addEventListener('activate', evt => {
  console.log('[SW] Activate');
  evt.waitUntil(
    caches.keys().then(keys =>
      Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            console.log('[SW] Removing old cache:', key);
            return caches.delete(key);
          }
        })
      )
    )
  );
  self.clients.claim();
});

// Serve i file dalla cache (o dalla rete se non ci sono)
self.addEventListener('fetch', evt => {
  evt.respondWith(
    caches.match(evt.request).then(res => {
      return res || fetch(evt.request);
    })
  );
});

// Ascolta messaggi come SKIP_WAITING per aggiornamenti
self.addEventListener('message', evt => {
  if (evt.data && evt.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});
