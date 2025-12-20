package pl.muskul.repository;

import android.content.Context;

public class WorkoutHistoryRepository {
    private final DBHelper dbHelper;

    public WorkoutHistoryRepository(Context context) {
        this.dbHelper = new DBHelper(context);
    }
}
