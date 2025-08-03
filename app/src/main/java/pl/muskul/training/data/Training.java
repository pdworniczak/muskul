package pl.muskul.training.data;

import java.util.List;

public class Training {
    private String name;
    private TrainingType trainingType;
    private TrainingArea trainingArea;
    private Integer restTime;
    private List<Exercise> trainingSession;
    public Training(String name, TrainingType trainingType, TrainingArea trainingArea, Integer restTime, List<Exercise> trainingSession) {
        this.name = name;
        this.trainingType = trainingType;
        this.trainingArea = trainingArea;
        this.restTime = restTime;
        this.trainingSession = trainingSession;
    }

    public String getName() {
        return name;
    }

    public TrainingType getTrainingType() {
        return trainingType;
    }

    public TrainingArea getTrainingArea() {
        return trainingArea;
    }

    public Integer getRestTime() {
        return restTime;
    }

    public List<Exercise> getTrainingSession() {
        return trainingSession;
    }
}
