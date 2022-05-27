package com.example.second_attempt
import io.flutter.app.FlutterApplication
// import io.flutter.plugins.androidalarmmanager.AlarmService
// import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin


import io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin
import io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin
import io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin
import io.flutter.plugins.googlesignin.GoogleSignInPlugin

import io.flutter.plugins.GeneratedPluginRegistrant



class Application : FlutterApplication(), io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        // AlarmService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: io.flutter.plugin.common.PluginRegistry) {
        

        // AndroidAlarmManagerPlugin.registerWith(
        //         registry?.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));
        // FlutterFirebaseFirestorePlugin.registerWith(
        // registry?.registrarFor("io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin"));
        // FlutterFirebaseAuthPlugin.registerWith(
        // registry?.registrarFor("io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin"));
        // FlutterFirebaseCorePlugin.registerWith(
        // registry?.registrarFor("io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin"));
        // GoogleSignInPlugin.registerWith(
        // registry?.registrarFor("io.flutter.plugins.googlesignin.GoogleSignInPlugin"));
    }
    

    
}