import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static bool _isRequestingPermissions = false;

  static Future<void> checkAndRequestPermissions(BuildContext context) async {
    final List<Permission> permissions = [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ];

    bool allGranted = true;
    for (Permission permission in permissions) {
      if (!(await permission.isGranted)) {
        allGranted = false;
        break;
      }
    }

    if (!allGranted) {
      if (context.mounted) {
        await requestPermissions(permissions, context);
      }
    }
  }

  static Future<void> requestPermissions(
    List<Permission> permissions,
    BuildContext context,
  ) async {
    // If a permission request is already in progress, return early
    if (_isRequestingPermissions) {
      return;
    }

    try {
      _isRequestingPermissions = true;

      bool showRationale = false;
      for (Permission permission in permissions) {
        final status = await permission.status;
        if (!status.isGranted && await permission.shouldShowRequestRationale) {
          showRationale = true;
          break;
        }
      }

      if (showRationale) {
        // Show rationale dialog explaining why permissions are required
        await showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder:
              (BuildContext context) => AlertDialog(
                title: const Text('Permissions Required'),
                content: const Text(
                  'Please grant the required permissions to continue.',
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _requestPermissions(permissions);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        await _requestPermissions(permissions);
      }
    } finally {
      _isRequestingPermissions = false;
    }
  }

  static Future<void> _requestPermissions(List<Permission> permissions) async {
    try {
      await permissions.request();
    } on Exception catch (e) {
      // Handle any exceptions that may occur during permission request
      if (kDebugMode) {
        print('Error requesting permissions: $e');
      }
      // You may choose to throw or handle this error further
    }
  }
}
