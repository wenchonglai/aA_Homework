DROP TABLE IF EXISTS plays;

CREATE TABLE plays(
	id INTEGER PRIMARY KEY,
	title TEXT NOT NULL,
	year INTEGER NOT NULL,
	playwright_id INTEGER NOT NULL,

	FOREIGN KEY (playwright_id) REFERENCES playwrights(id)
);

DROP TABLE IF EXISTS playwrights;

CREATE TABLE playwrights(
	id INTEGER PRIMARY KEY,
	name TEXT NOT NULL,
	birth_year INTEGER NOT NULL
);

INSERT INTO
	playwrights(name, birth_year)
VALUES
	('Victor Hugo', 1812),
	('Alexandre Dumas fils', 1802);

INSERT INTO
	plays(title, year, playwright_id)
VALUES
	('La dame aux camélias', 1848, (SELECT id FROM playwrights WHERE name = 'Alexandre Dumas fils')),
	('Le Fils naturel', 1848, (SELECT id FROM playwrights WHERE name = 'Alexandre Dumas fils')),
	('Cromwell', 1827, (SELECT id FROM playwrights WHERE name = 'Victor Hugo'));
