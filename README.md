# Flutter Network Module

![Platform](https://img.shields.io/badge/platform-flutter-lightblue.svg)

A modular and abstracted network module for Flutter applications based on the Dio package. This module can be easily integrated into any Flutter project without requiring project-specific code changes.

**Last Updated:** 2025-05-15
**Author:** [@ahmet-ozberk](https://github.com/ahmet-ozberk)

## Features

- 🔄 Dio package-based HTTP client
- 📦 Modular architecture for easy integration
- 🔌 Plug-and-play implementation
- 🛡️ Comprehensive error handling
- 📊 Network state management (loading, success, error)
- 📝 Advanced logging system
- 🧩 Useful extensions for API requests
- 🔄 Automatic retry mechanism
- 🌐 Internet connectivity checks
- 🔒 Authentication interceptor support

## Table of Contents

- [Installation](#installation)
- [Setup](#setup)
- [Basic Usage](#basic-usage)
- [Advanced Usage](#advanced-usage)
- [Module Structure](#module-structure)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Installation

1. Add Network dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  #Local Integration
  network:
    path: modules/network
```

2. Import the package in your project:

```dart
import 'package:network/index.dart';
```

## Setup

Initialize the network module in your app's startup:

```dart
void main() {
  // Initialize Network Module
  NetworkModule.initialize(
    baseUrl: 'https://api.example.com/',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    tokenProvider: () => 'your-auth-token', // Optional
    logLevel: LogLevel.all, // Set logging level
    isLoggerEnable: kDebugMode,
  );
  
  runApp(MyApp());
}
```

## Basic Usage

### Making API Requests

```dart
final dio = NetworkModule.instance.dio;

// GET request
final response = await dio.safeGet<User>(
  '/users/1',
  converter: (data) => User.fromJson(data),
);

// POST request
final createResponse = await dio.safePost<User>(
  '/users',
  data: {'name': 'John Doe', 'email': 'john@example.com'},
  converter: (data) => User.fromJson(data),
);

// PUT request
final updateResponse = await dio.safePut<User>(
  '/users/1',
  data: {'name': 'John Updated'},
  converter: (data) => User.fromJson(data),
);

// DELETE request
final deleteResponse = await dio.safeDelete<bool>(
  '/users/1',
  converter: (data) => true,
);
```

### Handling Responses

```dart
final response = await dio.safeGet<User>('/users/1', converter: (data) => User.fromJson(data));

// Using when pattern
response.when(
  success: (user) {
    print('User name: ${user.name}');
  },
  error: (error) {
    print('Error: ${error.message}');
  },
);

// Or check the success flag
if (response.success) {
  final user = response.data;
  print('User: ${user?.name}');
} else {
  print('Error: ${response.error?.message}');
}

// Convert to NetworkState
final state = response.toNetworkState();
```

## Advanced Usage

### Creating Services

```dart
class UserService {
  final _dio = NetworkModule.instance.dio;
  
  Future<ResponseModel<List<User>>> getUsers() async {
    return await _dio.safeGet<List<User>>(
      '/users',
      converter: (data) {
        if (data is List) {
          return data.map((item) => User.fromJson(item)).toList();
        }
        return [];
      },
    );
  }
  
  Future<ResponseModel<User>> getUserById(int id) async {
    return await _dio.safeGet<User>(
      '/users/$id',
      converter: (data) => User.fromJson(data),
    );
  }
  
  // More methods...
}
```

### Using with State Management

```dart
class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  
  NetworkState<List<User>> _users = NetworkState.initial();
  NetworkState<List<User>> get users => _users;
  
  Future<void> fetchUsers() async {
    _users = NetworkState.loading();
    notifyListeners();
    
    final response = await _userService.getUsers();
    _users = response.toNetworkState();
    notifyListeners();
  }
  
  // More methods...
}
```

### Custom Interceptors

```dart
// Create a custom interceptor
class CustomHeaderInterceptor extends Interceptor {
  final Map<String, String> customHeaders;

  CustomHeaderInterceptor({required this.customHeaders});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(customHeaders);
    handler.next(options);
  }
}

// Add it to the network module
NetworkModule.instance.addInterceptor(
  CustomHeaderInterceptor(
    customHeaders: {
      'X-App-Version': '1.0.0',
      'X-Platform': 'Flutter',
    },
  ),
);
```

## Module Structure

```
lib/
  |- network/
      |- core/
          |- network_client.dart       # Main network client
          |- network_options.dart      # Network configuration options
          |- network_interceptors.dart # Standard interceptors
      |- error/
          |- network_error.dart        # Error definitions
          |- error_handler.dart        # Error handling mechanism
      |- models/
          |- response_model.dart       # Response model
          |- request_model.dart        # Request model
          |- network_state.dart        # Network state model
      |- log/
          |- network_logger.dart       # Logging mechanism
      |- extensions/
          |- dio_extensions.dart       # Extensions for Dio
          |- response_extensions.dart  # Extensions for Response
      |- utils/
          |- connectivity_checker.dart # Connection check helper
      |- network_module.dart           # Main exported module
  |- index.dart                        # Barrel export file
```

## Examples

### UI Integration Example

```dart
class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          final usersState = provider.users;
          
          if (usersState.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (usersState.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${usersState.error?.message}'),
                  ElevatedButton(
                    onPressed: () => provider.fetchUsers(),
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          if (usersState.isSuccess && usersState.data != null) {
            final users = usersState.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          }
          
          return Center(child: Text('No users found'));
        },
      ),
    );
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.