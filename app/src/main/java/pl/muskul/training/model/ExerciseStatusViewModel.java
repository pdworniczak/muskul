package pl.muskul.training.model;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import pl.muskul.training.data.ExerciseStatus;

public class ExerciseStatusViewModel extends ViewModel {
    private final MutableLiveData<ExerciseStatus> status = new MutableLiveData<>();

    public LiveData<ExerciseStatus> getStatus() {
        return status;
    }

    public void setStatus(ExerciseStatus newStatus) {
        status.setValue(newStatus);
    }
}