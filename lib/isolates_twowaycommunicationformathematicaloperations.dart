/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'dart:async';
import 'dart:isolate';

export 'src/isolates_twowaycommunicationformathematicaloperations_base.dart';

/*
Practice Question 2: Two-Way Communication for Mathematical Operations

Task:

Write a function mathOperationInIsolate that performs mathematical operations 
(addition, subtraction, multiplication, division) 
on two numbers in a separate isolate. 
The main isolate should send the numbers and the operation type, 
and the spawned isolate should return the result. 
Implement two-way communication to allow for dynamic operation requests.
 */

mathOperationInIsolate(int x, int y, String operator) async {
  final receiveFromWorker = ReceivePort();
  SendPort? sendToWorker;
  final completer = Completer();

  Isolate workerIsolate =
      await Isolate.spawn(calculatorWorkerIsolate, receiveFromWorker.sendPort);

  receiveFromWorker.listen((message) async {
    print("Message from worker: $message");
    if (message is SendPort) {
      sendToWorker = message;
      sendToWorker?.send([x, y, operator]);
    }

    if (message is num?) {
      completer.complete(message);
      receiveFromWorker.close();
      workerIsolate.kill();
    }
  });

  return completer.future;
}

void calculatorWorkerIsolate(SendPort sendToMain) {
  final receiveFromMain = ReceivePort();
  sendToMain.send(receiveFromMain.sendPort);

  receiveFromMain.listen((message) async {
    print("Message from main: $message");
    if (message is List) {
      sendToMain.send(calculation(message[0], message[1], message[2]));
    }
  });
}

num? calculation(int num1, int num2, String operation) {
  num? result;
  switch (operation) {
    case 'add':
      result = num1 + num2;
      break;
    case 'subtract':
      result = num1 - num2;
      break;
    case 'multiply':
      result = num1 * num2;
      break;
    case 'divide':
      if (num2 != 0) {
        result = num1 / num2;
      } else {
        result = null;
      }
      break;
    default:
      result = null;
  }

  return result;
}
