enum DataSourceMode {
  mock,
  remote;

  static DataSourceMode fromValue(String value) {
    return switch (value.toLowerCase()) {
      'remote' => DataSourceMode.remote,
      _ => DataSourceMode.mock,
    };
  }
}

class AppConfig {
  const AppConfig._();

  static const String defaultApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:30080',
  );

  static const DataSourceMode defaultDataSourceMode = DataSourceMode.mock;

  static final DataSourceMode configuredDataSourceMode =
      DataSourceMode.fromValue(
        const String.fromEnvironment('DATA_SOURCE_MODE', defaultValue: 'mock'),
      );
}
