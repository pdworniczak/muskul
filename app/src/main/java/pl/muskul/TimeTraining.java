package pl.muskul;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.fragment.NavHostFragment;

import pl.muskul.repository.WorkoutHistoryRepository;
import pl.muskul.repository.model.WorkoutHistory;
import pl.muskul.training.data.ExerciseStatus;
import pl.muskul.training.data.TimeExercise;
import pl.muskul.training.data.Training;
import pl.muskul.training.model.ExerciseStatusViewModel;
import pl.muskul.training.model.TrainingViewModel;


public class TimeTraining extends Fragment {

    private WorkoutHistoryRepository workoutHistoryRepository;
    private TrainingViewModel trainingViewModel;
    private ExerciseStatusViewModel statusViewModel;
    private int currentExerciseIndex = 0;

    private final int INTERVAL = BuildConfig.DEBUG ? 10 : 1000;

    public TimeTraining() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        trainingViewModel = new ViewModelProvider(requireActivity()).get(TrainingViewModel.class);
        statusViewModel = new ViewModelProvider(requireActivity()).get(ExerciseStatusViewModel.class);
        workoutHistoryRepository = new WorkoutHistoryRepository(requireContext());
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
        TextView titleText = view.findViewById(R.id.title);
        TextView exerciseNameText = view.findViewById(R.id.exercise_name);
        TextView exerciseTimeText = view.findViewById(R.id.exercise_time);
        Button actionButton = view.findViewById(R.id.action_button);
        trainingViewModel.getData().observe(getViewLifecycleOwner(), training -> {
            if (training != null) {
                titleText.setText(training.getName());
                TimeExercise exercise = (TimeExercise) training.getTrainingExercises().get(this.currentExerciseIndex);
                exerciseNameText.setText(exercise.getName());
                exerciseTimeText.setText(String.valueOf(exercise.getTime()));
                statusViewModel.setStatus(ExerciseStatus.READY);
            }
        });

        statusViewModel.getStatus().observe(getViewLifecycleOwner(), status -> {
            Training training = trainingViewModel.getData().getValue();
            TimeExercise exercise = currentExerciseIndex >= training.getTrainingExercises().size() ? null : (TimeExercise) training.getTrainingExercises().get(currentExerciseIndex);

            if (status == ExerciseStatus.RUNNING || status == ExerciseStatus.REST) {
                requireActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
            } else {
                requireActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
            }

            switch (status) {
                case READY: {
                    actionButton.setText("Start");
                    break;
                }
                case RUNNING: {
                    exerciseNameText.setText(exercise.getName());
                    actionButton.setText("Zatrzymaj");
                    (new CountDownTimer(exercise.getTime() * INTERVAL, INTERVAL) {
                        @Override
                        public void onTick(long millisUntilFinished) {
                            exerciseTimeText.setText(String.valueOf(millisUntilFinished / INTERVAL));
                        }

                        public void onFinish() {
                            if (currentExerciseIndex + 1 == training.getTrainingExercises().size()) {
                                statusViewModel.setStatus(ExerciseStatus.FINISHED);

                                WorkoutHistory workoutHistory = new WorkoutHistory(System.currentTimeMillis(), exercise.getTime(), training.getTrainingType());
                                workoutHistoryRepository.insert(workoutHistory);
                            } else {
                                statusViewModel.setStatus(ExerciseStatus.REST);
                            }
                        }
                    }).start();
                    break;
                }
                case REST: {
                    exerciseTimeText.setText(String.valueOf(training.getRestTime()));
                    (new CountDownTimer(training.getRestTime() * INTERVAL, INTERVAL) {
                        @Override
                        public void onTick(long millisUntilFinished) {
                            exerciseNameText.setText("Odpoczynek");
                            exerciseTimeText.setText(String.valueOf(millisUntilFinished / INTERVAL));
                        }

                        @Override
                        public void onFinish() {
                            if (currentExerciseIndex >= training.getTrainingExercises().size()) {
                                statusViewModel.setStatus(ExerciseStatus.FINISHED);

                            } else {
                                currentExerciseIndex++;
                                statusViewModel.setStatus(ExerciseStatus.RUNNING);
                            }
                        }
                    }).start();
                    break;
                }
                case PAUSED: {
                    actionButton.setText("Wznów");
                    break;
                }
                case FINISHED: {
                    exerciseNameText.setText("Trening skonczony");
                    exerciseTimeText.setText("");
                    actionButton.setText("Powrót");
                }

            }
        });

        actionButton.setOnClickListener(v -> {
            switch (statusViewModel.getStatus().getValue()) {
                case READY: {
                    statusViewModel.setStatus(ExerciseStatus.RUNNING);
                    break;
                }
                case RUNNING: {
                    statusViewModel.setStatus(ExerciseStatus.PAUSED);
                    break;
                }
                case FINISHED: {
                    NavHostFragment.findNavController(this).navigate(R.id.training_navigation);
                }
            }
        });
    }
}