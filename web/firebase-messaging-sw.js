console.log('Firebase Messaging Service Worker loaded');
importScripts('https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.11/firebase-messaging.js');

const firebaseConfig = {
  apiKey: "AIzaSyDcpJlVuqp9ZDUtjHN5YZ6STxKcxyg5JYE",
  authDomain: "gestion-de-tickets-ef5db.firebaseapp.com",
  projectId: "gestion-de-tickets-ef5db",
  storageBucket: "gestion-de-tickets-ef5db.appspot.com",
  messagingSenderId: "35922709972",
  appId: "1:35922709972:web:1ad6c4f89445b0052d1a41",
  measurementId: "G-68LN41FNPB"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('Message received. ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Ajout des écouteurs d'événements pour le Service Worker
self.addEventListener('install', function(event) {
  console.log('Service Worker installing.');
});

self.addEventListener('activate', function(event) {
  console.log('Service Worker activating.');
});

self.addEventListener('fetch', function(event) {
  console.log('Service Worker fetching:', event.request.url);
});
