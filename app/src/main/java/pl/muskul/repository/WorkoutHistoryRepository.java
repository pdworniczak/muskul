package pl.muskul.repository;

import static pl.muskul.repository.db.DBContract.WORKOUT_HISTORY;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.ArrayList;
import java.util.List;

import pl.muskul.repository.model.WorkoutHistory;
import pl.muskul.repository.db.DBContract;
import pl.muskul.repository.db.DBHelper;
import pl.muskul.training.data.TrainingType;

public class WorkoutHistoryRepository {
    private final DBHelper dbHelper;

    public WorkoutHistoryRepository(Context context) {
        this.dbHelper = new DBHelper(context);
    }

    public void insert(WorkoutHistory workout) {
        ContentValues values = new ContentValues();
        values.put(DBContract.Columns.DATE, workout.getDate());
        values.put(DBContract.Columns.LENGTH, workout.getLength());
        values.put(DBContract.Columns.WORKOUT, workout.getType().name());

        insertInto(WORKOUT_HISTORY.tableName(), values);
    }

    public List<WorkoutHistory> getAll() {
        return fetchList(WORKOUT_HISTORY.tableName(), DBContract.Columns.DATE + " DESC", this::mapToWorkout);
    }

    private void insertInto(String tableName, ContentValues values) {
        try (SQLiteDatabase db = dbHelper.getWritableDatabase()) {
            db.insert(tableName, null, values);
        }
    }

    private <T> List<T> fetchList(String table, String orderBy, CursorMapper<T> mapper) {
        List<T> result = new ArrayList<>();
        try (SQLiteDatabase db = dbHelper.getReadableDatabase();
             Cursor cursor = db.query(table, null, null, null, null, null, orderBy)) {
            if (cursor != null && cursor.moveToFirst()) {
                do {
                    result.add(mapper.map(cursor));
                } while (cursor.moveToNext());
            }
        }
        return result;
    }

    private WorkoutHistory mapToWorkout(Cursor cursor) {
        return new WorkoutHistory(
                cursor.getLong(cursor.getColumnIndexOrThrow(DBContract.Columns.DATE)),
                cursor.getLong(cursor.getColumnIndexOrThrow(DBContract.Columns.LENGTH)),
                TrainingType.valueOf(cursor.getString(cursor.getColumnIndexOrThrow(DBContract.Columns.WORKOUT)))
        );
    }

    @FunctionalInterface
    private interface CursorMapper<T> {
        T map(Cursor cursor);
    }
}
