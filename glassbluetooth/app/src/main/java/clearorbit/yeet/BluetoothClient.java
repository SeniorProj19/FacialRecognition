package clearorbit.yeet;

/*
Daniel Vega
Clear Orbit
Class: Bluetooth Client
 */
        import android.app.Activity;
        import android.bluetooth.*;
        import android.content.BroadcastReceiver;
        import android.content.Context;
        import android.content.Intent;
        import android.content.IntentFilter;
        import android.os.Bundle;
        import android.os.Environment;
        import android.util.Log;
        import android.view.*;
        import android.widget.*;

       // import com.clearorbit.myapplication.R;

        import com.google.android.glass.widget.CardBuilder;

        import java.io.BufferedOutputStream;
        import java.io.FileOutputStream;
        import java.io.IOException;
        import java.io.InputStream;
        import java.util.*;

        import static clearorbit.yeet.R.menu.main;


public class BluetoothClient extends Activity {


    public final static String label = "BluetoothClient";
    public final static int REQUEST_ENABLE_BT =100;//must be greater than 0
    private BluetoothAdapter mBluetoothAdapter;
    private TextView outPut;
    //the same UUID as server
    private UUID MY_UUID = UUID.fromString("297e4ec2-01a5-11ea-8d71-362b9e155667");
    private final static String filePath = Environment.getExternalStorageDirectory().getPath() +
            "/filefromBTserver";
    private final static String serverDName = "Dan's Glass";
    private TextView mTvInfo;
    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        //setContentView(R.main.activity_main);
        //outPut = (TextView) findViewById(R.id.info);
        setContentView(R.layout.main);
        outPut = (TextView) findViewById(R.id.info);
        outPut.setText("Bluetooth Client");
        //initialize BluetoothAdapter
        final BluetoothManager bluetoothManager =
                (BluetoothManager)getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();
        if(mBluetoothAdapter == null)
            return;//checks if the device supports bluetooth
        else{
            if(!mBluetoothAdapter.isEnabled()) {//checks if bluetooth  is disabled
                Intent enableBtIntent = new
                        Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);//passes constant int to onActivityResult()
                //this requests to make the device discoverable
                //this will call onActivateResult
                startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
            }else{
                //if bluetooth is enabled, it will cut out the step to attempt to enable it.
                //This uses two different ways to try to find and connect to our server device.
                //It is more reliable and stable to connect to an already bonded device.

                //Discover bluetooth devices that haven't been bonded to the client device already.
                discoverBluetoothDevices();
                //Searches the list of already bonded devices for the one that we are looking for.
                getBondedDevices();
            }
        }
    }
    //We are overriding to add the two methods used to find the server device
    @Override//the requestCode is the REQUUEST_ENABLE from earlier
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
        if(requestCode == REQUEST_ENABLE_BT){//checks if the result enabling bluetooth succeeded
            //Discover bluetooth devices that haven't been bonded to the client device already.
            discoverBluetoothDevices();
           // Searches the list of already bonded devices for the one that we are looking for.
            getBondedDevices();
            return;
        }
    }
    void discoverBluetoothDevices(){
        //initialize a BroadcastReceiver for the ACTION_FOUND Intent
        //to get info about each Bluetooth device discovered
        IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        registerReceiver(mReceiver, filter);//calls BroadcastReceiver
        mBluetoothAdapter.startDiscovery();
    }
    //for each device discovered, the broadcast info is received
    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            //When discovery finds a device
            if(BluetoothDevice.ACTION_FOUND.equals(action)){
                // Discovery has found a device. Get the BluetoothDevice
                // object and its info from the Intent.
                BluetoothDevice device =
                        intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                String name = device.getName();
                //found server device
                if(name != null && name.equalsIgnoreCase(serverDName)){
                    new ConnectedThread(device).start(); //initializes ConnectedThread inner class
                }
            }
        }
    };
    protected void onDestroy(){
        unregisterReceiver(mReceiver);
        super.onDestroy();
    }
    //bonded devices are devices are already paired with the current device
    void getBondedDevices(){
        Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
        if(pairedDevices.size()>0){//checks if there are any paired devices
            //loops through all of the paired devices until it finds the device that we are
            //trying to pair to or until it goes through all of them
            for(BluetoothDevice device : pairedDevices){
                if(device.getName().equalsIgnoreCase(serverDName)){
                    new ConnectedThread(device).start();//initializes ConnectedThread inner class
                    break;
                }
            }
        }else{
            Toast.makeText(BluetoothClient.this,"No bonded devices", Toast.LENGTH_LONG).show();
        }
    }

    private class ConnectedThread extends Thread{
        int bytesRead;//will be used when receiving the file
        int total; //will be used when receiving the file
        private final BluetoothSocket mClientSocket;
        private ConnectedThread(BluetoothDevice device){
            BluetoothSocket tmp = null;
            try{
                tmp = device.createRfcommSocketToServiceRecord(MY_UUID);
            }catch(IOException e){
                Log.v(label,e.getMessage());
            }
            mClientSocket = tmp;//this is the RfcommSocket
        }
        public void run(){
            try{
                //blocking call to connect to server
                mClientSocket.connect();
            }catch(IOException e){
                Log.v(label, e.getMessage());
                try{
                    //closes socket if it fails to connect
                    mClientSocket.close();
                }catch(IOException ce){}
                return;
            }
            //Calls the function that receives the file
            manageConnectedSocket(mClientSocket);
        }
        //receive file from server and closes the socket
        private void manageConnectedSocket(BluetoothSocket socket){
            byte[] buffer = new byte[1024];
            FileOutputStream fos;
            BufferedOutputStream bos = null;
            try{
                //this is the RfcommSocket that was passed to this function
                InputStream inputStream = socket.getInputStream();
                fos = new FileOutputStream(filePath);
                bos = new BufferedOutputStream(fos);
                bytesRead = -1;
                total = 0;
                //use streaming code to receive the socket data from server
                while((bytesRead = inputStream.read(buffer))>0){
                    total += bytesRead;
                    bos.write(buffer, 0, bytesRead);
                }
                bos.close();
                socket.close();
            }catch(IOException e){
                try{
                    socket.close();
                    bos.close();
                }catch(IOException ee){
                    Log.e(label, "socket close exception: ", ee);
                }
            }
        }
    }


}
