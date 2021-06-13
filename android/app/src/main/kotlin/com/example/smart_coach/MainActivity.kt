package com.example.smart_coach

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.app.AlarmManager
import android.content.Context
import android.content.BroadcastReceiver
import android.content.Intent
import android.app.PendingIntent
import java.util.*
import java.lang.System
import android.app.NotificationChannel
import android.app.NotificationManager
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.Builder
import androidx.core.app.NotificationManagerCompat
import android.os.Build
import android.media.MediaPlayer
import io.flutter.FlutterInjector
import android.content.res.AssetManager
import java.time.LocalTime
import java.time.LocalDate

class MainActivity: FlutterActivity() {
    companion object {
        val NOTIFICATION_CHANNEL_ID = "1"
    }
    private val CHANNEL = "com.smart_coach.methods"
    lateinit var alarmManager: AlarmManager
    lateinit var mediaPlayer: MediaPlayer

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when(call.method) {
                "startNotificationService" -> {
                    val time = call.argument<Map<String, Int>>("time")
                    val repeatingDays = call.argument<List<Int>>("repeatingDays")
                    startNotificationService(time!!, repeatingDays!!)
                    result.success(true)
                }
                "stopNotificationService" -> {
                    stopNotificationService()
                    result.success(true)
                }
                "playSound" -> {
                    val soundResPath = call.argument<String>("path")
                    playSound(soundResPath as String)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelName: String = "com.smart_coach.notifications"
            val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_HIGH).apply {
                description = "Training routine notifier"
            }
            val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun startNotificationService(timeObj: Map<String, Int>, repeatingDays: List<Int>) {
        val intent = Intent(getContext(), Receiver::class.java)
        intent.putExtra("repeatingDays", repeatingDays.toIntArray())
        val pendingIntent = PendingIntent.getBroadcast(getContext(), 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        val notifyTime: LocalTime = LocalTime.of(timeObj["hour"]!!, timeObj["minute"]!!, 0)
        val nowTime: LocalTime = LocalTime.now()
        var timeDeltaSecs = notifyTime.toSecondOfDay() - nowTime.toSecondOfDay() // later
        if(notifyTime.isBefore(nowTime)) { // before
            timeDeltaSecs = 24 * 3600 - nowTime.toSecondOfDay() + notifyTime.toSecondOfDay()
        }
        Log.d("NativeAPI", "[${nowTime}] Starting notification service for ${notifyTime}. Time delta seconds = ${timeDeltaSecs}.")
        val alarmTime = System.currentTimeMillis() + timeDeltaSecs * 1000
        alarmManager.setInexactRepeating(
                AlarmManager.RTC_WAKEUP,
                alarmTime,
                AlarmManager.INTERVAL_DAY,
                pendingIntent
        )
    }

    private fun stopNotificationService() {
        Log.d("NativeAPI", "[${LocalTime.now()}] Stoping notification service.")
        val intent = Intent(getContext(), Receiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(getContext(), 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        alarmManager.cancel(pendingIntent)
    }

    private fun playSound(res: String) {
        Log.d("NativeAPI", "playSound: " + res)
        val loader = FlutterInjector.instance().flutterLoader()
        val key = loader.getLookupKeyForAsset(res)
        val fd = getContext().assets.openFd(key)
        mediaPlayer = MediaPlayer()
        mediaPlayer.setDataSource(fd)
        mediaPlayer.prepare()
        mediaPlayer.start()
    }

    class Receiver : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            Log.d("NativeAPI", "[${LocalTime.now()}] Checking if API should notify.")
            val repeatingDays = intent?.getIntArrayExtra("repeatingDays")!!
            if(repeatingDays.contains(LocalDate.now().getDayOfWeek().getValue() - 1)) {
                Log.d("NativeAPI", "[${LocalTime.now()}] API should notify.")
                val newIntent = Intent(context, MainActivity::class.java)
                newIntent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
                val pendingIntent: PendingIntent = PendingIntent.getActivity(context, 0, newIntent, 0)
                val builder = NotificationCompat.Builder(context as Context, NOTIFICATION_CHANNEL_ID)
                        .setSmallIcon(R.drawable.launch_background)
                        .setContentTitle("Workout day")
                        .setContentText("Time to get bigger! :D")
                        .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                        .setContentIntent(pendingIntent)
                        .setAutoCancel(true)
                with(NotificationManagerCompat.from(context as Context)) {
                    notify(1, builder.build())
                }
            }
        }
    }
}
