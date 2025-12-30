import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:umgkh_mobile/models/base/custom_ui/menu_item.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/views/pages/crm/index.dart';
import 'package:umgkh_mobile/views/pages/supporthub/index.dart';
import 'package:umgkh_mobile/views/screens/attendance/index.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';

class MenuItemLocalStorageService {
  final Database _db;

  MenuItemLocalStorageService() : _db = LocalStorageService().db;

  Future<void> saveOrUpdateMenuItem(MenuItem item) async {
    await LocalStorageService().init(); // Ensure database is initialized

    // Check if the item already exists in the database
    List<Map<String, dynamic>> result = await _db.query(
      'menu_items',
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if (result.isEmpty) {
      // Item doesn't exist, save it
      await saveMenuItem(item);
    } else {
      // Item exists, update it
      await updateMenuItem(item);
    }
  }

  Future<void> saveMenuItem(MenuItem item) async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.insert(
      'menu_items',
      {
        'id': item.id,
        'label': item.label,
        'position': item.position,
        'icon': item.iconName,
        'route': item.routeName,
        'description': item.description,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMenuItem(MenuItem item) async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.update(
      'menu_items',
      {
        'label': item.label,
        'position': item.position,
        'icon': item.iconName,
        'route': item.routeName,
        'description': item.description
      },
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> updateMenuItemPosition(int id, int newPosition) async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.update(
      'menu_items',
      {'position': newPosition},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMenuItem(int id) async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.delete(
      'menu_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getMenuItems() async {
    await LocalStorageService().init(); // Ensure database is initialized
    var result = await _db.query('menu_items', orderBy: 'position ASC');
    return result; // Ensure result is not null; return an empty list if null
  }

  Future<void> initializeDefaultMenuItems() async {
    await LocalStorageService().init(); // Ensure database is initialized

    List<MenuItem> defaultItems = [
      MenuItem(
          id: 0,
          label: 'SupportHub',
          position: 0,
          iconName: 'supporthub',
          routeName: SupportHubPage.routeName,
          description:
              'Module for requesting ticket to ERP or ICT and more features.'),
      MenuItem(
          id: 1,
          label: 'Attendance',
          position: 1,
          iconName: 'attendance',
          routeName: AttendanceScreen.routeName,
          description:
              'Tracking attendance of employees being late or absence by check-in or check-out.'),
      MenuItem(
          id: 2,
          label: 'HR',
          position: 2,
          iconName: 'hr',
          routeName: '/hr',
          description:
              'Human Resource to manage employees such as take-leave or overtime.'),
      MenuItem(
          id: 3,
          label: 'CRM',
          position: 3,
          iconName: 'crm',
          routeName: CRMPage.routeName,
          description:
              'Customer Relationship Management is used to track leads, opportunities or activities.'),
      MenuItem(
          id: 4,
          label: 'Announcement',
          position: 4,
          iconName: 'announcement',
          routeName: '/announcement',
          description:
              'Company shared information about the construction of work and modules.'),
      MenuItem(
          id: 5,
          label: 'CMS',
          position: 5,
          iconName: 'cms',
          routeName: '/cms',
          description:
              'Cooperate Management System for do A4 and more features.'),
      MenuItem(
          id: 6,
          label: 'Service',
          position: 6,
          iconName: 'service',
          routeName: '/service',
          description:
              'Field Service and Workshop for schedule and track onsite operations, time and material.'),
      MenuItem(
          id: 7,
          label: 'AM',
          position: 7,
          iconName: 'am',
          routeName: '/am',
          description:
              'Assets Management is used to manage all the properties of company.'),
      MenuItem(
          id: 8,
          label: 'E-Catalog',
          position: 8,
          iconName: 'catalog',
          routeName: '/e-catalog',
          description:
              'Company shared information about products and display list as category and search.'),
      // MenuItem(
      //     id: 9,
      //     label: 'Map',
      //     position: 9,
      //     iconName: 'menu',
      //     routeName: '/menu10'),
    ];

    try {
      // Check existing items
      final existingItems = await getMenuItems();

      // Update existing items and save new items
      for (var item in defaultItems) {
        var existingItem = existingItems.firstWhere(
          (element) => element['id'] == item.id,
          orElse: () => <String, dynamic>{}, // Default to an empty map
        );

        // Check if existingItem is not null and is not an empty map
        if (existingItem.isNotEmpty) {
          // If item exists but needs updating (e.g., label, iconName, routeName changed)
          if (existingItem['label'] != item.label ||
              existingItem['icon'] != item.iconName ||
              existingItem['route'] != item.routeName ||
              existingItem['description'] != item.description) {
            await _db.update(
              'menu_items',
              {
                'label': item.label,
                'icon': item.iconName,
                'route': item.routeName,
                'description': item.description,
              },
              where: 'id = ?',
              whereArgs: [item.id],
            );
          }
        } else {
          // If item doesn't exist, insert it into the database
          await _db.insert(
            'menu_items',
            {
              'id': item.id,
              'label': item.label,
              'position': item.position,
              'icon': item.iconName,
              'route': item.routeName,
              'description': item.description,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
        debugPrint('Error initializing menu items: $e');
      
    }
  }

  // start ui type
  Future<void> saveMenuUiType(String type) async {
    await _db.delete('menu_ui_type');
    await LocalStorageService().init();
    await _db.insert('menu_ui_type', {'type': type},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await _db.query('menu_ui_type');
  }

  Future<String?> getMenuUiType() async {
    await LocalStorageService().init();
    final List<Map<String, dynamic>> maps = await _db.query('menu_ui_type');
    if (maps.isNotEmpty) {
      return maps.first['type'] as String?;
    }
    return null;
  }

  Future<void> initializeDefaultMenuType() async {
    await LocalStorageService().init();
    try {
      // Check existing items
      final existingItems = await getMenuUiType();
      if (existingItems != null) {
        await _db.update(
            'menu_ui_type',
            {
              'type': existingItems == grid ? grid : list,
            },
            where: 'id = ?',
            whereArgs: [0]);
      } else {
        await _db.insert(
            'menu_ui_type',
            {
              'type': grid,
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } catch (e) {
        debugPrint('Error initializing menu items: $e');
      
    }
  }
}
