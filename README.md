# Vitruv Debugging Tools
Tools for debugging the change propagation when using the Vitruv framework.

### The Change Origin Tracker
The [ChangeOriginTracker](https://github.com/tsaglam/Vitruv-DebugTools/blob/master/src/tools/vitruv/framework/change/recording/ChangeOriginTracker.xtend) allows tracking the changes made by the reactions and routines of the change propagation specifications.

 1. Clone this repository and import the project into your working Vitruv workspace.
 2. Add the hook for the ChangeOriginTracker in the class [NotificationRecorder](https://github.com/vitruv-tools/Vitruv/blob/master/bundles/framework/tools.vitruv.framework.change/src/tools/vitruv/framework/change/recording/NotificationRecorder.xtend) in the method `notifyChanged(Notification notification)`:
 
```java
override notifyChanged(Notification notification) {
    // [...]
    if (!newChanges.empty) {
        ChangeOriginTracker.report(newChanges) // <-- Add this line
        // [...]
    }
}
```
 3. Add the required bundle `tools.vitruv.framework.debug` to the [manifest file](https://github.com/vitruv-tools/Vitruv/blob/master/bundles/framework/tools.vitruv.framework.change/META-INF/MANIFEST.MF) of the project `tools.vitruv.framework.change`. This is also required in the projects where you use change tracking.
 
 4. If using other domains than PCM, UML, or Java you might need to adapt the [TransformationType](https://github.com/tsaglam/Vitruv-DebugTools/blob/master/src/tools/vitruv/framework/change/recording/TransformationType.java)
 
 5. Enable and use the [ChangeOriginTracker](https://github.com/tsaglam/Vitruv-DebugTools/blob/master/src/tools/vitruv/framework/change/recording/ChangeOriginTracker.xtend) in test cases (or anywhere else):
 
```java
  ChangeOriginTracker.trackingEnabled = true
  // [...] make some changes here
  saveAndSynchronizeChanges(modelElement)
  ChangeOriginTracker.printNonCorrespondence
```
This should produce change information and the correlating reactions and routines that caused them. This information should look somewhat like this:
```java
ChangeSequence by PCM --> JAVA [
    CHANGES:
        CreateEObjectImpl (idAttributeValue: null, affectedEObject: java.NamespaceClassifierReferenceImpl@1841c0b1 (namespaces: []))
        InsertEReferenceImpl (affectedEObject: java.ClassImpl@543d5160 (name: TestComponentImpl) on feature "implements") (index: 1) (newValue: java.NamespaceClassifierReferenceImpl@1841c0b1 (namespaces: []), wasUnset: false)
        CreateEObjectImpl (idAttributeValue: null, affectedEObject: java.ClassifierReferenceImpl@3b0b1ee8)
        InsertEReferenceImpl (affectedEObject: java.NamespaceClassifierReferenceImpl@1841c0b1 (namespaces: []) on feature "classifierReferences") (index: 0) (newValue: java.ClassifierReferenceImpl@3b0b1ee8, wasUnset: false)
        ReplaceSingleValuedEReferenceImpl (affectedEObject: java.ClassifierReferenceImpl@3b0b1ee8 on feature "target") (isUnset: false) (newValue: java.InterfaceImpl@a43815 (name: TestInterface), wasUnset: false, oldValue: null)
    REACTION STACK TRACE:
        mir.routines.pcm2javaCommon.AddProvidedRoleRoutine.executeRoutine(AddProvidedRoleRoutine.java:119)
        mir.reactions.pcm2javaCommon.CreatedProvidedRoleReaction.executeReaction(CreatedProvidedRoleReaction.java:40)
]
```

When using `autoPrintNewChanges = true` I often need to separate the change origin tracker output from other log output. This can be done with the a regex like this one: `(?s)ChangeSequence by(.*?) \[(.*?)\n\]`
