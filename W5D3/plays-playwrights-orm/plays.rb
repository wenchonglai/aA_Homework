require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Play
  attr_accessor :id, :title, :year, :playwright_id

  def self.all
    plays = PlayDBConnection.instance.execute('SELECT * FROM plays')
    plays.map{|play| Play.new(play)}
  end

  def self.find_by_title(title)
    plays = PlayDBConnection.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        plays
      WHERE
        title = ?
    SQL

    first = plays.first
    first && Play.new(first)
  end

  def self.find_all_by_playwright(name)
    plays = PlayDBConnection.instance.execute(<<-SQL, name)
      SELECT plays.*
      FROM plays
      JOIN playwrights ON playwrights.id = plays.playwright_id
      WHERE name = ?
    SQL

    plays.map{|play| Play.new(play)}
  end

  def self.find_by_playwright(name)
    self.find_all_by_playwright(name).first
  end

  def initialize(play)
    @id = play["id"]
    @title = play["title"]
    @year = play["year"]
    @playwright_id = play["playwright_id"]
  end

  def create
    raise "#{play} already exists" if @id

    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
      INSERT INTO
        plays(title, year, playwright_id)
      VALUES
        (?, ?, ?);
    SQL
    
    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{play} missing" unless @id

    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id, @id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ?
      WHERE
        id = ?
    SQL
  end

  def delete
    raise "#{play} missing" unless @id

    PlayDBConnection.instance.execute(<<-SQL, @id)
      DELETE FROM
        plays
      WHERE
        id = ?
    SQL

    @id = nil
  end
end

class Playwright
  attr_accessor :id, :name, :birth_year
  def self.all
    playwrights = PlayDBConnection.instance.execute("SELECT * FROM playwrights")
    playwrights.map{|playwright| Playwright.new(playwright)}
  end

  def self.find_by_name(name)
    playwrights = PlayDBConnection.instance.execute(<<-SQL, name)
      SELECT * FROM playwrights WHERE name = ?
    SQL

    playwrights.first && Playwright.new(playwrights.first)
  end

  def initialize(playwright)
    @id = playwright["id"]
    @name = playwright["name"]
    @birth_year = playwright["birth_year"]
  end

  def create
    raise "#{self} already exists" if @id

    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year)
      INSERT INTO playwrights(name, birth_year)
      VALUES
        (?, ?)
    SQL

    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} does not exist" unless @id

    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year, @id)
      UPDATE
        playwrights
      SET
        name = ?, birth_year = ?
      WHERE
        id = ?
    SQL
  end

  def delete
    PlayDBConnection.instance.execute(<<-SQL, @id)
      DELETE FROM playwrights
      WHERE id = ?
    SQL

    @id = nil
  end

  def get_plays
    plays = PlayDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        plays
      WHERE
        playwright_id = ?
    SQL

    plays.map{|play| Play.new(play)}
  end
end

if __FILE__ == $PROGRAM_NAME
  p Play.all
  puts '---'
  p Play.find_by_title('Le Fils naturel')
  puts '---'
  p Play.find_by_playwright('Victor Hugo')
  puts '---'
  p Playwright.all
  puts '---'
  p Playwright.find_by_name('Victor Hugo').get_plays
  puts '---'
  cromwell = Playwright.find_by_name('Victor Hugo').get_plays.first
  cromwell.year = 1826
  p Play.all
  puts '---'
  cromwell.update
  p Play.all
  puts '---'
  cromwell.delete
  p Play.all
  puts '---'
  cromwell.create
  p Play.all
  puts '---'
  hugo = Playwright.find_by_name('Victor Hugo')
  hugo.name = "Victor Marie Hugo"
  hugo.update
  p Playwright.all
  puts '---'
  hugo.name = "Victor Hugo"
  hugo.update
  p Playwright.all
  puts '---'
  dumas_pere = Playwright.new("name" => "Dumas Père", "birth_year" => 1802)
  dumas_pere.create
  p Playwright.all
  puts '---'
  dumas_pere.delete
  p Playwright.all
end
