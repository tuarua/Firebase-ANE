package com.tuarua.firebase;

import android.content.Intent;
import android.util.Log;

import com.adobe.air.AndroidActivityWrapper;
import com.adobe.air.TRActivityResultCallback;
import com.adobe.air.TRStateChangeCallback;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.google.firebase.FirebaseApp;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.tuarua.frekotlin.FreKotlinContext;
import com.tuarua.frekotlin.FreKotlinMainController;

import java.util.HashMap;
import java.util.Map;

class AnalyticsANEContext extends FreKotlinContext implements TRActivityResultCallback, TRStateChangeCallback {
    private AndroidActivityWrapper aaw;
    private FreKotlinMainController controller;
    private FirebaseAnalytics mFirebaseAnalytics;

    AnalyticsANEContext(String name, FreKotlinMainController controller, String[] functions) {
        super(name, controller, functions);
        this.controller = controller;
        aaw = AndroidActivityWrapper.GetAndroidActivityWrapper();
        aaw.addActivityResultListener(this);
        aaw.addActivityStateChangeListner(this);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
    }

//    @Override
//    public Map<String, FREFunction> getFunctions() {
//        Map<String, FREFunction> functionsToSet = new HashMap();
//        functionsToSet.put("init", new tmpInit());
//        functionsToSet.put("setAnalyticsCollectionEnabled", new tmpAVE());
//        return functionsToSet;
//    }

    private class tmpInit implements FREFunction {
        @Override
        public FREObject call(FREContext freContext, FREObject[] freObjects) {
            Log.d("firebase EOiN", "FUCK");
            Log.d("firebase EOiN", "FirebaseAnalytics before getInstance");
            try {
                Log.d("firebase EOiN", freContext.getActivity().getApplicationContext().getPackageCodePath());

                //trace("firebase name", FirebaseApp.getInstance()?.name)
                Log.d("firebase EOiN", "APP NAME" +  FirebaseApp.getInstance().getName());

                mFirebaseAnalytics = FirebaseAnalytics.getInstance(freContext.getActivity());
                if(mFirebaseAnalytics == null){
                    Log.d("firebase EOiN", "mFirebaseAnalytics NULL");
                }
                mFirebaseAnalytics.resetAnalyticsData();

            } catch (Exception e) {
                Log.e("firebase EOiN", e.getMessage());
                e.printStackTrace();
            }

            Log.d("firebase EOiN", "FirebaseAnalytics after getInstance");
            try {
                return FREObject.newObject(true);
            } catch (FREWrongThreadException e) {
                e.printStackTrace();
            }
            return null;
        }
    }

    @Override
    public void onActivityStateChanged(AndroidActivityWrapper.ActivityState activityState) {
        super.onActivityStateChanged(activityState);
        Log.d("firebase EOiN", "activityState: " + String.valueOf(activityState));
        switch (activityState) {
            case STARTED:
                this.controller.onStarted();
                break;
            case RESTARTED:
                this.controller.onRestarted();
                break;
            case RESUMED:
                this.controller.onResumed();
                break;
            case PAUSED:
                this.controller.onPaused();
                break;
            case STOPPED:
                this.controller.onStopped();
                break;
            case DESTROYED:
                this.controller.onDestroyed();
                break;
        }
    }

    @Override
    public void dispose() {
        super.dispose();
        if (aaw != null) {
            aaw.removeActivityResultListener(this);
            aaw.removeActivityStateChangeListner(this);
            aaw = null;
        }
    }

    private class tmpAVE implements FREFunction {
        @Override
        public FREObject call(FREContext freContext, FREObject[] freObjects) {
            mFirebaseAnalytics.setAnalyticsCollectionEnabled(true);
            return null;
        }
    }
}
