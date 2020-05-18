package com.romaktion.wordcounter;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;
import android.widget.TextView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.util.Objects;

public class MainActivity extends AppCompatActivity {

  // Used to load the 'native-lib' library on application startup.
  static {
    System.loadLibrary("native-lib");
  }
  TextView textView;
  String filePath;
  InputStream inputStream;
  FileOutputStream outputStream;

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
        myFileIntent.setType("*/*");
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
        Uri uri = Objects.requireNonNull(data.getData());

        try {
          inputStream = getContentResolver().openInputStream(uri);
        } catch (FileNotFoundException e) {
          e.printStackTrace();
        }

        //Permissions

        //end Permissions

        try {
          outputStream = new FileOutputStream(Environment.getExternalStorageDirectory().getPath() + "/temp.jpg");
        } catch (FileNotFoundException e) {
          e.printStackTrace();
        }

        assert outputStream != null;
        try {
          assert inputStream != null;
          outputStream.write(inputStream.read());
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

        filePath = uri.toString();

        textView.setText(filePath);
      }
    }
  }


}
