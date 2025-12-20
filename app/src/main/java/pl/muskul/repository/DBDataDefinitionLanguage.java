package pl.muskul.repository;

import java.text.MessageFormat;

public final class DBDataDefinitionLanguage {
    private DBDataDefinitionLanguage() {}

    public static final String createWorkoutHistory() {
        return MessageFormat.format("""
            CREATE TABLE {0} (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date INTEGER NOT NULL,
                length INTEGER NOT NULL,
                workout TEXT NOT NULL CHECK (workout IN ('STRETCH', 'CHEST', 'CORE')),
            )
        """, WorkoutHistory.TABLE_NAME );
    }
}
