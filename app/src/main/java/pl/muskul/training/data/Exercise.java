package pl.muskul.training.data;

public class Exercise {
    String name;
    protected Exercise(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }
}
