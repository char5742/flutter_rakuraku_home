package com.example.flutter_rakuraku_home

import android.content.Context
import android.content.pm.LauncherApps
import android.content.pm.ShortcutInfo
import android.os.Bundle
import android.os.Process
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

  private val CHANNEL = "app.channel.shortcut"

  override fun onCreate(@Nullable savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val launcherApps =
        applicationContext.getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
    val intent = getIntent()
    // 受け取ったintentがショートカット作成のものであるかどうか
    if ("android.content.pm.action.CONFIRM_PIN_SHORTCUT" == intent.getAction().toString()) {
      Log.i("MyActivity", launcherApps.getPinItemRequest(intent).shortcutInfo?.id.toString())
      Log.i("MyActivity", launcherApps.getPinItemRequest(intent).shortcutInfo?.`package`.toString())
      launcherApps.getPinItemRequest(intent).accept()
    }
  }
  private fun startShortcut(packageName: String, id: String) {
    val launcherApps =
        applicationContext.getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
    launcherApps.startShortcut(packageName, id, null, null, Process.myUserHandle())
  }

  private fun listShortcutsForPackage(packageName: String): List<ShortcutInfo> {
    val launcherApps =
        applicationContext.getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
    val query =
        LauncherApps.ShortcutQuery()
            .setQueryFlags(
                LauncherApps.ShortcutQuery.FLAG_MATCH_DYNAMIC or
                    LauncherApps.ShortcutQuery.FLAG_MATCH_MANIFEST or
                    LauncherApps.ShortcutQuery.FLAG_MATCH_PINNED
            )
            .setPackage(packageName)
    return launcherApps.getShortcuts(query, Process.myUserHandle()) ?: emptyList()
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        call,
        result ->
      when (call.method) {
        "startShortcut" -> {
          if (call.hasArgument("id") && call.hasArgument("packageName")) {
            val packageName = call.argument<String>("packageName")!!
            val id = call.argument<String>("id")!!
            result.success(startShortcut(packageName, id))
          }
        }
        "listShortcutsForPackage" -> {
          if (call.hasArgument("packageName")) {
            val packageName = call.argument<String>("packageName")!!
            result.success(listShortcutsForPackage(packageName).map { it.id })
          }
        }
        else -> {}
      }
    }
  }
}
