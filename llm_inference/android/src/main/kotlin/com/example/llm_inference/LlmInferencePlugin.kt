package com.example.llm_inference

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import com.google.mediapipe.tasks.genai.llminference.LlmInference.LlmInferenceOptions

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class LlmInferencePlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventSink? = null
    private var llmInferenceHelper: LlmInferenceHelper? = null
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "llm_inference/method")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "llm_inference/event")
        eventChannel.setStreamHandler(this)

        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                llmInferenceHelper = LlmInferenceHelper(context = context)
                llmInferenceHelper!!.createInterpreter(result, eventSink = eventSink)
            }

            "run" -> {
                if (llmInferenceHelper == null) return

                val promptArg = call.arguments as String
                llmInferenceHelper!!.run(prompt = promptArg, result = result)
            }

            "close" -> {
                llmInferenceHelper?.close()
                llmInferenceHelper = null
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}

class LlmInferenceHelper(private val context: Context) {

    private var llmInference: LlmInference? = null
    private var runJob: Job? = null


    fun createInterpreter(result: Result, eventSink: EventSink?) {
        if (llmInference != null) return


        try {
            val options = LlmInferenceOptions.builder()
                .setModelPath(MODEL_PATH)
                .setMaxTokens(1000)
                .setMaxTopK(40)
                .setResultListener { partialResult, done ->
                    Handler(Looper.getMainLooper()).post {
                        eventSink?.success(
                            mapOf(
                                "partialResult" to partialResult,
                                "done" to done,
                            )
                        )
                    }
                }
                .build()

            llmInference = LlmInference.createFromOptions(context, options)

            result.success(null)

        } catch (e: Exception) {

            result.error("-1", "Error during model initialization", null)

        }

    }

    fun run(prompt: String, result: Result) {
        if (llmInference == null) {
            result.error("-1", "LlmInference object is null", null)
            return
        }

        runJob = CoroutineScope(Dispatchers.IO).launch {
            llmInference!!.generateResponseAsync(prompt)
            withContext(Dispatchers.Main) {
                result.success(true)
            }
        }
    }

    fun close() {
        runJob?.cancel()
        llmInference?.close()
        llmInference = null
    }


    companion object {
        private const val MODEL_PATH = "/data/local/tmp/llm/gemma2-2b-it-gpu-int8.bin"
    }
}
