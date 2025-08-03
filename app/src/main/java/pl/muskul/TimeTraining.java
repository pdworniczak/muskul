package pl.muskul;

import android.graphics.Color;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import pl.muskul.training.data.Training;
import pl.muskul.training.model.TrainingViewModel;


public class TimeTraining extends Fragment {

    private TrainingViewModel trainingViewModel;

    public TimeTraining() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        trainingViewModel = new ViewModelProvider(requireActivity()).get(TrainingViewModel.class);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        return inflater.inflate(R.layout.fragment_time_training, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        initView(view);
    }

    private void initView(View view) {
        TextView title = view.findViewById(R.id.title);
        trainingViewModel.getData().observe(getViewLifecycleOwner(), training -> {
            if (training != null) {
                title.setText(training.getName());
            }
        });
    }
}