import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

/// Custom Bottom Navigation Bar with nested navigation and fade transitions
class CustomNavigationBar extends StatefulWidget {
  final List<NavItem> items;
  final List<Widget> pages;

  const CustomNavigationBar({
    super.key,
    required this.items,
    required this.pages,
  }) : assert(
         items.length == pages.length,
         'Items and pages must have same length',
       );

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with TickerProviderStateMixin {
  late final List<GlobalKey<NavigatorState>> _navigatorKeys;
  late final List<AnimationController> _fadeControllers;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  void _initializeNavigation() {
    final length = widget.items.length;

    _navigatorKeys = List.generate(length, (_) => GlobalKey<NavigatorState>());

    _fadeControllers = List.generate(length, (_) => _createFadeController());

    _fadeControllers[_currentIndex].value = 1.0;
  }

  AnimationController _createFadeController() {
    return AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _fadeControllers[_currentIndex].reverse();
      _currentIndex = index;
      _fadeControllers[_currentIndex].forward();
    });
  }

  @override
  void dispose() {
    for (final controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final navigator = _navigatorKeys[_currentIndex].currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(fit: StackFit.expand, children: _buildNavigationStack()),
        ),
        bottomNavigationBar: _buildNavigationBar(),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: SafeArea(
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              widget.items.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = widget.items[index];
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? darkBlueAccent.withAlpha(15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                color: isSelected ? darkBlueAccent : greyColor,
                size: 24,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  item.label,
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                    color: isSelected ? darkBlueAccent : greyColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationStack() {
    return List.generate(widget.items.length, (index) {
      return _buildTabView(index);
    });
  }

  Widget _buildTabView(int index) {
    final isSelected = index == _currentIndex;
    final controller = _fadeControllers[index];

    Widget child = _TabNavigator(
      navigatorKey: _navigatorKeys[index],
      child: widget.pages[index],
    );

    child = FadeTransition(
      opacity: controller.drive(CurveTween(curve: Curves.fastOutSlowIn)),
      child: child,
    );

    if (isSelected) {
      return Offstage(offstage: false, child: child);
    } else if (controller.isAnimating) {
      return IgnorePointer(child: child);
    } else {
      return Offstage(child: child);
    }
  }
}

/// Navigation Item Model
class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Tab Navigator wrapper for nested navigation
class _TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const _TabNavigator({required this.navigatorKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(settings: settings, builder: (_) => child);
      },
    );
  }
}
