//Value Notifier - holds the data
//ValueListenableBuilder - listens to the changes in the data and rebuilds the widget(you don't need setState())

import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);
