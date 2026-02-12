package pl.muskul;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.navigation.fragment.NavHostFragment;

import java.time.Instant;
import java.time.ZoneId;

import pl.muskul.repository.WorkoutHistoryRepository;

public class TrainingHistory extends Fragment {
    private WorkoutHistoryRepository workoutHistoryRepository;

    public TrainingHistory() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        workoutHistoryRepository = new WorkoutHistoryRepository(requireContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_training_history, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        initView(view);
    }

    private void initView(View view) {
        ListView listView = view.findViewById(R.id.training_list);
        listView.setAdapter(new ArrayAdapter<>(getContext(), android.R.layout.simple_list_item_1, workoutHistoryRepository.getAll().stream().map(workout -> String.format("%s: trening %s", Instant.ofEpochMilli(workout.getDate()).atZone(ZoneId.systemDefault()).toLocalDate(), workout.getType())).toList()));
        Button backButton = view.findViewById(R.id.back);
        backButton.setOnClickListener(v -> NavHostFragment.findNavController(this).navigate(R.id.training_navigation));

    }
}