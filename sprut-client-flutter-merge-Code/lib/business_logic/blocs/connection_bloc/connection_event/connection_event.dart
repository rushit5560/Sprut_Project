
import 'package:flutter/material.dart';

@immutable
abstract class ConnectedEvent {}

class OnConnectedEvent extends ConnectedEvent{}

class OnNotConnectedEvent extends ConnectedEvent{}
