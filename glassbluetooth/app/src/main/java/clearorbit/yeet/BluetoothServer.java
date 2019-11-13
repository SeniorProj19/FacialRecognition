package clearorbit.yeet;

/*
Daniel Vega
Clear Orbit
Class: Bluetooth Server
 */

        import android.app.Activity;
        import android.bluetooth.*;
        import android.content.Context;
        import android.content.Intent;
        import android.content.res.AssetManager;
        import android.os.Bundle;
        import android.os.Environment;
        import android.util.Log;
        import android.widget.*;

        import java.io.BufferedInputStream;
        import java.io.File;
        import java.io.FileInputStream;
        import java.io.FileNotFoundException;
        import java.io.FileOutputStream;
        import java.io.IOException;
        import java.io.InputStream;
        import java.io.OutputStream;
        import java.util.*;

        import static android.content.ContentValues.TAG;

public class BluetoothServer extends Activity {

    public final static String label = "BluetoothServer";
    String picturePath;
    String fileName;

    BluetoothSocket socket;

    BluetoothAdapter mBluetoothAdapter;
    //BluetoothServerSocket mBluetoothServerSocket;
    public static final int REQUEST_TO_START_BT = 100;//must be greater than 0
    private TextView outPut;
    //the same UUID as client
    private UUID MY_UUID = UUID.fromString("297e4ec2-01a5-11ea-8d71-362b9e155667");
    @Override
    public void onCreate(Bundle savedInstanceState){
        Intent intent7 = this.getIntent();
        picturePath = intent7.getStringExtra("picturePath");
        fileName=picturePath.substring(picturePath.lastIndexOf("/")+1);
        //String currentDirectory = Path.GetDirectoryName(picturePath);

        super.onCreate(savedInstanceState);

        //setContentView(R.layout.activity_main);
       //outPut = (TextView) findViewById(R.id.info);
        setContentView(R.layout.main);
        outPut = (TextView) findViewById(R.id.info);
        //initialize BluetoothAdapter
        final BluetoothManager bluetoothManager =
                (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();
        if(mBluetoothAdapter == null){
            return;//checks if the device supports bluetooth
        }
        else{
            if(!mBluetoothAdapter.isEnabled()) {//if the adapter isn't enabled
                Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                //this requests to make the device discoverable
                startActivityForResult(enableBtIntent, REQUEST_TO_START_BT);
            }else{
                //If bluetooth is already enabled, we will cut out the step to attempt to enable it
                //and go straight to inialing and starting the AcceptThread inner class.
                new AcceptThread().start();
            }
        }
    }
    //this gets triggered when there is a bluetooth connection being requested
    private class AcceptThread extends Thread{
        private BluetoothServerSocket mServerSocket;
        private AcceptThread(){
            try{
                //this will create a socket that will listen for connection requests
                //this will only work if the client uses the same uuid
                mServerSocket =
                        mBluetoothAdapter.listenUsingRfcommWithServiceRecord("BluetoothServer", MY_UUID);
            }catch(IOException e){
                Log.e(label, e.getMessage());
            }
        }
        public void run(){
            //BluetoothSocket socket;
            while(true){//this is an infinite loop that stops when the ConnectedThread class is done
                try{
                    runOnUiThread(new Runnable(){public void run(){
                        outPut.setText(outPut.getText()+"\n\nWaiting for Bluetooth Client ..." + picturePath);
                    }});
                    //make a socket that is created when the original server socket is accepted
                    socket = mServerSocket.accept();
                }catch(IOException e){
                    Log.v(label, e.getMessage());
                    break;
                }
                //checks if the connection was successful
                if(socket != null){
                    new ConnectedThread().start();//Sends the socket through the connected thread
                    try{                                //inner class.
                        //this will close the socket used to listen
                        mServerSocket.close();
                    }catch(IOException e){
                        Log.v(label,e.getMessage());
                    }
                    break;
                }
            }
        }
    }//end of AcceptThread class
    //thread that sends file to client

    private class ConnectedThread extends Thread {

        private final BluetoothSocket mSocket;
        private final OutputStream mOutStream; //this will be used as the
        private int bytesRead;//this will keep track of bytes read
        final private String pictureName = fileName; //this is the name of the file we are sending
        final private String PATH = picturePath;//this is the location the file will be sent to
        //Environment.getExternalStorageDirectory().toString()+"/clearorbit/";

        private ConnectedThread(){
            mSocket = socket;
            OutputStream tmpOut = null;
            try{
                tmpOut = socket.getOutputStream();
            }catch(IOException e){
                Log.e(label, e.getMessage());
            }
            mOutStream = tmpOut;//sets the output stream
        }
        public void run(){
            byte[] buffer = new byte[1024];
            if(mOutStream!=null){
                //copy the picture we want to send
                File picture = new File(PATH);
                if(!picture.exists()){
                    return;
                }
                FileInputStream fis = null;
                try{
                    fis = new FileInputStream(picture);
                    OutputStream out = new FileOutputStream(PATH);
                }catch(FileNotFoundException e){
                    Log.e(label,e.getMessage());
                }
                BufferedInputStream bis = new BufferedInputStream(fis);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        outPut.setText(outPut.getText()+"\nbefore sending file"+
                                pictureName +
                                " of "+new File(picturePath).length()+" bytes");
                    }
                });
                //use streaming code to send socket data, which is a picture in this case
                try{
                    bytesRead = 0;
                    for(int read = bis.read(buffer);read>=0;read=bis.read(buffer)){
                        mOutStream.write(buffer,0,read);
                        bytesRead+=read;
                        outPut.setText(bytesRead);
                    }
                    mSocket.close();
                    runOnUiThread(new Runnable(){
                        public void run(){
                            outPut.setText(bytesRead+" bytes of file" + pictureName
                                    +" has been sent.");
                        }
                    });
                }catch(IOException e){
                    Log.e(label,e.getMessage());
                }
            }
            //wait for new connection from a client device
            //new AcceptThread().start();
            return;
        }//end of public void run

    }


}