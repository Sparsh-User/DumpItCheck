/**
 * Base trigger framework class. Object handlers extend this class and
 * override only the lifecycle methods they need.
 */
public virtual class TriggerHandler {

    private static Map<String, Integer> loopCounts = new Map<String, Integer>();
    private static Set<String> bypassedHandlers = new Set<String>();

    @TestVisible
    private System.TriggerOperation context;

    public TriggerHandler() {
        this.context = Trigger.operationType;
    }

    /** Entry point called from the trigger. */
    public void run() {
        if (!validateRun()) {
            return;
        }
        switch on this.context {
            when BEFORE_INSERT { this.beforeInsert(); }
            when BEFORE_UPDATE { this.beforeUpdate(); }
            when BEFORE_DELETE { this.beforeDelete(); }
            when AFTER_INSERT { this.afterInsert(); }
            when AFTER_UPDATE { this.afterUpdate(); }
            when AFTER_DELETE { this.afterDelete(); }
            when AFTER_UNDELETE { this.afterUndelete(); }
        }
    }

    public static void bypass(String handlerName) {
        bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return bypassedHandlers.contains(handlerName);
    }

    private Boolean validateRun() {
        if (this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        return !bypassedHandlers.contains(getHandlerName());
    }

    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}

    public class TriggerHandlerException extends Exception {}
}
