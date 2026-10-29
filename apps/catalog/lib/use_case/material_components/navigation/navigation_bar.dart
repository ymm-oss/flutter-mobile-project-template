import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

/// NavigationBar
/// https://api.flutter.dev/flutter/material/NavigationBar-class.html

@UseCase(
  name: 'NavigationBar',
  type: NavigationBar,
  path: '[Theme Preview]/Navigation',
)
Widget navigationBar(BuildContext context) => const _NavigationExample();

class _NavigationExample extends StatefulWidget {
  const new();

  @override
  State<_NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<_NavigationExample> {
  var _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Messages',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home page',
              ),
            ),
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Hello',
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Hi!',
                ),
              ),
            );
          },
        ),
      ][_currentPageIndex],
    );
  }
}
