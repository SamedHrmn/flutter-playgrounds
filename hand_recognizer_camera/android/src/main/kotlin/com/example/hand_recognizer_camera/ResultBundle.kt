package com.example.hand_recognizer_camera

import com.google.mediapipe.tasks.components.containers.NormalizedLandmark
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult

data class ResultBundle(
    val results: List<HandLandmarkerResult>,
    val inferenceTime: Long,
    val inputImageHeight: Int,
    val inputImageWidth: Int,
)

fun ResultBundle.toMap(): Map<String, Any> {
    return mapOf(
        "results" to results.map { it.toMap() },
        "inferenceTime" to inferenceTime,
        "inputImageHeight" to inputImageHeight,
        "inputImageWidth" to inputImageWidth
    )
}

private fun HandLandmarkerResult.toMap(): Map<String, Any> {
    val landMarks = mutableListOf<NormalizedLandmark>()
    landmarks().forEach { landmark->
        landmark.map {
            landMarks.add(it)
        }
    }

    return mapOf(
        "landmarks" to landMarks.map { it.toMap() }
    )
}

private fun NormalizedLandmark.toMap(): Map<String, Any> {
    return mapOf(
        "x" to x(),
        "y" to y(),
        "z" to z()
    )
}
