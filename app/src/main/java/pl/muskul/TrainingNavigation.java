package pl.muskul;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.navigation.fragment.NavHostFragment;

import java.util.List;

import pl.muskul.training.data.TrainingType;

public class TrainingNavigation extends Fragment {
    public TrainingNavigation() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_training_navigation, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        initListeners();
    }

    private void initListeners() {
        initSelectButton();
    }

    private void initSelectButton() {
        List.of(R.id.select_core_training, R.id.select_stretch_training).forEach(id -> {

            View button = getView().findViewById(id);
            button.setOnClickListener(v ->
                    handleSelectClick((String) getView().findViewById(id).getTag())
            );
        });

        View diaryButton = getView().findViewById(R.id.select_diary);
        diaryButton.setOnClickListener(v -> NavHostFragment.findNavController(this).navigate(R.id.diary));
    }

    private void handleSelectClick(String tag) {
        TrainingType trainingType = TrainingType.valueOf(tag);

        ((MainActivity) getActivity()).getTraining(trainingType);

        NavHostFragment.findNavController(this).navigate(R.id.stretch_training);
    }
}