package com.awesimsteps;

import android.util.Log;

import com.facebook.react.ReactActivity;

import java.util.Arrays;


public class MainActivity extends ReactActivity {

    static MainActivity activity = null;
    {
        Log.i("Jarek", "started activity:" + Arrays.toString(new RuntimeException("a").getStackTrace()));
        activity = this;
    }


    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "AwesimSteps";
    }


}
