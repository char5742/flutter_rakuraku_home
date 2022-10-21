package com.example.flutter_rakuraku_home

import android.util.Log
import android.os.Bundle
import android.os.Process
import androidx.annotation.NonNull
import androidx.annotation.Nullable

import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.content.pm.LauncherApps
import android.content.Context

class MainActivity: FlutterActivity() {

  private val CHANNEL = "app.channel.shortcut"
    
 override fun onCreate(@Nullable savedInstanceState: Bundle?) {
     super.onCreate(savedInstanceState)
     val launcherApps = applicationContext.getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
     val intent = getIntent()
     // 受け取ったintentがショートカット作成のものであるかどうか
     if ("android.content.pm.action.CONFIRM_PIN_SHORTCUT"==intent.getAction().toString()) {
         Log.i("MyActivity",launcherApps.getPinItemRequest(intent).shortcutInfo?.id.toString())
         Log.i("MyActivity",launcherApps.getPinItemRequest(intent).shortcutInfo?.`package`.toString())
         launcherApps.getPinItemRequest(intent).accept()
     }
  }
    private  fun startShortcut(packageName : String, id :String){
        val launcherApps = applicationContext.getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
        launcherApps.startShortcut(packageName,id,null,null,Process.myUserHandle())
    }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
          when(call.method){
              "startShortcut"->{
                  if (call.hasArgument("id") && call.hasArgument("packageName")){
                      val packageName=call.argument<String>("packageName")!!
                      val id=call.argument<String>("id")!!
                      result.success(startShortcut(packageName,id))
                  }
              }
              else->{}
          }
    }
  }


}