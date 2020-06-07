# Isotope Google Auth Service

Extends the Isotope `AuthServiceAdapter` and provides a `GoogleAuthService` for authentication using the `GoogleAuthProvider` and `FirebaseAuth` backend service provider.

## Installation

Add the following dependencies to your `pubspec.yaml`:

```dart
dependences:
  isotope_auth:
    git: git://github.com/isotopeltd/isotope_auth.git
  isotope_auth_google:
    git: git://github.com/isotopeltd/isotope_auth_google.git
```

## Implementation

In your project, import the package:

```dart
import 'package:isotope_auth_google/isotope_auth_google';
```

Then instantiate a new `GoogleAuthService` object:

```dart
// authService constant is used in later examples:
const GoogleAuthService authService = new GoogleAuthService();
```

If you are using the `Isotope` framework, you'll likely be register the `GoogleAuthService` as a lazy singleton object using `registrar` service locator:

```dart
import 'package:isotope/registrar.dart';

void setup() {
  Registrar.instance.registerLazySingleton<GoogleAuthService>(GoogleAuthService());
}
```

See the [registrar documentation](https://github.com/IsotopeLtd/isotope/tree/master/lib/src/registrar) for information about registering, fetching, resetting and unregistering lazy singletons.

### Sign in

Signs in to `FirebaseAuth` using `GoogleSignIn` and `GoogleAuthProvider`.

Method signature:

```dart
Future<IsotopeIdentity> signIn()
```

The method will return an `IsotopeIdentity` object.

Example:

```dart
IsotopeIdentity identity = await authService.signIn({});
```

### Sign out

Signs out of `FirebaseAuth`.

Method signature:

```dart
Future<void> signOut()
```

Example:

```dart
await authService.signOut();
```

### Current identity

Returns an `IsotopeIdentity` object if the user is authenticated or `null` when not authenticated.

Method signature:

```dart
Future<IsotopeIdentity> currentIdentity()
```

Example:

```dart
IsotopeIdentity identity = authService.currentIdentity();
```

## License

This library is available as open source under the terms of the MIT License.

## Copyright

Copyright © 2020 Jurgen Jocubeit
