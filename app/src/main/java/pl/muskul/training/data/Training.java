package pl.muskul.training.data;

import java.util.List;

public class Training {
    private String name;
    private TrainingFormat trainingFormat;
    private TrainingType trainingType;
    private Integer restTime;
    private List<Exercise> trainingExercises;
    public Training(String name, TrainingFormat trainingFormat, TrainingType trainingType, Integer restTime, List<Exercise> trainingExercises) {
        this.name = name;
        this.trainingFormat = trainingFormat;
        this.trainingType = trainingType;
        this.restTime = restTime;
        this.trainingExercises = trainingExercises;
    }

    public String getName() {
        return name;
    }

    public TrainingFormat getTrainingType() {
        return trainingFormat;
    }

    public TrainingType getTrainingArea() {
        return trainingType;
    }

    public Integer getRestTime() {
        return restTime;
    }

    public List<Exercise> getTrainingExercises() {
        return trainingExercises;
    }
}
