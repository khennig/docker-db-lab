package db.testdata;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

public class V0001_0003__Testdata extends BaseJavaMigration {

    @Override
    public void migrate(Context context) throws Exception {
        try (PreparedStatement insert = context.getConnection().prepareStatement(
            "insert into kunde(id, vorname, nachname) values(?, ?, ?)")) {
            for (int i = 6; i < 1000; i++) {
                insert.setLong(1, i);
                insert.setString(2, "vorname_" + i);
                insert.setString(3, "nachname_" + i);
                insert.execute();
            }
        } catch (SQLException exc) {
            throw new RuntimeException("Failed to migrate: " + exc.getMessage());
        }
    }
}
