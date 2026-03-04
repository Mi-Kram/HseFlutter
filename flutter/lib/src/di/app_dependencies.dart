import 'package:catotinder/src/data/analytics/log_auth_service.dart';
import 'package:catotinder/src/data/auth_service.dart';
import 'package:catotinder/src/data/custom_analytics_service.dart';
import 'package:catotinder/src/domain/analytics_service.dart';
import 'package:catotinder/src/domain/auth/auth_service.dart';
import 'package:catotinder/src/domain/data_manager.dart';
import 'package:dio_http/dio_http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:catotinder/src/data/cat_service.dart';

class AppDependencies {
  final Dio catsClient;
  final Dio authClient;
  final Dio analyticsClient;

  final AnalyticsService analyticsService;

  final CatService catService;
  final AuthService authService;

  final CatDataManager catDataManager;
  final BreedDataManager breedDataManager;

  const AppDependencies({
    required this.catsClient,
    required this.authClient,
    required this.analyticsClient,
    required this.catService,
    required this.authService,
    required this.analyticsService,
    required this.catDataManager,
    required this.breedDataManager,
  });

  factory AppDependencies.fromEnvEnvironment() {
    final Dio catsClient = Dio(
      BaseOptions(baseUrl: dotenv.get('CATS_ENDPOINT')),
    );

    final Dio authClient = Dio(
      BaseOptions(baseUrl: dotenv.get('SERVER_ENDPOINT')),
    );

    final Dio analyticsClient = Dio(
      BaseOptions(baseUrl: dotenv.get('ANALYTICS_ENDPOINT')),
    );

    final analyticsService = CustomAnalyticsService(client: analyticsClient);

    final catService = CatService(client: catsClient);
    final authService = LogAuthService(
      authService: CustomAuthService(client: authClient),
      analyticsService: analyticsService,
    );

    final catDataManager = CatDataManager();
    final breedDataManager = BreedDataManager();

    return AppDependencies(
      catsClient: catsClient,
      authClient: authClient,
      analyticsClient: analyticsClient,
      catService: catService,
      authService: authService,
      analyticsService: analyticsService,
      catDataManager: catDataManager,
      breedDataManager: breedDataManager,
    );
  }
}
