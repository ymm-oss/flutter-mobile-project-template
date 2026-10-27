import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

class _BottomAppBarDemo extends StatefulWidget {
  const new();

  @override
  State createState() => _BottomAppBarDemoState();
}

class _BottomAppBarDemoState extends State<_BottomAppBarDemo> {
  static const colors = <Color>[
    Colors.yellow,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.cyan,
  ];

  static final List<Widget> items = List<Widget>.generate(
    colors.length,
    (index) => Container(color: colors[index], height: 150),
  ).reversed.toList();

  late ScrollController _controller;
  var _showFab = true;
  var _isElevated = true;
  var _isVisible = true;

  FloatingActionButtonLocation get _fabLocation => _isVisible
      ? FloatingActionButtonLocation.endContained
      : FloatingActionButtonLocation.endFloat;

  void _listen() {
    switch (_controller.position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        _show();
      case ScrollDirection.reverse:
        _hide();
    }
  }

  void _show() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  void _hide() {
    if (_isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _onShowFabChanged(bool value) {
    setState(() {
      _showFab = value;
    });
  }

  void _onElevatedChanged(bool value) {
    setState(() {
      _isElevated = value;
    });
  }

  void _addNewItem() {
    setState(() {
      items.insert(
        0,
        Container(color: colors[items.length % 5], height: 150),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_listen);
  }

  @override
  void dispose() {
    _controller.removeListener(_listen);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom App Bar Demo'),
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Floating Action Button'),
            value: _showFab,
            onChanged: _onShowFabChanged,
          ),
          SwitchListTile(
            title: const Text('Bottom App Bar Elevation'),
            value: _isElevated,
            onChanged: _onElevatedChanged,
          ),
          Expanded(
            child: ListView(
              controller: _controller,
              children: items.toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: _addNewItem,
              tooltip: 'Add New Item',
              elevation: _isVisible ? 0.0 : null,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: _fabLocation,
      bottomNavigationBar: _DemoBottomAppBar(
        isElevated: _isElevated,
        isVisible: _isVisible,
      ),
    );
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  const new({
    required this.isElevated,
    required this.isVisible,
  });

  final bool isElevated;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isVisible ? 80.0 : 0,
      child: BottomAppBar(
        elevation: isElevated ? null : 0.0,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open popup menu',
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                final snackBar = SnackBar(
                  content: const Text('Yay! A SnackBar!'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                  ),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isElevated', isElevated));
    properties.add(DiagnosticsProperty<bool>('isVisible', isVisible));
  }
}

/// BottomAppBar
/// https://api.flutter.dev/flutter/material/BottomAppBar-class.html

@UseCase(
  name: 'BottomAppBar',
  type: BottomAppBar,
  path: '[Theme Preview]/Navigation',
)
Widget bottomAppBar(BuildContext context) => const _BottomAppBarDemo();
