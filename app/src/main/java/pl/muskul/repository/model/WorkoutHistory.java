package pl.muskul.repository.model;

import pl.muskul.training.data.TrainingType;

public final class WorkoutHistory {
    private long date;
    private long length;
    private TrainingType type;

    public WorkoutHistory(long date, long length, TrainingType type) {
        this.date = date;
        this.length = length;
        this.type = type;
    }

    public long getDate() { return date; }
    public long getLength() { return length; }
    public TrainingType getType() { return type; }
}
