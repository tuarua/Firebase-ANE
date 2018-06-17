package com.tuarua.firebase;

import com.tuarua.frekotlin.FreKotlinContext;
import com.tuarua.frekotlin.FreKotlinMainController;

public class FirebaseANEContext extends FreKotlinContext{
    FirebaseANEContext(String name, FreKotlinMainController controller, String[] functions) {
        super(name, controller, functions);
    }

    @Override
    public void dispose() {
        super.dispose();
    }

}
