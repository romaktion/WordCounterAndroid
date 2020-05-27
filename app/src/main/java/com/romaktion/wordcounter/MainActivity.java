package com.romaktion.wordcounter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.material.snackbar.Snackbar;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Objects;

public class MainActivity extends AppCompatActivity {

  // Used to load the 'native-lib' library on application startup.
  static {
    System.loadLibrary("native-lib");
  }
  TextView textView;
  InputStream inputStream;
  String IntermediateFileDir = Environment.getExternalStorageDirectory().getPath()
          + File.separator + "WordCounter";
  String IntermediateFilePath = Environment.getExternalStorageDirectory().getPath()
          + File.separator + "WordCounter"
          + File.separator + "temp.txt";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    // Example of a call to a native method
    textView = findViewById(R.id.sample_text);
    textView.setText(stringFromJNI());

    findViewById(R.id.btn_filePicker).setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {

        Intent myFileIntent = new Intent(Intent.ACTION_GET_CONTENT);
        myFileIntent.setType("text/plain");
        startActivityForResult(myFileIntent, 10);
      }
    });
  }

  /**
   * A native method that is implemented by the 'native-lib' native library,
   * which is packaged with this application.
   */
  public native String stringFromJNI();

  @Override
  protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == 10) {
      if (resultCode == RESULT_OK) {
        assert data != null;
        try {
          inputStream = getContentResolver().openInputStream(
                  Objects.requireNonNull(data.getData()));
        } catch (FileNotFoundException e) {
          e.printStackTrace();
        }

        //Permissions
        if (ContextCompat.checkSelfPermission(
                MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE) ==
                PackageManager.PERMISSION_GRANTED) {
          // You can use the API that requires the permission.
          OpenFile();
        } else if (shouldShowRequestPermissionRationale(
                Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
          // In an educational UI, explain to the user why your app requires this
          // permission for a specific feature to behave as expected. In this UI,
          // include a "cancel" or "no thanks" button that allows the user to
          // continue using your app without granting the permission.
          final String message = "Storage permission is needed to show files count";

          Snackbar.make(findViewById(R.id.content).getRootView(), message, Snackbar.LENGTH_LONG)
                  .setAction("GRANT", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                      requestPermissions();
                    }
                  })
                  .show();
        } else {
          // You can directly ask for the permission.
          requestPermissions();
        }
        //end Permissions
      }
    }
  }

  private void requestPermissions() {
    ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
  }

  @Override
  public void onRequestPermissionsResult(int requestCode,
                                         @NonNull String[] permissions, @NonNull int[] grantResults) {
    if (requestCode == 1) {
      if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        OpenFile();
      }
      else {
        Toast.makeText(MainActivity.this, "Permission denied to write your External storage", Toast.LENGTH_SHORT).show();
      }
    }
  }

  private void OpenFile() {
    File file = new File(IntermediateFileDir);
    if (!file.exists()) {
      if (!file.mkdirs()) {
        //TODO: Error handle
      }
    }

    FileOutputStream outputStream = null;
    try {
      outputStream = new FileOutputStream(IntermediateFilePath);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }

    assert outputStream != null;
    try {
      assert inputStream != null;
      byte[] buffer = new byte[1024];
      int read;

      while ((read = inputStream.read(buffer)) != -1)
        outputStream.write(buffer, 0, read);

      outputStream.flush();
    } catch (IOException e) {
      e.printStackTrace();
    }

    try {
      inputStream.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
    try {
      outputStream.close();
    } catch (IOException e) {
      e.printStackTrace();
    }

    textView.setText(IntermediateFilePath);
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();

    File file = new File(IntermediateFilePath);
    if (file.exists())
      file.delete();
  }
}
