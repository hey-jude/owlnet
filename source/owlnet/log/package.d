module owlnet.log;

import owlnet.task;
import core.time : TickDuration;

interface Logger
{
    /**
     * The build has started.
     */
    void buildStarted();

    /**
     * The build has ended.
     */
    void buildEnded(bool success, TickDuration duration);
}

interface TaskLogger
{
    /**
     * Called when a chunk of output is received from the task.
     */
    void output(in ubyte[] chunk);

    /**
     * Called when the task has failed. There will be no more output events
     * after this.
     */
    void failed(TickDuration duration, Exception e);

    /**
     * Called when the task has completed successfully. There will be no more
     * output events after this.
     */
    void succeeded(TickDuration duration);
}
