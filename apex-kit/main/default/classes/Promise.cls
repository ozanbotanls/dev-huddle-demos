/**
 * @description This class provides an implementation of the Promise
 * pattern. The promise pattern allows developers to have asynchronous
 * flow control without the need to handle callbacks. Developers will
 * extend this class, implementing the necessary `execute` method.
 * The contents of your execute method will be executed asynchronously.
 * Using the `then` method of this class, you can construct chains of
 * asynchronous operations. As each 'step' of the chain is completed
 * the transaction finalizer will be constructed with the remaining
 * steps and any passthrough data you specify. Passthrough data allows
 * you to pass data between steps.
 */
public abstract class Promise implements Queueable, Database.AllowsCallouts {
    protected List<Promise> promises = new List<Promise>();
    protected Object passthrough;

    public Promise then(object toAdd) {
        promises.add((Promise) toAdd);
        return this;
    }

    abstract public void execute();

    public void execute(QueueableContext context) {
        // invoke the abstract method `execute`. see the comment above.
        execute();
        // create a new instance of the finalizer class.
        // note that we're passing in the list of promises and the passthrough data.
        Finalizer chain = new Chain(this.promises, this.passthrough);
        // Attach the finalizer to system context. This will take care
        // of enqueueing the next promise in the chain.
        System.attachFinalizer(chain);
    }

    public class Chain implements Finalizer {
        private Promise[] promises;
        private Object passthrough;

        public Chain(Promise[] promises, Object passthrough) {
            this.promises = promises;
            this.passthrough = passthrough;
        }

        public void execute(System.FinalizerContext context) {
            Id parentQueueableJobId = context.getAsyncApexJobId();
            switch on context.getResult() {
                when SUCCESS {
                    if (this.promises.size() > 0) {
                        Promise next = this.promises.remove(0);
                        next.promises = this.promises;
                        next.passthrough = passthrough;
                        System.enqueueJob(next);
                    }
                }
                when UNHANDLED_EXCEPTION {
                    System.debug(context.getException());
                    System.debug('Parent Queueable (Job ID: ' + parentQueueableJobId + '): FAILED!');
                }
            }
        }
    }
}
