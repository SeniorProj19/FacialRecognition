package clearorbit.yeet;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
//import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;

import com.google.android.glass.touchpad.Gesture;
import com.google.android.glass.touchpad.GestureDetector;
import com.google.android.glass.widget.CardBuilder;
import com.google.android.glass.widget.CardScrollAdapter;
import com.google.android.glass.widget.CardScrollView;

/**
 * Created by Daniel Vega on 11/10/2019.
 * This will be used as the main menu for the
 * glass application.
 */

public class MainActivity extends Activity {

    private CardScrollView mCardScroller;
    private View mView;
    private com.google.android.glass.touchpad.GestureDetector mGestureDetector;


    private View buildView() {
        CardBuilder card = new CardBuilder(this, CardBuilder.Layout.TEXT);
        card.setText(R.string.app_name);
        card.setText(R.string.app_name + "\n" + "Tap to take picture." + "\nDouble tap to view" +
                "previous entry.");
        //card.setImageLayout(Card.ImageLayout.LEFT);
        //card.addImage(R.drawable.ic_glass_logo);
        return card.getView();
    }

    protected void onCreate(Bundle savedInstance) {
        super.onCreate(savedInstance);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        setContentView(R.layout.main);
        mView = buildView();

        mCardScroller = new CardScrollView(this);
        mCardScroller.setAdapter(new CardScrollAdapter() {
            @Override
            public int getCount() {
                return 1;
            }
            @Override
            public Object getItem(int position) {
                return mView;
            }
            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                return mView;
            }
            @Override
            public int getPosition(Object item) {
                if (mView.equals(item)) {
                    return 0;
                }
                return AdapterView.INVALID_POSITION;
            }

        });

        // Handles the tap event
        mCardScroller.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                openOptionsMenu();
            }
        });
        mGestureDetector = createGestureDetector(this);

    }
    private GestureDetector createGestureDetector(Context context) {
        GestureDetector gestureDetector = new GestureDetector(context);

        //Listener for gestures
        //there is room for more functionality to be mapped to new gestures
        gestureDetector.setBaseListener( new GestureDetector.BaseListener() {
            @Override
            public boolean onGesture(Gesture gesture) {
                if (gesture == Gesture.TAP) {
                    startCamera();
                    return true;//TODO: show previous information on two_tap
                }/* else if (gesture == Gesture.TWO_TAP) {
                    // do something on two finger tap
                    return true;
                } */else if (gesture == Gesture.SWIPE_DOWN){
                    finish();
                }
                return false;
            }
        });

        return gestureDetector;
    }

    @Override
    public boolean onGenericMotionEvent(MotionEvent event) {
        if (mGestureDetector != null) {
            return mGestureDetector.onMotionEvent(event);
        }
        return false;
    }

    private void startCamera(){
        Intent intent1 = new Intent(this, camera.class);
        startActivity(intent1);
    }

}
