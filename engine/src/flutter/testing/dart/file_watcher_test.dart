// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';

var eventsSeen = 0;

Future<void> main() async {
  test('file watching is working', () async {
    final temp = Directory.systemTemp.createTempSync('file_watcher_temp');
    final file = File('${temp.path}/file');
    try {
      startWatcher(temp);
      eventsSeen = 0;
      // Cause the watcher buffer to fill in a sync block.
      for (var i = 0; i < 200; ++i) {
        file.writeAsStringSync('$i');
      }
      // Allow async processing so the error has chance to happen.
      await Future.delayed(Duration(milliseconds: 100));
      expect(eventsSeen, greaterThan(0));
      await subscription.cancel();
    } finally {
      temp.deleteSync(recursive: true);
    }
  });
}

late StreamSubscription subscription;

void startWatcher(Directory temp) {
  subscription = temp.watch().listen(
    (e) {
      ++eventsSeen;
    },
    onError: (e) async {
      await subscription.cancel();
      startWatcher(temp);
    },
    onDone: () {
      fail('Not expecting DONE.');
    },
  );
}
