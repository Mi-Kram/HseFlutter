import 'package:catotinder/src/presentation/onboarding/widgets/onboarding_page.dart';
import 'package:catotinder/src/presentation/onboarding/widgets/page_indicator.dart';
import 'package:flutter/material.dart';

typedef OnboardingFinishedCallback = void Function();

/// Онбординг: несколько горизонтально пролистываемых шагов
/// с анимированным котиком и описанием основных фич.
class OnboardingScreen extends StatefulWidget {
  final OnboardingFinishedCallback onFinished;

  final VoidCallback _onToggleTheme;
  final bool _isDark;

  const OnboardingScreen({
    super.key,
    required this.onFinished,
    required bool isDark,
    required VoidCallback onToggleTheme,
  }) : _isDark = isDark,
       _onToggleTheme = onToggleTheme;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    (
      title: 'Свайпай котиков',
      description:
          'Лайкай понравившихся котиков свайпом вправо, дизлайкай свайпом влево.\n\nСовет: свайп вправо добавляет котика в избранное, а свайп влево помогает быстрее отфильтровать тех, кто не зашёл.',
      icon: Icons.pets,
    ),
    (
      title: 'Изучай породы',
      description:
          'Открывай детали породы, смотри описание и характеристики котиков.\n\nУзнай темперамент, размеры и особенности ухода, чтобы подобрать идеального пушистика под свой образ жизни.',
      icon: Icons.info_outline,
    ),
    (
      title: 'Удобная навигация',
      description:
          'Переключайся между котиками и списком пород с помощью нижних табов.\n\nИспользуй поиск и фильтры, чтобы быстро находить нужные карточки и возвращаться к любимым котикам.',
      icon: Icons.view_carousel,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage == _pages.length - 1) {
      widget.onFinished();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onPrev() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кототиндер'),
        actions: [
          IconButton(
            icon: Icon(widget._isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget._onToggleTheme,
            tooltip: 'Сменить тему',
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    title: page.title,
                    description: page.description,
                    iconData: page.icon,
                    pageIndex: index,
                    controller: _controller,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => PageIndicator(isActive: index == _currentPage),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onPrev,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Назад'),
                      ),
                    )
                  else
                    const SizedBox(width: 0),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Начать' : 'Далее',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
