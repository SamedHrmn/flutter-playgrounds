package com.example.my_audio_waveform

import android.content.Context
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.media.MediaRecorder.AudioSource
import androidx.annotation.RequiresApi
import androidx.core.net.toUri
import io.flutter.Build.API_LEVELS
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
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream
import kotlin.math.abs

@RequiresApi(API_LEVELS.API_31)
class MyAudioWaveformPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannelWaveform: EventChannel
    private lateinit var eventChannelPlayback: EventChannel

    private var waveformEventSink: EventSink? = null
    private var playbackEventSink: EventSink? = null
    private lateinit var myAudioRecorderHelper: MyAudioRecorderHelper

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "my_audio_waveform/method")
        methodChannel.setMethodCallHandler(this)

        eventChannelWaveform =
            EventChannel(flutterPluginBinding.binaryMessenger, "my_audio_waveform/event/waveform")
        eventChannelPlayback =
            EventChannel(flutterPluginBinding.binaryMessenger, "my_audio_waveform/event/playback")

        eventChannelWaveform.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink?) {
                waveformEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                waveformEventSink = null
            }
        })

        eventChannelPlayback.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink?) {
                playbackEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                playbackEventSink = null
            }
        })

        myAudioRecorderHelper =
            MyAudioRecorderHelper(context = flutterPluginBinding.applicationContext)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startRecording" -> myAudioRecorderHelper.startRecording(
                result = result,
                eventSink = waveformEventSink
            )

            "stopRecording" -> myAudioRecorderHelper.stopRecording(
                result = result
            )

            "startPlayback" -> myAudioRecorderHelper.startPlayback(
                result = result,
                eventSink = playbackEventSink
            )

            "stopPlayback" -> myAudioRecorderHelper.stopPlayback(result)
            "pauseRecording" -> myAudioRecorderHelper.pauseRecording(result)
            "resumeRecording" -> myAudioRecorderHelper.resumeRecording(result)
            else -> result.notImplemented()

        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannelWaveform.setStreamHandler(null)
        eventChannelPlayback.setStreamHandler(null)
    }


}

@RequiresApi(API_LEVELS.API_31)
class MyAudioRecorderHelper(val context: Context) {
    private var audioRecord: AudioRecord? = null
    private var player: MediaPlayer? = null
    private var recorder: MediaRecorder? = null
    private var isRecording = false
    private var isPaused = false
    private var isPlaybackActive = false
    private var recordingJob: Job? = null

    private var outputFile = File(context.filesDir, "audio_record.mp3")
    private val bufferSize = AudioRecord.getMinBufferSize(
        SAMPLE_RATE,
        AudioFormat.CHANNEL_IN_MONO,
        AudioFormat.ENCODING_PCM_16BIT
    )

    fun startRecording(result: Result, eventSink: EventSink?) {
        if (isRecording) {
            result.success(false)
            return
        }

        audioRecord = AudioRecord(
            AudioSource.MIC,
            SAMPLE_RATE,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            bufferSize
        )

        recorder = MediaRecorder(context).apply {
            setAudioSource(AudioSource.MIC)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setOutputFile(FileOutputStream(outputFile).fd)
            prepare()
            start()
        }

        isRecording = true
        isPaused = false


        if (audioRecord!!.state != AudioRecord.STATE_INITIALIZED) {
            result.error("-1", "AudioRecord can't initialized", null)
            return
        }

        audioRecord!!.startRecording()

        recordingJob = CoroutineScope(Dispatchers.IO).launch {


            val audioData = ShortArray(bufferSize)
            while (isRecording) {
                if (isPaused) {
                    delay(100)
                    continue
                }

                val readSize = audioRecord?.read(audioData, 0, audioData.size) ?: 0
                if (readSize > 0) {
                    val waveformData = audioData.map { abs(it.toFloat()) / Short.MAX_VALUE }
                    withContext(Dispatchers.Main) {
                        eventSink?.success(waveformData)
                    }
                }

            }
        }



        result.success(true)

    }

    fun stopRecording(result: Result) {
        isRecording = false
        recordingJob?.cancel()
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        recorder?.stop()
        recorder?.reset()
        recorder = null
        result.success(true)
    }

    fun pauseRecording(result: Result) {
        isPaused = true
        result.success(true)
    }

    fun resumeRecording(result: Result) {
        isPaused = false
        result.success(true)
    }


    fun startPlayback(result: Result, eventSink: EventSink?) {
        MediaPlayer.create(context, outputFile.toUri()).apply {
            player = this

            start()
            isPlaybackActive = true

            var currentPositionArg = 0
            var durationArg = 0

            val updateInterval = 500L
            CoroutineScope(Dispatchers.IO).launch {
                while (isPlaybackActive) {
                    delay(updateInterval)

                    if (player != null && player!!.isPlaying) {
                        try {
                         currentPositionArg = currentPosition
                         durationArg = duration
                        } catch (e: IllegalStateException) {
                            player?.reset()
                        }
                    }

                    withContext(Dispatchers.Main) {
                        eventSink?.success(
                            mapOf(
                                "currentPosition" to currentPositionArg,
                                "duration" to durationArg
                            )
                        )
                    }
                }
            }
        }

        result.success(true)
    }

    fun stopPlayback(result: Result) {
        player?.stop()
        player?.release()
        player = null
        isPlaybackActive = false
        result.success(true)
    }

    companion object {
        private const val SAMPLE_RATE = 44100

    }
}