import 'package:catotinder/src/domain/auth/auth_service.dart';
import 'package:catotinder/src/domain/data_manager.dart';
import 'package:catotinder/src/domain/shared_prefs_keys.dart';
import 'package:catotinder/src/presentation/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catotinder/src/data/cat_service.dart';
import 'package:catotinder/src/presentation/app/root_flow_widget.dart';

class AppWidget extends StatefulWidget {
  final CatService _catService;
  final CatDataManager _catDataManager;
  final BreedDataManager _breedDataManager;
  final AuthService _authService;

  const AppWidget({
    super.key,
    required CatService catService,
    required CatDataManager catDataManager,
    required BreedDataManager breedDataManager,
    required AuthService authService,
  }) : _catService = catService,
       _catDataManager = catDataManager,
       _breedDataManager = breedDataManager,
       _authService = authService;

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late final SharedPreferences _prefs;
  bool _isDark = false;
  bool _isSystemTheme = true;

  void _toggleTheme() {
    _isSystemTheme = false;
    setState(() {
      _isDark = !_isDark;
      _prefs.setBool(SharedPrefsKeys.isDark, _isDark);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    bool? stored = _prefs.getBool(SharedPrefsKeys.isDark);
    if (stored == null) return;

    _isSystemTheme = false;
    if (mounted) {
      setState(() => _isDark = stored);
    } else {
      _isDark = stored;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isSystemTheme) {
      return;
    }

    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (mounted) {
      setState(() => _isDark = isDark);
    } else {
      _isDark = isDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Кототиндер',
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      home: RootFlowWidget(
        catService: widget._catService,
        catDataManager: widget._catDataManager,
        breedDataManager: widget._breedDataManager,
        authService: widget._authService,
        onToggleTheme: _toggleTheme,
        isDark: _isDark,
      ),
    );
  }
}
