const fs = require('fs');
const path = require('path');
const db = require('./config/database');

const migrate = async () => {
  const migrationPath = path.join(__dirname, 'migrations');
  const files = fs.readdirSync(migrationPath);

  for (const file of files) {
    if (file.endsWith('.sql')) {
      const sql = fs.readFileSync(path.join(migrationPath, file), 'utf-8');
      console.log(`Applying migration: ${file}`);
      await db.query(sql);
    }
  }

  console.log('All migrations applied successfully.');
};

migrate().catch((err) => {
  console.error('Migration failed:', err);
});
