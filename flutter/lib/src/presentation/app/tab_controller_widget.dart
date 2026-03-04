import 'package:catotinder/src/domain/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:catotinder/src/data/cat_service.dart';
import 'package:catotinder/src/presentation/cats/cats_screen.dart';
import 'package:catotinder/src/presentation/breeds/breeds_screen.dart';

class TabControllerWidget extends StatefulWidget {
  final CatService _catService;
  final CatDataManager _catDataManager;
  final BreedDataManager _breedDataManager;
  final VoidCallback _onToggleTheme;
  final bool _isDark;
  final VoidCallback _onLogout;

  const TabControllerWidget({
    super.key,
    required CatService catService,
    required CatDataManager catDataManager,
    required BreedDataManager breedDataManager,
    required VoidCallback onToggleTheme,
    required bool isDark,
    required VoidCallback onLogout,
  }) : _catService = catService,
       _catDataManager = catDataManager,
       _breedDataManager = breedDataManager,
       _onToggleTheme = onToggleTheme,
       _isDark = isDark,
       _onLogout = onLogout;

  @override
  State<TabControllerWidget> createState() => TabControllerWidgetState();
}

class TabControllerWidgetState extends State<TabControllerWidget> {
  int _index = 0;
  late final List<Map<String, dynamic>> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      {
        'title': 'Кототиндер',
        'screen': CatsScreen(
          catService: widget._catService,
          dataManager: widget._catDataManager,
        ),
      },
      {
        'title': 'Породы',
        'screen': BreedsScreen(
          catService: widget._catService,
          dataManager: widget._breedDataManager,
        ),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tabs[_index]['title']),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
        actions: [
          IconButton(
            icon: Icon(widget._isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget._onToggleTheme,
            tooltip: 'Сменить тему',
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: widget._onLogout,
          ),
        ],
      ),
      body: tabs[_index]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Котики'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Породы'),
        ],
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
