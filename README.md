# SomBook

Flutter mobile application for SomBook.

## Getting started

```bash
flutter pub get
flutter run
```

The default backend base URL is:

```text
https://sombook.mrk.so
```

Override it per environment without changing source code:

```bash
flutter run --dart-define=API_BASE_URL=https://staging.example.com
flutter build apk --dart-define=API_BASE_URL=https://sombook.mrk.so
```

## Backend integration

The shared backend foundation lives under `lib/core/`:

- `config/app_environment.dart`: base URL and request timeouts
- `api/api_client.dart`: reusable GET, POST, PUT, PATCH, and DELETE client
- `api/api_endpoints.dart`: central location for server-confirmed endpoint paths
- `api/auth_interceptor.dart`: adds a stored bearer token to requests
- `api/api_exception.dart`: converts Dio failures into app-friendly errors
- `storage/token_storage.dart`: securely stores access and refresh tokens
- `di/injection_container.dart`: registers shared services with GetIt

Use the client from a feature repository:

```dart
final apiClient = getIt<ApiClient>();
final response = await apiClient.get<Map<String, dynamic>>('/confirmed-path');
```

Only add paths to `ApiEndpoints` after they are confirmed by the backend API
contract. The current base URL serves the web admin panel and does not expose
OpenAPI or Swagger documentation at the common documentation paths.
