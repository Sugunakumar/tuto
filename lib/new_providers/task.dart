import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum TaskStatus { NotStarted, InProgress, Completed }

class Task with ChangeNotifier {}
