//
// ignore_for_file: diagnostic_describe_all_properties

import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'NavigationRail',
  type: NavigationRail,
  path: '[Theme Preview]/Navigation',
)
Widget navigationRail(BuildContext context) => const _NavigationRailExample();

class _NavigationRailExample extends StatefulWidget {
  const new();

  @override
  State<_NavigationRailExample> createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<_NavigationRailExample> {
  var _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  var _showLeading = false;
  var _showTrailing = false;
  double groupAlignment = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              groupAlignment: groupAlignment,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: labelType,
              leading: _showLeading
                  ? FloatingActionButton(
                      elevation: 0,
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      child: const Icon(Icons.add),
                    )
                  : const SizedBox(),
              trailing: _showTrailing
                  ? IconButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      icon: const Icon(Icons.more_horiz_rounded),
                    )
                  : const SizedBox(),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('First'),
                ),
                NavigationRailDestination(
                  icon: Badge(child: Icon(Icons.bookmark_border)),
                  selectedIcon: Badge(child: Icon(Icons.book)),
                  label: Text('Second'),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    label: Text('4'),
                    child: Icon(Icons.star_border),
                  ),
                  selectedIcon: Badge(
                    label: Text('4'),
                    child: Icon(Icons.star),
                  ),
                  label: Text('Third'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('selectedIndex: $_selectedIndex'),
                  const SizedBox(height: 20),
                  Text('Label type: ${labelType.name}'),
                  const SizedBox(height: 10),
                  OverflowBar(
                    spacing: 10,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            labelType = NavigationRailLabelType.none;
                          });
                        },
                        child: const Text('None'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            labelType = NavigationRailLabelType.selected;
                          });
                        },
                        child: const Text('Selected'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            labelType = NavigationRailLabelType.all;
                          });
                        },
                        child: const Text('All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Group alignment: $groupAlignment'),
                  const SizedBox(height: 10),
                  OverflowBar(
                    spacing: 10,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            groupAlignment = -1.0;
                          });
                        },
                        child: const Text('Top'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            groupAlignment = 0.0;
                          });
                        },
                        child: const Text('Center'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            groupAlignment = 1.0;
                          });
                        },
                        child: const Text('Bottom'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OverflowBar(
                    spacing: 10,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showLeading = !_showLeading;
                          });
                        },
                        child: Text(
                          _showLeading ? 'Hide Leading' : 'Show Leading',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showTrailing = !_showTrailing;
                          });
                        },
                        child: Text(
                          _showTrailing ? 'Hide Trailing' : 'Show Trailing',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
