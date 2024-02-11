package com.example.hollychat

import android.Manifest
import android.app.AlertDialog

import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val REQUEST_STORAGE_PERMISSION = 100
    }

    private fun isAlreadyGranted(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun requestStoragePermission(result: MethodChannel.Result) {
        if (isAlreadyGranted(Manifest.permission.READ_MEDIA_IMAGES) || isAlreadyGranted(Manifest.permission.READ_EXTERNAL_STORAGE)) {
            // Permission already granted
            result.success(true)
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                if (checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(
                        this, arrayOf(
                            Manifest.permission.READ_MEDIA_IMAGES,
                        ), REQUEST_STORAGE_PERMISSION
                    )
                }
            } else {
                if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(
                        this, arrayOf(
                            Manifest.permission.READ_EXTERNAL_STORAGE
                        ), REQUEST_STORAGE_PERMISSION
                    )
                }
            }

            // Need to wait for the result of the permission request
            result.success(false)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_STORAGE_PERMISSION) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted
                MethodChannel(
                    flutterEngine!!.dartExecutor.binaryMessenger, "permissions"
                ).invokeMethod("onRequestPermissionsResult", true)
            } else {
                // Permission denied
                if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_MEDIA_IMAGES)) {
                    // Permission has been permanently denied
                    // Show a dialog or message to the user explaining why the permission is needed
                    // and directing them to the app settings
                    // You can use an AlertDialog or a custom dialog for this purpose
                    showPermissionDeniedDialog()
                } else {
                    // Permission denied but can be requested again
                    MethodChannel(
                        flutterEngine!!.dartExecutor.binaryMessenger, "permissions"
                    ).invokeMethod("onRequestPermissionsResult", false)
                }
            }
        }
    }

    private fun showPermissionDeniedDialog() {
        val builder = AlertDialog.Builder(this)
        builder.setTitle("Permission refusée")
        builder.setMessage("Vous avez refusé la permission de stockage. Veuillez l'activer dans les paramètres de l'application.")
        builder.setPositiveButton("Aller dans les paramètres") { dialog, which ->
            // Open app settings
            openAppSettings()
        }
        builder.setNegativeButton("Annuler") { dialog, which ->
            // Handle cancellation if needed
        }
        builder.show()
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        val uri = Uri.fromParts("package", packageName, null)
        intent.data = uri
        startActivity(intent)
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "image_gallery"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getImages") {
                val images = getImages()
                result.success(images)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "permissions").setMethodCallHandler { call, result ->
            if (call.method == "requestStoragePermission") {
                requestStoragePermission(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getImages(): List<String> {
        val images = mutableListOf<String>()
        val projection = arrayOf(MediaStore.Images.Media.DATA)
        val cursor: Cursor? = contentResolver.query(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI, projection, null, null, null
        )
        cursor?.use {
            val columnIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            while (it.moveToNext()) {
                val imagePath = it.getString(columnIndex)
                images.add(imagePath)
            }
        }
        return images
    }
}