package pl.muskul.training.data;

public class TimeExercise extends Exercise {
    private int time;

    public TimeExercise(String name, int time) {
        super(name);
        this.time = time;
    }

    public int getTime() {
        return this.time;
    }
}
