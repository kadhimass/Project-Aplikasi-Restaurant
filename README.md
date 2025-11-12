# APLIKASI_RESTORAN

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Google Maps (Web) setup

This project can use the Google Maps JavaScript API on the `Lokasi` page.
To use Maps in local web builds without committing API keys to source control,
follow these steps:

1. Copy `web/google_maps_key.example.js` to `web/google_maps_key.js`.
2. Edit `web/google_maps_key.js` and set your API key:

	```js
	// web/google_maps_key.js
	window.GOOGLE_MAPS_API_KEY = "YOUR_REAL_API_KEY";
	```

3. In Google Cloud Console:
	- Enable the *Maps JavaScript API* (and *Places API* if used).
	- Enable billing for the project that holds the API key.
	- Configure API key restrictions: allow the referrer `http://localhost:PORT` (use the port your app runs on), or `http://localhost/*` for convenience during development.

4. Run the app with `flutter run -d web-server` or `flutter run -d chrome` and open the web URL. The loader in `web/index.html` will dynamically load the Maps script using the local key file.

Security note: Do NOT commit `web/google_maps_key.js` — it is ignored by `.gitignore`.
