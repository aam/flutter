// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:isolate';
//import 'dart:nativewrappers';
//import 'dart-ext:sample_extension';


//class TransferrableWrapper extends NativeFieldWrapperClass1 {
//  Uint8List create(int size) native "TransferrableWrapper_Create";
//  void release() native "TransferrableWrapper_Release";
//}


/// Efficiently converts the response body of an [HttpClientResponse] into a [Uint8List].
///
/// The future returned will forward all errors emitted by [response].
Future<Transferrable> consolidateHttpClientResponseBytes(HttpClientResponse response) {
  // response.contentLength is not trustworthy when GZIP is involved
  // or other cases where an intermediate transformer has been applied
  // to the stream.
  final Completer<Transferrable> completer = Completer<Transferrable>();
  final List<Uint8List> chunks = <Uint8List>[];
  response.listen((List<int> chunk) {
    chunks.add(chunk);
  }, onDone: () {
    completer.complete(Transferrable.fromList(chunks));
  }, onError: completer.completeError, cancelOnError: true);

  return completer.future;
}
