// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:isolate';


/// Signature for getting notified when chunks of bytes are received while
/// consolidating the bytes of an [HttpClientResponse] into a [Uint8List].
///
/// The `cumulative` parameter will contain the total number of bytes received
/// thus far. If the response has been gzipped, this number will be the number
/// of compressed bytes that have been received _across the wire_.
///
/// The `total` parameter will contain the _expected_ total number of bytes to
/// be received across the wire (extracted from the value of the
/// `Content-Length` HTTP response header), or null if the size of the response
/// body is not known in advance (this is common for HTTP chunked transfer
/// encoding, which itself is common when a large amount of data is being
/// returned to the client and the total size of the response may not be known
/// until the request has been fully processed).
///
/// This is used in [consolidateHttpClientResponseBytes].
typedef BytesReceivedCallback = void Function(int cumulative, int total);

/// Efficiently converts the response body of an [HttpClientResponse] into a
/// [Uint8List].
///
/// The future returned will forward any error emitted by `response`.
///
/// The `onBytesReceived` callback, if specified, will be invoked for every
/// chunk of bytes that is received while consolidating the response bytes.
/// If the callback throws an error, processing of the response will halt, and
/// the returned future will complete with the error that was thrown by the
/// callback. For more information on how to interpret the parameters to the
/// callback, see the documentation on [BytesReceivedCallback].
///
/// If the `response` is gzipped and the `autoUncompress` parameter is true,
/// this will automatically un-compress the bytes in the returned list if it
/// hasn't already been done via [HttpClient.autoUncompress]. To get compressed
/// bytes from this method (assuming the response is sending compressed bytes),
/// set both [HttpClient.autoUncompress] to false and the `autoUncompress`
/// parameter to false.
// TODO(tvolkert): Remove the [client] param once https://github.com/dart-lang/sdk/issues/36971 is fixed.
Future<TransferableTypedData> consolidateHttpClientResponseBytes(
  HttpClientResponse response, {
  HttpClient client,
  bool autoUncompress = true,
  BytesReceivedCallback onBytesReceived,
}) {
  assert(autoUncompress != null);
  final Completer<TransferableTypedData> completer = Completer<TransferableTypedData>.sync();

  final _OutputBuffer output = _OutputBuffer();
  ByteConversionSink sink = output;
  int expectedContentLength = response.contentLength;
  if (expectedContentLength == -1)
    expectedContentLength = null;
  if (response.headers?.value(HttpHeaders.contentEncodingHeader) == 'gzip') {
    if (client?.autoUncompress ?? true) {
      // response.contentLength will not match our bytes stream, so we declare
      // that we don't know the expected content length.
      expectedContentLength = null;
    } else if (autoUncompress) {
      // We need to un-compress the bytes as they come in.
      sink = gzip.decoder.startChunkedConversion(output);
    }
  }

  int bytesReceived = 0;
  StreamSubscription<List<int>> subscription;
  subscription = response.listen((List<int> chunk) {
    sink.add(chunk);
    if (onBytesReceived != null) {
      bytesReceived += chunk.length;
      try {
        onBytesReceived(bytesReceived, expectedContentLength);
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
        subscription.cancel();
        return;
      }
    }
  }, onDone: () {
    sink.close();
    completer.complete(TransferableTypedData.fromList(output.chunks));
  }, onError: completer.completeError, cancelOnError: true);

  return completer.future;
}

class _OutputBuffer extends ByteConversionSinkBase {
  List<Uint8List> _chunks = <Uint8List>[];

  @override
  void add(List<int> chunk) {
    _chunks.add(chunk);
  }

  @override
  void close() {}

  List<Uint8List> get chunks => _chunks;
}
