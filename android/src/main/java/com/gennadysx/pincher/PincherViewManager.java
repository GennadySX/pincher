package com.gennadysx.pincher;

import androidx.annotation.NonNull;

import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.bridge.ReactApplicationContext;

import javax.annotation.Nonnull;

public class PincherViewManager extends ViewGroupManager<PincherView> {
    private static final String REACT_CLASS = "PincherView";
    private static final float defaultMinimumZoomScale = 1.0f;
    private static final float defaultMaximumZoomScale = 3.0f;

    ReactApplicationContext mCallerContext;

    public PincherViewManager(ReactApplicationContext reactContext) {
        mCallerContext = reactContext;
    }

    @Override
    @NonNull
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public @Nonnull PincherView createViewInstance(@Nonnull ThemedReactContext ctx) {
        return new PincherView(ctx);
    }

    @ReactProp(name = "minimumZoomScale", defaultFloat = defaultMinimumZoomScale)
    public void setMinimumZoomScale(PincherView view, float minimumZoomScale) {
        view.setMinimumZoomScale(minimumZoomScale);
    }

    @ReactProp(name = "maximumZoomScale", defaultFloat = defaultMaximumZoomScale)
    public void setMaximumZoomScale(PincherView view, float maximumZoomScale) {
        view.setMaximumZoomScale(maximumZoomScale);
    }
}
