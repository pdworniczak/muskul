package pl.muskul;

import android.os.Bundle;
import android.os.CountDownTimer;
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

import pl.muskul.training.data.ExerciseStatus;
import pl.muskul.training.data.TimeExercise;
import pl.muskul.training.data.Training;
import pl.muskul.training.model.ExerciseStatusViewModel;
import pl.muskul.training.model.TrainingViewModel;


public class TimeTraining extends Fragment {

    private TrainingViewModel trainingViewModel;
    private ExerciseStatusViewModel statusViewModel;
    private int currentExerciseIndex = 0;

    public TimeTraining() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        trainingViewModel = new ViewModelProvider(requireActivity()).get(TrainingViewModel.class);
        statusViewModel = new ViewModelProvider(requireActivity()).get(ExerciseStatusViewModel.class);
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
            TimeExercise exercise = (TimeExercise) training.getTrainingExercises().get(currentExerciseIndex);

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
                    (new CountDownTimer(exercise.getTime() * 1000, 1000) {
                        @Override
                        public void onTick(long millisUntilFinished) {
                            exerciseTimeText.setText(String.valueOf(millisUntilFinished / 1000));
                        }

                        public void onFinish() {
                            if (currentExerciseIndex == training.getTrainingExercises().size()) {
                                statusViewModel.setStatus(ExerciseStatus.FINISHED);
                            } else {
                                statusViewModel.setStatus(ExerciseStatus.REST);
                            }
                        }
                    }).start();
                    break;
                }
                case REST: {
                    exerciseTimeText.setText(String.valueOf(training.getRestTime()));
                    (new CountDownTimer(training.getRestTime() * 1000, 1000) {
                        @Override
                        public void onTick(long millisUntilFinished) {
                            exerciseNameText.setText("Odpoczynek");
                            exerciseTimeText.setText(String.valueOf(millisUntilFinished / 1000));
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
                case FINISHED: {
                    NavHostFragment.findNavController(this).navigate(R.id.select_training);
                }
            }
        });
    }
}