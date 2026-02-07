package pl.muskul.repository.db;

public enum DBContract {
    WORKOUT_HISTORY("workout_history");

    private final String tableName;

    DBContract(String tableName) {
        this.tableName = tableName;
    }

    public String tableName() {
        return tableName;
    }

    public static final class Columns {
        public static final String ID = "id";
        public static final String DATE = "date";
        public static final String LENGTH = "length";
        public static final String WORKOUT = "workout";

        private Columns() {}
    }
}