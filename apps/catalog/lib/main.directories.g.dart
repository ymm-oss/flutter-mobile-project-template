// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:catalog/use_case/internal_design_ui/components/list_tiles.dart'
    as _catalog_use_case_internal_design_ui_components_list_tiles;
import 'package:catalog/use_case/material_components/actions/common_buttons.dart'
    as _catalog_use_case_material_components_actions_common_buttons;
import 'package:catalog/use_case/material_components/actions/floating_action_button.dart'
    as _catalog_use_case_material_components_actions_floating_action_button;
import 'package:catalog/use_case/material_components/actions/icon_button.dart'
    as _catalog_use_case_material_components_actions_icon_button;
import 'package:catalog/use_case/material_components/actions/segmented_button.dart'
    as _catalog_use_case_material_components_actions_segmented_button;
import 'package:catalog/use_case/material_components/communication/badge.dart'
    as _catalog_use_case_material_components_communication_badge;
import 'package:catalog/use_case/material_components/communication/progress_indicator.dart'
    as _catalog_use_case_material_components_communication_progress_indicator;
import 'package:catalog/use_case/material_components/communication/snack_bar.dart'
    as _catalog_use_case_material_components_communication_snack_bar;
import 'package:catalog/use_case/material_components/containment/alert_dialog.dart'
    as _catalog_use_case_material_components_containment_alert_dialog;
import 'package:catalog/use_case/material_components/containment/bottom_sheet.dart'
    as _catalog_use_case_material_components_containment_bottom_sheet;
import 'package:catalog/use_case/material_components/containment/card.dart'
    as _catalog_use_case_material_components_containment_card;
import 'package:catalog/use_case/material_components/containment/divider.dart'
    as _catalog_use_case_material_components_containment_divider;
import 'package:catalog/use_case/material_components/containment/list_tile.dart'
    as _catalog_use_case_material_components_containment_list_tile;
import 'package:catalog/use_case/material_components/navigation/app_bar.dart'
    as _catalog_use_case_material_components_navigation_app_bar;
import 'package:catalog/use_case/material_components/navigation/bottom_app_bar.dart'
    as _catalog_use_case_material_components_navigation_bottom_app_bar;
import 'package:catalog/use_case/material_components/navigation/navigation_bar.dart'
    as _catalog_use_case_material_components_navigation_navigation_bar;
import 'package:catalog/use_case/material_components/navigation/navigation_drawer.dart'
    as _catalog_use_case_material_components_navigation_navigation_drawer;
import 'package:catalog/use_case/material_components/navigation/navigation_rail.dart'
    as _catalog_use_case_material_components_navigation_navigation_rail;
import 'package:catalog/use_case/material_components/navigation/tab_bar.dart'
    as _catalog_use_case_material_components_navigation_tab_bar;
import 'package:catalog/use_case/material_components/selection/check_box.dart'
    as _catalog_use_case_material_components_selection_check_box;
import 'package:catalog/use_case/material_components/selection/chip.dart'
    as _catalog_use_case_material_components_selection_chip;
import 'package:catalog/use_case/material_components/selection/date_picker.dart'
    as _catalog_use_case_material_components_selection_date_picker;
import 'package:catalog/use_case/material_components/selection/date_range_picker.dart'
    as _catalog_use_case_material_components_selection_date_range_picker;
import 'package:catalog/use_case/material_components/selection/menu.dart'
    as _catalog_use_case_material_components_selection_menu;
import 'package:catalog/use_case/material_components/selection/radio.dart'
    as _catalog_use_case_material_components_selection_radio;
import 'package:catalog/use_case/material_components/selection/slider.dart'
    as _catalog_use_case_material_components_selection_slider;
import 'package:catalog/use_case/material_components/selection/switch.dart'
    as _catalog_use_case_material_components_selection_switch;
import 'package:catalog/use_case/material_components/selection/time_picker.dart'
    as _catalog_use_case_material_components_selection_time_picker;
import 'package:catalog/use_case/material_components/style/color_scheme.dart'
    as _catalog_use_case_material_components_style_color_scheme;
import 'package:catalog/use_case/material_components/style/typography.dart'
    as _catalog_use_case_material_components_style_typography;
