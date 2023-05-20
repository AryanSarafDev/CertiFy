import 'package:async/async.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

Future<String> getFileSha256(String path) async {
  final reader = ChunkedStreamReader(File(path).openRead());
  const chunkSize = 4096;
  var output = AccumulatorSink<Digest>();
  var input = sha256.startChunkedConversion(output);

  try {
    while (true) {
      final chunk = await reader.readChunk(chunkSize);
      if (chunk.isEmpty) {
        // indicate end of file
        break;
      }
      input.add(chunk);
    }
  } catch (e) {
    print(e);
  } finally {
    // We always cancel the ChunkedStreamReader,
    // this ensures the underlying stream is cancelled.
    reader.cancel();
  }

  input.close();

  print(output.events.single.toString());
  return output.events.single.toString();
}
