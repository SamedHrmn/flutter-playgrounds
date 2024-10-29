package com.example.srgan_flutter

import android.app.Application
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.os.SystemClock
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.tensorflow.lite.DataType
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.gpu.CompatibilityList
import org.tensorflow.lite.gpu.GpuDelegate
import org.tensorflow.lite.support.common.FileUtil
import org.tensorflow.lite.support.common.ops.CastOp
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer
import kotlin.math.roundToInt

class SrganHelper(
    private val context: Context,
    private val srganResultListener: SrganResultListener
) {
    private var interpreter: Interpreter? = null
    private var outputShapeForScaling: Int = 1

    init {
        createInterpreter()
    }


    private val imageProcessor = ImageProcessor.Builder()
        .add(CastOp(INPUT_IMAGE_TYPE))
        .build()

    private fun close() {
        interpreter?.close()
        interpreter = null
    }

    private fun createInterpreter() {
        if (interpreter != null) {
            close()
        }

        val options = Interpreter.Options()
        val modelFile = FileUtil.loadMappedFile(context, MODEL_FILE)

        val compatibilityList = CompatibilityList()
        if (compatibilityList.isDelegateSupportedOnThisDevice) {
            options.addDelegate(GpuDelegate(compatibilityList.bestOptionsForThisDevice))
        } else {
            options.setNumThreads(NUM_THREAD)
        }

        interpreter =
            Interpreter(modelFile, options)

        outputShapeForScaling = interpreter!!.getOutputTensor(0).shape()[2]


    }

    fun enhanceImage(inputBitmap: Bitmap) {

        CoroutineScope(Dispatchers.IO).launch {
            var inferenceTime = SystemClock.uptimeMillis()

            val tensorImage = TensorImage(INPUT_IMAGE_TYPE).also { it.load(inputBitmap) }
            val processedImage = imageProcessor.process(tensorImage)

            val outputBuffer = TensorBuffer.createFixedSize(
                intArrayOf(
                    1,
                    processedImage.width * 4,
                    processedImage.width * 4,
                    3
                ),
                OUTPUT_IMAGE_TYPE
            )

            interpreter!!.resizeInput(
                interpreter!!.getInputTensor(0).index(),
                intArrayOf(1, processedImage.width, processedImage.height, 3)
            )

            interpreter!!.allocateTensors()


            interpreter!!.run(processedImage.buffer, outputBuffer.buffer)

            val processedOutput = processOutput(
                outputBuffer,
                width = processedImage.width * 4,
                height = processedImage.height * 4
            )

            inferenceTime = SystemClock.uptimeMillis() - inferenceTime

            withContext(Dispatchers.Main) {
                srganResultListener.onResultReady(
                    SrganResult(
                        output = processedOutput,
                        inferenceTime = inferenceTime
                    )
                )
            }
        }


    }


    private fun processOutput(outputBuffer: TensorBuffer, width: Int, height: Int): Bitmap {
        val data = outputBuffer.intArray


        // Check that the float array has the correct number of elements
        if (data.size != width * height * 3) {

        }


        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)


        // Iterate through the float array and set pixels in the bitmap
        var index: Int
        for (y in 0 until height) {
            for (x in 0 until width) {
                index = (y * width + x) * 3
                // Extract RGB values from the float array
                val r = data[index].coerceIn(0, 255)
                val g = data[index + 1].coerceIn(0, 255)
                val b = data[index + 2].coerceIn(0, 255)


                // Set the pixel color (we set alpha to 255 for full opacity)
                bitmap.setPixel(x, y, Color.rgb(r, g, b))

            }
        }

        val casted = TensorImage.fromBitmap(bitmap)
        val new =
            ImageProcessor.Builder().add(CastOp(DataType.UINT8)).build().process(casted).bitmap

        return new
    }


    companion object {
        private const val NUM_THREAD = 4
        const val MODEL_FILE = "gan_generator.tflite"
        private val INPUT_IMAGE_TYPE = DataType.FLOAT32
        private val OUTPUT_IMAGE_TYPE = DataType.FLOAT32

    }

}

interface SrganResultListener {
    fun onResultReady(srganResult: SrganResult)
}

data class SrganResult(val output: Bitmap, val inferenceTime: Long)