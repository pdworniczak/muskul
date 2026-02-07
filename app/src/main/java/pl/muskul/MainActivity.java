package pl.muskul;

import android.os.Bundle;


import androidx.appcompat.app.AppCompatActivity;

import androidx.lifecycle.ViewModelProvider;

import pl.muskul.databinding.ActivityMainBinding;
import pl.muskul.training.TrainingService;
import pl.muskul.training.data.Training;
import pl.muskul.training.data.TrainingType;
import pl.muskul.training.model.TrainingViewModel;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private TrainingService trainingService;
    private TrainingViewModel trainingViewModel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        trainingService = new TrainingService();
        trainingViewModel = new ViewModelProvider(this).get(TrainingViewModel.class);
    }

    public void getTraining(TrainingType trainingType) {
        Training training = trainingService.getTraining(trainingType);

        trainingViewModel.setData(training);
    }
}