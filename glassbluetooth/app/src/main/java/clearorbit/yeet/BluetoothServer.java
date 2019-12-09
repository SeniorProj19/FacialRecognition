package clearorbit.yeet;

/*
Daniel Vega
Clear Orbit
Class: Updated Bluetooth Server
 */

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.TextView;


public class BluetoothServer extends Activity {

	public final static String TAG = "BluetoothServer";
	BluetoothAdapter mBluetoothAdapter;
	BluetoothServerSocket mBluetoothServerSocket;
	public static final int REQUEST_TO_START_BT = 100;
	public static final int REQUEST_FOR_SELF_DISCOVERY = 200;
	private TextView mTvInfo;
	String picturePath;
	String fileName;

	UUID MY_UUID = UUID.fromString("297e4ec2-01a5-11ea-8d71-362b9e155667");

	@Override
	public void onCreate(Bundle savedInstanceState) {
		//the intent code is used for this class to be activated when the camera class finishes
		//taking a picture and is ready to send it.
		//It gives us the picture path, and we extrapolate the picture name from it as well.
		Intent intent2 = this.getIntent();
		picturePath = intent2.getStringExtra("picturePath");
		fileName=picturePath.substring(picturePath.lastIndexOf("/")+1);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		//sets the output to a simple text view
		mTvInfo = (TextView) findViewById(R.id.info);

		// initialize Bluetooth manager
		final BluetoothManager mbluetoothManager =
				(BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
		mBluetoothAdapter = mbluetoothManager.getAdapter();
		//checks if device has bluetooth capabilities
		if (mBluetoothAdapter == null) {
			mTvInfo.setText("Device cannot bluetooth");
			return;
		} else {
			//checks if bluetooth is enabled
			if (!mBluetoothAdapter.isEnabled()) {
				mTvInfo.setText("Bluetooth not enabled");
				Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
				startActivityForResult(enableBtIntent, REQUEST_TO_START_BT);
			} else {
				mTvInfo.setText("Bluetooth enabled... Attempting to connect to client");
				new AcceptThread().start();
			}
		}
		finish();
	}
	//this class is used to connect the two devices together, the client device has a similar
	//inner class.
	private class AcceptThread extends Thread {
		private BluetoothServerSocket mServerSocket;

		public AcceptThread() {
			try {
				mServerSocket = mBluetoothAdapter.listenUsingRfcommWithServiceRecord("BluetoothServer", MY_UUID);
			}
			catch (IOException e) {
				final IOException ex = e;
				runOnUiThread(new Runnable() {
					public void run() {
						mTvInfo.setText(ex.getMessage());
					}
				});
			}
		}

		public void run() {
			BluetoothSocket socket = null;
			//listen until a request to connect is made
			while (true) {
				try {
					runOnUiThread(new Runnable() {
						public void run() {
							mTvInfo.setText(mTvInfo.getText() + "\n\nWaiting for Bluetooth Client ...");
						}
					});

					socket = mServerSocket.accept();

				} catch (IOException e) {
					Log.v(TAG, e.getMessage());
					break;
				}
				// If a connection was accepted
				if (socket != null) {
					/*try {
						Thread.sleep(10000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}*/
					//activates another inner class
					new ConnectedThread(socket).start();
					//close the socket made in this class
					try {
						mServerSocket.close();
					} catch (IOException e) {
						Log.v(TAG, e.getMessage());
					}
					break;
				}
			}
		}
	}

	//this inner class handles the rest of the bluetooth image transfer process.
	//It is called only after a bluetooth connection has been successfully formed, and it will
	//use streaming code to transfer data to the devie running the client class.
	private class ConnectedThread extends Thread {
		private final BluetoothSocket mSocket;
		private final OutputStream mOutStream;
		private int bytesRead;

		//creates an output stream for the socket we are working with
		public ConnectedThread(BluetoothSocket socket) {
			mSocket = socket;
			OutputStream tmpOut = null;

			try {
				tmpOut = socket.getOutputStream();
			} catch (IOException e) {
				Log.e(TAG, e.getMessage());
			}
			mOutStream = tmpOut;
		}

		public void run() {


			//stream code used to stream data through bluetooth.
			//No bitmapping is needed, the file just needs to be named "___.jpeg" for it to be
			//an image. This is done in the client device's bluetooth class.
			if (mOutStream != null) {
				File mFile = new File( picturePath );
				FileInputStream fis = null;

				try {
					fis = new FileInputStream(mFile);
				} catch (FileNotFoundException e) {
					Log.e(TAG, e.getMessage());
				}
				int picSize = (int) new File(  picturePath  ).length();
				BufferedInputStream bis = new BufferedInputStream(fis, picSize);
				runOnUiThread(new Runnable() {
					public void run() {
						mTvInfo.setText(mTvInfo.getText() + "\nPreparing to send "+  fileName + " of " + new File(  picturePath  ).length() + " bytes");
					}
				});
				byte[] buffer = new byte[picSize];
				try {
					bytesRead = 0;
					for (int read = bis.read(buffer); read >= 0; read = bis.read(buffer))
					{
						mOutStream.write(buffer, 0, read);
						bytesRead += read;
						// code for mobile version of host class
//						runOnUiThread(new Runnable() {
//							public void run() {
//								mTvInfo.setText(mTvInfo.getText() + ".");
//							}
//						});
					}

					mSocket.close();
					runOnUiThread(new Runnable() {
						public void run() {
							mTvInfo.setText(bytesRead + " bytes of " +  fileName + " has been sent." +
									"\nFile has been successfuly sent.");
						}
					});

				} catch (IOException e) {
					Log.e(TAG, e.getMessage());
				}
			}
			//new AcceptThread().start();
			finish();
		}
	}
}

