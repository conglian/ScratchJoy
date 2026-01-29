package com.dexterous.flutterlocalnotifications;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import com.dexterous.flutterlocalnotifications.models.NotificationDetails;

import java.util.ArrayList;

public class ForegroundService extends Service {
    static boolean alive = false;

    @Override
    public void onCreate() {
        super.onCreate();
        alive = true;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        alive = false;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        final NotificationDetails notificationData = FlutterForePlugin.extractNotificationDetails(getApplicationContext());
        FlutterLocalNotificationsPlugin.createNotification(
                this, notificationData,
                notification -> startForeground(notificationData.id, notification));
        return super.onStartCommand(intent, flags, startId);
    }

    private static int orCombineFlags(ArrayList<Integer> flags) {
        int flag = flags.get(0);
        for (int i = 1; i < flags.size(); i++) {
            flag |= flags.get(i);
        }
        return flag;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
