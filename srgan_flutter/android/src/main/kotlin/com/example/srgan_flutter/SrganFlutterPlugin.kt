package com.example.srgan_flutter

import android.app.Application
import android.content.Context
import android.graphics.BitmapFactory
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class SrganFlutterPlugin : FlutterPlugin, MethodCallHandler, SrganResultListener {


    private lateinit var channel: MethodChannel
    private var srganHelper: SrganHelper? = null
    private var context: Context? = null

    private var result:Result? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "srgan_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        this.result = result

        when (call.method) {
            "initializeEnhancer" -> {
                if (context == null) result.error("-1", "Context is null", null)
                srganHelper = SrganHelper(context = context!!, this)
                result.success(null)
            }

            "enhanceImage" -> {
                if (srganHelper == null) result.error("-1", "SrganHelper is null", null)

                val imageByteArg = call.arguments as ByteArray
                val convertedBitmap = ImageUtil.convertByteArrayToBitmap(imageByteArg)

                val kedi = context!!.resources.assets.open("kedi.png")


                srganHelper!!.enhanceImage(BitmapFactory.decodeStream(kedi))

            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onResultReady(srganResult: SrganResult) {
        if(result == null) return

        result!!.success(
            mapOf<String, Any?>(
                "imageData" to ImageUtil.convertBitmapToByteArray(
                    srganResult.output
                ),
                "inferenceTime" to srganResult.inferenceTime
            )
        )
    }
}
