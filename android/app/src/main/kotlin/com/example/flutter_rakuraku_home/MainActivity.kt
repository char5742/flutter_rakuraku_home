package com.example.flutter_rakuraku_home

import android.util.Log
import android.content.pm.PackageManager
import kotlinx.coroutines.ExperimentalCoroutinesApi


import android.content.Intent;
import android.os.Bundle;
import android.provider.Settings
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.content.pm.LauncherApps;
import android.content.Context
import android.content.ContextWrapper
import android.content.IntentFilter

class MainActivity: FlutterActivity() {

  private val CHANNEL = "app.channel.shared.data";

  // private fun handleSendText(@NonNull intent: Intent) {
  //     this.sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
  // }

 override fun onCreate(@Nullable savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val intent = getIntent();
    val action = intent.getAction();
    val type = intent.getType();
     Log.d("MyActivity",action.toString());
     Log.d("MyActivity",type.toString());
     val launcherApps = applicationContext.getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
     if ("android.content.pm.action.CONFIRM_PIN_SHORTCUT".equals(action.toString())) {
      Log.i("MyActivity",launcherApps.getPinItemRequest(intent).accept().toString());
     }
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
    }
  }


}