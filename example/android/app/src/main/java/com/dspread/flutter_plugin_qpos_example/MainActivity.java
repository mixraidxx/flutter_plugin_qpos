package com.dspread.flutter_plugin_qpos_example;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new com.dspread.flutter_plugin_qpos.FlutterPluginQposPlugin(this));

//    GeneratedPluginRegistrant.registerWith(flutterEngine,this);
  }
}
