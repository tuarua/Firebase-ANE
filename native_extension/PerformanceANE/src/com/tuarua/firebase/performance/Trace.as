package com.tuarua.firebase.performance {
import com.tuarua.firebase.PerformanceANEContext;
import com.tuarua.fre.ANEError;

public class Trace {
    private var name:String;

    /**
     * Creates a new Trace
     * @param name The name of the Trace.
     */
    public function Trace(name:String) {
        this.name = name;
    }

    /**
     * Creates an instance of FIRTrace after creating the shared instance of FIRPerformance. The trace
     * will automatically be started on a successful creation of the instance. The |name| of the trace
     * cannot be an empty string.
     */
    public function start():void {
        PerformanceANEContext.validate();
        var theRet:* = PerformanceANEContext.context.call("startTrace", name);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Stops the trace if the trace is active.
     */
    public function stop():void {
        PerformanceANEContext.validate();
        var theRet:* = PerformanceANEContext.context.call("stopTrace", name);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Increments the counter for the provided counter name by 1. If it is a new counter name, the
     * counter value will be initialized to 1. Does nothing if the trace has not been started or has
     * already been stopped.
     *
     * @param named
     * @param by
     */
    public function incrementMetric(named:String, by:int = 1):void {
        PerformanceANEContext.validate();
        var theRet:* = PerformanceANEContext.context.call("incrementCounter", name, named, by);
        if (theRet is ANEError) throw theRet as ANEError;
    }
}
}
