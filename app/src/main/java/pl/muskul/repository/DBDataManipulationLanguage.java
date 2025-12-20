package pl.muskul.repository;

import java.text.MessageFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import pl.muskul.training.data.Training;

public final class DBDataManipulationLanguage {
    public static final String insertWorkoutHistory(Training training, LocalDateTime startDate, LocalDateTime endDate) {
        return MessageFormat.format("""
                 INSERT INTO {0} (date, length, workout) VALUES ({1}, {2}, {3});
                """, WorkoutHistory.TABLE_NAME, training.getName(), startDate.atZone(ZoneId.of("CET")).toInstant().toEpochMilli(), Duration.between(startDate, endDate).toMillis());
    }
}