import 'package:catalog/use_case/material_components/text_inputs/text_field.dart'
    as _catalog_use_case_material_components_text_inputs_text_field;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Theme Preview',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'Actions',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'Common',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'ElevatedButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'ElevatedButton',
                    builder:
                        _catalog_use_case_material_components_actions_common_buttons
                            .elevatedButton,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'FilledButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _catalog_use_case_material_components_actions_common_buttons
                            .filledButton,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Tonal',
                    builder:
                        _catalog_use_case_material_components_actions_common_buttons
                            .filledTonalButton,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'OutlinedButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'OutlinedButton',
                    builder:
                        _catalog_use_case_material_components_actions_common_buttons
                            .outlinedButton,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'TextButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'TextButton',
                    builder:
                        _catalog_use_case_material_components_actions_common_buttons
                            .textButton,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'FloatingActionButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'FloatingActionButton',
                builder:
                    _catalog_use_case_material_components_actions_floating_action_button
                        .floatingActionButton,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'IconButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_actions_icon_button
                        .iconButton,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Filled',
                builder:
                    _catalog_use_case_material_components_actions_icon_button
                        .filledIconButton,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outlined',
                builder:
                    _catalog_use_case_material_components_actions_icon_button
                        .outlinedIconButton,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Tonal',
                builder:
                    _catalog_use_case_material_components_actions_icon_button
                        .filledTonalIconButton,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'SegmentedButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'SegmentedButton',
                builder:
                    _catalog_use_case_material_components_actions_segmented_button
                        .segmentedButton,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Communication',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'Badge',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Badge',
                builder:
                    _catalog_use_case_material_components_communication_badge
                        .badge,
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'ProgressIndicator',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'CircularProgressIndicator',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'CircularProgressIndicator',
                    builder:
                        _catalog_use_case_material_components_communication_progress_indicator
                            .circularProgressIndicator,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'CircularProgressIndicatorAdaptive',
                    builder:
                        _catalog_use_case_material_components_communication_progress_indicator
                            .circularProgressIndicatorAdaptive,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'LinearProgressIndicator',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'LinearProgressIndicator',
                    builder:
                        _catalog_use_case_material_components_communication_progress_indicator
                            .linearProgressIndicator,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'SnackBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'SnackBar',
                builder:
                    _catalog_use_case_material_components_communication_snack_bar
                        .snackBar,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Containment',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AlertDialog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Adaptive',
                builder:
                    _catalog_use_case_material_components_containment_alert_dialog
                        .adaptiveAlertDialog,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_containment_alert_dialog
                        .alertDialog,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'BottomSheet',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'BottomSheet',
                builder:
                    _catalog_use_case_material_components_containment_bottom_sheet
                        .bottomSheet,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'Card',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Elevated',
                builder: _catalog_use_case_material_components_containment_card
                    .elevatedCard,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Filled',
                builder: _catalog_use_case_material_components_containment_card
                    .filledCard,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outlined',
                builder: _catalog_use_case_material_components_containment_card
                    .outlinedCard,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'Divider',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_containment_divider
                        .divider,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Vertical',
                builder:
                    _catalog_use_case_material_components_containment_divider
                        .verticalDivider,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'ListTile',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_containment_list_tile
                        .defaultListTile,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Divider',
                builder:
                    _catalog_use_case_material_components_containment_list_tile
                        .separatedListTile,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Navigation',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_navigation_app_bar
                        .appBar,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'BottomAppBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'BottomAppBar',
                builder:
                    _catalog_use_case_material_components_navigation_bottom_app_bar
                        .bottomAppBar,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'NavigationBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'NavigationBar',
                builder:
                    _catalog_use_case_material_components_navigation_navigation_bar
                        .navigationBar,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'NavigationDrawer',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'NavigationDrawer',
                builder:
                    _catalog_use_case_material_components_navigation_navigation_drawer
                        .navigationDrawer,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'NavigationRail',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'NavigationRail',
                builder:
                    _catalog_use_case_material_components_navigation_navigation_rail
                        .navigationRail,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'TabBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'TabBar',
                builder:
                    _catalog_use_case_material_components_navigation_tab_bar
                        .tabBar,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Selection',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'Checkbox',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_selection_check_box
                        .checkbox,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'Chip',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Chip',
                builder:
                    _catalog_use_case_material_components_selection_chip.chip,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'DatePickerDialog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'DatePicker',
                builder:
                    _catalog_use_case_material_components_selection_date_picker
                        .datePicker,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'DateRangePickerDialog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'DateRangePicker',
                builder:
                    _catalog_use_case_material_components_selection_date_range_picker
                        .dateRangePicker,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'MenuAnchor',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Menu',
                builder:
                    _catalog_use_case_material_components_selection_menu.menu,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'Radio',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Radio',
                builder:
                    _catalog_use_case_material_components_selection_radio.radio,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'Slider',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Slider',
                builder: _catalog_use_case_material_components_selection_slider
                    .slider,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'Switch',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Adaptive',
                builder: _catalog_use_case_material_components_selection_switch
                    .adaptiveSwitch,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _catalog_use_case_material_components_selection_switch
                    .defaultSwitch,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'TimePickerDialog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'TimePicker',
                builder:
                    _catalog_use_case_material_components_selection_time_picker
                        .timePicker,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Style',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'ColorScheme',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_style_color_scheme
                        .buildThemeColorSchemeUseCase,
                designLink: 'https://m3.material.io/styles/color/overview',
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'TextTheme',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _catalog_use_case_material_components_style_typography
                    .buildThemeTypographyUseCase,
                designLink: 'https://m3.material.io/styles/typography/overview',
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'TextInputs',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'TextField',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _catalog_use_case_material_components_text_inputs_text_field
                        .textField,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outline',
                builder:
                    _catalog_use_case_material_components_text_inputs_text_field
                        .outlinedTextField,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'components',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'list_tiles',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'TextListTile',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'TextListTile',
                builder:
                    _catalog_use_case_internal_design_ui_components_list_tiles
                        .textListTile,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
