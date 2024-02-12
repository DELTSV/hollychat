package com.example.hollychat

import android.database.Cursor
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "image_gallery"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getImages") {
                val count = call.argument<Int>("count")
                val images = getImages(count ?: 0)
                result.success(images)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getImages(count: Int): List<String> {
        val images = mutableListOf<String>()
        val projection = arrayOf(MediaStore.Images.Media.DATA)
        val sortOrder = "${MediaStore.Images.Media.DATE_ADDED} DESC"
        val cursor: Cursor? = contentResolver.query(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            projection,
            null,
            null,
            sortOrder
        )
        cursor?.use {
            val columnIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            var i = 0
            while (it.moveToNext() && i < count) {
                val imagePath = it.getString(columnIndex)
                images.add(imagePath)
                i++
            }
        }
        return images
    }
}