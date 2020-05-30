package tools.vitruv.framework.change.recording;

public enum TransformationType {

    JAVA_2_UML("javaToUml", "JAVA --> UML"),
    UML_2_JAVA("umlToJava", "UML --> JAVA"),
    PCM_2_JAVA("pcm2java", "PCM --> JAVA"),
    JAVA_2_PCM("java2Pcm", "JAVA --> PCM"),
    UML_2_PCM("reactions.uml", "UML --> PCM"),
    PCM_2_UML("reactions.pcm", "PCM --> UML"),
    MANUAL_INPUT("", "MANUAL USER INPUT");

    private final String indicator;

    private final String name;

    /**
     * Creates a transformation type for the changes.
     * @param indicator is the indicator in the stack trace for this transformation type.
     * @param name is the name of the transformation type.
     */
    private TransformationType(String indicator, String name) {
        this.indicator = indicator;
        this.name = name;
    }

    public String getIndicator() {
        return indicator;
    }

    @Override
    public String toString() {
        return name;
    }
}
