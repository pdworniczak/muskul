package pl.muskul.training;

import java.util.Arrays;
import java.util.List;

import pl.muskul.training.data.RepsExercise;
import pl.muskul.training.data.TimeExercise;
import pl.muskul.training.data.Training;
import pl.muskul.training.data.TrainingType;
import pl.muskul.training.data.TrainingFormat;

public class TrainingConfiguration {
    public static final Training CHEST_TRAINING;
    public static final Training CORE_TRAINING;
    public static final Training STRECH_TRAINING;

    static {
        CHEST_TRAINING = new Training("Trening klatki piersiowej", TrainingFormat.REPS, TrainingType.CHEST, 30, List.of(
                new RepsExercise("Pompki z dłońmi na podniesieniu", 14),
                new RepsExercise("Pompki na kolanach", 12),
                new RepsExercise("Pompki", 10),
                new RepsExercise("Pompki z szerokim rozstawem dłoni", 10),
                new RepsExercise("Pompki z dłońmi na podniesieniu", 12),
                new RepsExercise("Pompki na kolanach", 12),
                new RepsExercise("Pompki z szerokim rozstawem dłoni", 10),
                new RepsExercise("Pompki hindu", 10)
        ));

        CORE_TRAINING = new Training("Traning mięśni brzucha", TrainingFormat.REPS, TrainingType.CORE, 30,
                Arrays.asList(
                        new RepsExercise("Brzuszki z rękoma do przodu", 14),
                        new RepsExercise("Skręty w bok", 20),
                        new RepsExercise("Przyciagnie nogi w podporze", 20),
                        new RepsExercise("Naprzemienne sięganie do kostek", 20),
                        new RepsExercise("Unoszenie nóg w leżeniu tyłem", 16),
                        new RepsExercise("Brzuszki z rękoma do przodu", 16),
                        new RepsExercise("Rosyjski twist", 32),
                        new RepsExercise("Przyciagnie nogi w podporze", 20),
                        new RepsExercise("Naprzemienne sięganie do kostek", 20),
                        new RepsExercise("Unoszenie nóg w leżeniu tyłem", 14)
                ));

        STRECH_TRAINING = new Training("Rozciąganie", TrainingFormat.TIME, TrainingType.STRETCH, 15, Arrays.asList(
                new TimeExercise("Pozycja kobry", 30),
                new TimeExercise("Pozycja dziecka", 30),
                new TimeExercise("Pozycja krowy", 30),
                new TimeExercise("Pozycja kota", 30),
                new TimeExercise("Skłony do kostek siedząc", 120),
                new TimeExercise("Pozycja lotosu", 120),
                new TimeExercise("Wykrok w bok lewy", 45),
                new TimeExercise("Wykrok w bok prawy", 45),
                new TimeExercise("Wykrok w przód lewą nogą", 45),
                new TimeExercise("Wykrok w przód prawą nogą", 45),
                new TimeExercise("Skłon", 120),
                new TimeExercise("Szpagat", 120)

        ));
    }
}
