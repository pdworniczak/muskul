package pl.muskul.training.model;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import pl.muskul.training.data.Training;

public class TrainingViewModel extends ViewModel {
    private final MutableLiveData<Training> trainingData = new MutableLiveData<>();

    public void setData(Training training) {
        trainingData.setValue(training);
    }

    public LiveData<Training> getData() {
        return trainingData;
    }
}
