package tools.vitruv.framework.change.recording

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data
import tools.vitruv.framework.change.echange.EChange

/**
 * Lightweight utility class that can be used to track certain changes
 * statically and document which reactions are responsible for them.
 */
class ChangeOriginTracker {
    static val String CORRESPONDENCE = "Correspondence"
    static val String MIR = "mir.r" // mir reaction or routine
    static val String DOLLAR = "$" // generated generic methods
    static val String FACADE = ".RoutinesFacade." // unwanted facade lines
    @Accessors static val List<ChangeSequence> trackedChangeSequences = new ArrayList
    @Accessors static boolean trackingEnabled = false
    @Accessors static boolean autoPrintNewChanges = false

    /**
     * Reports a change sequence, if tracking is enabled. The change sequence is matched with the correlating reactions stack.
     */
    def static report(Iterable<EChange> changes) {
        if (trackingEnabled) {
            val reactionsStackTrace = Thread.currentThread.stackTrace.filter [
                toString.contains(MIR) && !toString.contains(DOLLAR) && !toString.contains(FACADE)
            ]
            val topic = TransformationType.values.findFirst[reactionsStackTrace.toString.contains(it.getIndicator)]
            trackedChangeSequences += new ChangeSequence(topic, changes.toList, reactionsStackTrace.toList)
            if (autoPrintNewChanges && !trackedChangeSequences.last.isCorrespondence)
                printLatest
        }
    }

    /**
     * Convenience method to clear all changes, enable tracking and auto-printing.
     * @see ChangeOriginTracker#clear()
     */
    def static enable() {
        clear
        trackingEnabled = true
        autoPrintNewChanges = true
    }

    /**
     * Clears the tracked change sequences. This means all previously tracked data is lost.
     */
    def static clear() {
        trackedChangeSequences.clear
    }

    /** 
     * Prints all change sequences.
     */
    def static printAll() {
        trackedChangeSequences.forEach[System.err.println(it)]
    }

    /**
     * Prints the latest change sequence that has been reported.
     */
    def static printLatest() {
        if (!trackedChangeSequences.empty) {
            System.err.println(trackedChangeSequences.last)
        }
    }

    /** 
     * Prints all change sequences that do not mention correspondence model changes.
     */
    def static printNonCorrespondence() {
        trackedChangeSequences.filter[!it.isCorrespondence].forEach[System.err.println(it)]
    }

    /** 
     * Prints only the change sequences that mention correspondence model changes.
     */
    def static printOnlyCorrespondence() {
        trackedChangeSequences.filter[it.isCorrespondence].forEach[System.err.println(it)]
    }

    @Data
    static class ChangeSequence {
        TransformationType topic
        List<EChange> changes
        List<StackTraceElement> reactionStackTrace

        /**
         * Returns true if the the list of changes contains changes to the correspondence model.
         */
        def isCorrespondence() {
            changes.toString.contains(CORRESPONDENCE)
        }

        // Creates a slightly adapted string representation compared to the @Data one
        override toString() '''
            «class.simpleName» by «topic» [
                CHANGES:
                    «FOR change : changes»
                        «change»
                    «ENDFOR»
                «IF !reactionStackTrace.empty»
                    REACTION STACK TRACE:
                        «FOR element : reactionStackTrace»
                            «element»
                        «ENDFOR»
                «ENDIF»
            ]
        '''
    }
}
