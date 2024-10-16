package com.example.hand_recognizer_camera

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.view.TextureRegistry
import io.flutter.view.TextureRegistry.TextureEntry


class HandRecognizerCameraPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    HandLandmarkerHelper.LandmarkerListener {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null

    private var textureRegistry: TextureRegistry? = null
    private var textureEntry: TextureEntry? = null
    private var cameraController: CameraController? = null
    private var handLandmarkerHelper: HandLandmarkerHelper? = null

    private var result:Result? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hand_recognizer_camera")
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
        textureRegistry = flutterPluginBinding.textureRegistry
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        this.result = result

        when (call.method) {
            "initializeCamera" -> {
                handLandmarkerHelper =
                    HandLandmarkerHelper(context, handLandmarkerHelperListener = this)
                cameraController =
                    CameraController(
                        context,
                        activity,
                        textureEntry,
                        textureRegistry,
                        handLandmarkerHelper!!
                    )

                cameraController!!.initializeCamera(result)
            }

            "startImageStream" -> {
                cameraController?.startImageStream(result)
            }

            "dispose" -> {
                cameraController?.dispose()
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onError(error: String, errorCode: Int) {
        Handler(Looper.getMainLooper()).post {
            result?.error(errorCode.toString(),error,null)
        }
    }

    override fun onResults(resultBundle: ResultBundle) {
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("onResultBundle", resultBundle.toMap())
        }
    }
}





