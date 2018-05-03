package com.tuarua.firebase.performance {
import com.tuarua.firebase.PerformanceANEContext;
import com.tuarua.fre.ANEError;

public class Trace {
    private var name:String;

    public function Trace(name:String) {
        this.name = name;
    }

    public function start():void {
        PerformanceANEContext.validate();
        var theRet:* = PerformanceANEContext.context.call("startTrace", name);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function stop():void {
        PerformanceANEContext.validate();
        var theRet:* = PerformanceANEContext.context.call("stopTrace", name);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function incrementCounter(counterName:String, by:int = 1):void {
        PerformanceANEContext.validate();
        var theRet:* = PerformanceANEContext.context.call("incrementCounter", name, counterName, by);
        if (theRet is ANEError) throw theRet as ANEError;
    }
}
}
