package com.example.hand_recognizer_camera

import android.app.Activity
import android.content.Context
import android.util.Size
import android.view.Surface
import androidx.camera.core.AspectRatio
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageCapture
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.view.TextureRegistry
import io.flutter.view.TextureRegistry.TextureEntry
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class CameraController(
    private val context: Context,
    private val activity: Activity?,
    private var textureEntry: TextureEntry?,
    private val textureRegistry: TextureRegistry?,
    private val handLandmarkerHelper: HandLandmarkerHelper
) {

    private var cameraExecutor: ExecutorService? = null
    private var imageAnalysis: ImageAnalysis? = null
    private var imageCapture: ImageCapture? = null

    fun initializeCamera(result: Result) {
        if (textureEntry != null) {
            result.error("ALREADY_INITIALIZED", "Camera already initialized", null)
            return
        }

        textureEntry = textureRegistry?.createSurfaceTexture()
        val surfaceTexture =
            (textureEntry as TextureRegistry.SurfaceTextureEntry?)?.surfaceTexture()


        surfaceTexture?.setDefaultBufferSize(1280, 1080)

        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)

        cameraProviderFuture.addListener({
            val cameraProvider = cameraProviderFuture.get()
            val preview = Preview.Builder()
                .build().also {
                    it.setSurfaceProvider { request ->
                        request.provideSurface(
                            Surface(surfaceTexture!!),
                            ContextCompat.getMainExecutor(context)
                        ) {}
                    }
                }


            imageCapture = ImageCapture.Builder().build()
            imageAnalysis = ImageAnalysis.Builder()
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
                .build()

            try {
                cameraProvider.unbindAll()
                cameraProvider.bindToLifecycle(
                    activity as LifecycleOwner,
                    CameraSelector.DEFAULT_BACK_CAMERA,
                    preview,
                    imageCapture,
                    imageAnalysis
                )
                cameraExecutor = Executors.newSingleThreadExecutor()
                result.success(textureEntry?.id())
            } catch (exc: Exception) {
                result.error("CAMERA_ERROR", "Failed to initialize camera: ${exc.message}", null)
            }


        }, ContextCompat.getMainExecutor(context))

    }

    fun startImageStream(result: Result) {
        val analysis = imageAnalysis ?: run {
            result.error("NOT_INITIALIZED", "Camera not initialized", null)
            return
        }

        analysis.setAnalyzer(cameraExecutor!!) { imageProxy ->
            handLandmarkerHelper.detectLiveStream(imageProxy, false)
        }

        result.success(null)
    }


    fun dispose() {
        textureEntry?.release()
        cameraExecutor?.shutdown()
        imageAnalysis?.clearAnalyzer()
        imageCapture = null
        imageAnalysis = null
    }
}