package clearorbit.yeet;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.FileObserver;
import android.provider.MediaStore;

import com.google.android.glass.content.Intents;

import java.io.File;

/**
 * Created by Daniel Vega on 11/9/2019.
 * This class will be called from the main activity.
 * It's purpose is to take a picture as soon as it is called.
 * It will then have the user tap to confirm. It will then process
 * the picture and call the bluetooth server class to send it.
 */

public class camera extends Activity {
    private static final int PICTURE_REQUEST = 1;
    String picturePath;

    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        takePicture();
    }
    private void takePicture() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(intent, PICTURE_REQUEST);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == PICTURE_REQUEST && resultCode == RESULT_OK) {
            picturePath = data.getStringExtra(Intents.EXTRA_PICTURE_FILE_PATH);
            processPicture(picturePath);
            Intent cameraIntent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
            if(picturePath == null){
                return;
            }

        }

        super.onActivityResult(requestCode, resultCode, data);
        //This activates the bluetoothserver class and sends it the path of the picture taken.
        Intent intent7 = new Intent(this, BluetoothServer.class);
        intent7.putExtra("picturePath", picturePath);
        startActivity(intent7);
        finish();
    }

    private void processPicture(final String picturePath) {
        final File pictureFile = new File(picturePath);

        if (pictureFile.exists()) {
            // The picture is ready to be processed
        } else {
            // The file does not exist yet.
            final File parentDirectory = pictureFile.getParentFile();
            FileObserver observer = new FileObserver(parentDirectory.getPath(),
                    FileObserver.CLOSE_WRITE | FileObserver.MOVED_TO) {
                private boolean isFileWritten;

                @Override
                public void onEvent(int event, String path) {
                    if (!isFileWritten) {
                        //check that the file in the directory is the file we want
                        File affectedFile = new File(parentDirectory, path);
                        isFileWritten = affectedFile.equals(pictureFile);

                        if (isFileWritten) {
                            stopWatching();

                            // Now that the file is ready, recursively call
                            // processPicture again (on the UI thread).
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    processPicture(picturePath);
                                }
                            });
                        }
                    }
                }
            };
            observer.startWatching();

        }
    }

}
