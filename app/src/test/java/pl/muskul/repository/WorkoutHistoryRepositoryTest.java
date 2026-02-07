package pl.muskul.repository;

import static org.junit.Assert.*;

import android.content.Context;

import androidx.test.core.app.ApplicationProvider;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

import java.util.List;

import pl.muskul.repository.WorkoutHistoryRepository;
import pl.muskul.repository.model.WorkoutHistory;
import pl.muskul.training.data.TrainingType;

@RunWith(RobolectricTestRunner.class)
public class WorkoutHistoryRepositoryTest {
    private WorkoutHistoryRepository repo;
    private Context ctx;

    @Before
    public void setUp() {
        ctx = ApplicationProvider.getApplicationContext();
        repo = new WorkoutHistoryRepository(ctx);
    }

    @Test
    public void insert_then_getAll_returnsInsertedRecord() {
        long now = System.currentTimeMillis();
        WorkoutHistory w = new WorkoutHistory(0L, now, 3600L, TrainingType.CORE);
        repo.insert(w);

        List<WorkoutHistory> all = repo.getAll();
        assertNotNull(all);
        assertFalse(all.isEmpty());

        WorkoutHistory first = all.get(0);
        assertEquals(now, first.getDate());
        assertEquals(3600L, first.getLength());
        assertEquals(TrainingType.CORE, first.getType());
        assertTrue(first.getId() > 0L); // generated id
    }

    @Test
    public void getAll_onEmptyDb_returnsEmptyList() {
        // Ensure DB is empty (you may need to clear table via DBHelper)
        List<WorkoutHistory> all = repo.getAll();
        assertNotNull(all);
        assert(all.isEmpty());
    }
}
