package pl.muskul.repository.model;

import pl.muskul.training.data.TrainingType;

public final class WorkoutHistory {
    private Long id;
    private long date;
    private long length;
    private TrainingType type;

    public WorkoutHistory(Long id, long date, long length, TrainingType type) {
        this.id = id;
        this.date = date;
        this.length = length;
        this.type = type;
    }

    public Long getId() { return id; }
    public long getDate() { return date; }
    public long getLength() { return length; }
    public TrainingType getType() { return type; }
}
