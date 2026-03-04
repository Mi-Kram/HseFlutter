import 'package:catotinder/src/domain/auth/auth_service.dart';
import 'package:catotinder/src/domain/data_manager.dart';
import 'package:catotinder/src/domain/shared_prefs_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catotinder/src/data/cat_service.dart';
import 'package:catotinder/src/presentation/onboarding/onboarding_screen.dart';
import 'package:catotinder/src/presentation/auth/auth_screen.dart';
import 'package:catotinder/src/presentation/app/tab_controller_widget.dart';

enum _RootState { loading, onboarding, auth, main }

class RootFlowWidget extends StatefulWidget {
  final CatService catService;
  final CatDataManager catDataManager;
  final BreedDataManager breedDataManager;
  final AuthService authService;
  final VoidCallback onToggleTheme;
  final bool isDark;

  const RootFlowWidget({
    super.key,
    required this.catService,
    required this.catDataManager,
    required this.breedDataManager,
    required this.authService,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<RootFlowWidget> createState() => _RootFlowWidgetState();
}

class _RootFlowWidgetState extends State<RootFlowWidget> {
  late final SharedPreferences _prefs;
  _RootState _state = _RootState.loading;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final onboardingDone =
        _prefs.getBool(SharedPrefsKeys.onboardingDone) ?? false;
    final apiKey = _prefs.getString(SharedPrefsKeys.authApiKey);

    if (apiKey != null) {
      widget.catService.client.options.headers['x-api-key'] = apiKey;
    }

    if (!mounted) return;

    if (!onboardingDone) {
      setState(() => _state = _RootState.onboarding);
    } else if (apiKey == null) {
      setState(() => _state = _RootState.auth);
    } else {
      setState(() => _state = _RootState.main);
    }
  }

  Future<void> _completeOnboarding() async {
    await _prefs.setBool(SharedPrefsKeys.onboardingDone, true);
    if (!mounted) return;
    setState(() => _state = _RootState.auth);
  }

  Future<void> _onAuthenticated(String apiKey) async {
    await _prefs.setString(SharedPrefsKeys.authApiKey, apiKey);
    widget.catService.client.options.headers['x-api-key'] = apiKey;
    if (!mounted) return;
    setState(() => _state = _RootState.main);
  }

  Future<void> _logout() async {
    await _prefs.remove(SharedPrefsKeys.likes);
    await _prefs.remove(SharedPrefsKeys.authApiKey);
    widget.catDataManager.queue.clear();
    widget.breedDataManager.list.clear();
    widget.catService.client.options.headers.remove('x-api-key');
    if (!mounted) return;
    setState(() => _state = _RootState.auth);
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _RootState.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case _RootState.onboarding:
        return OnboardingScreen(
          onFinished: _completeOnboarding,
          isDark: widget.isDark,
          onToggleTheme: widget.onToggleTheme,
        );
      case _RootState.auth:
        return AuthScreen(
          authService: widget.authService,
          onAuthenticated: _onAuthenticated,
          isDark: widget.isDark,
          onToggleTheme: widget.onToggleTheme,
        );
      case _RootState.main:
        return TabControllerWidget(
          catService: widget.catService,
          catDataManager: widget.catDataManager,
          breedDataManager: widget.breedDataManager,
          onToggleTheme: widget.onToggleTheme,
          isDark: widget.isDark,
          onLogout: _logout,
        );
    }
  }
}
