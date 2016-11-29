package com.awesimsteps;

import android.app.Application;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.BV.LinearGradient.LinearGradientPackage;
import com.oblador.vectoricons.VectorIconsPackage;

import java.util.Arrays;
import java.util.List;

import android.util.Log;
/**
 * Created by eth on 27.11.16.
 */
public class MainApplication extends Application implements ReactApplication {


    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
        /**
         * Returns whether dev mode should be enabled.
         * This enables e.g. the dev menu.
         */
        @Override
        protected boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        /**
         * A list of packages used by the app. If the app uses additional views
         * or modules besides the default ones, add more packages here.
         */
        @Override
        protected List<ReactPackage> getPackages() {
            Log.i("Jarek", "giving packages");
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new LinearGradientPackage(),
                    new VectorIconsPackage(),
                    new GoogleFitPackage(MainActivity.activity)
            );
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }
}



