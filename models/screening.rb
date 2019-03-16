require_relative('../db/sql_runner')

class Screening
  attr_reader :id
  attr_accessor :showtime, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @showtime = options['showtime']
    @film_id = options['film_id'].to_i
  end

  # CRUD

  def save
    sql = 'INSERT INTO screenings (showtime, film_id) VALUES ($1, $2) RETURNING id'
    values = [@showtime, @film_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def self.all
    sql = 'SELECT * FROM screenings'
    return SqlRunner.run(sql).map {|screening| Screening.new(screening)}
  end

  def self.find(id)
    sql = 'SELECT * FROM screenings WHERE id = $1'
    values = [id]
    screening = SqlRunner.run(sql, values).first
    return Screening.new(screening) if screening != nil
  end

  def update
    sql = 'UPDATE screenings SET (showtime, film_id) = ($1, $2) WHERE id = $3'
    values = [@showtime, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = 'DELETE FROM screenings WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql)
  end

  def self.delete_all
    sql = 'DELETE FROM screenings'
    SqlRunner.run(sql)
  end

  # Search

  def self.film_showtime_popularity(film_id)
    sql = 'SELECT showtime, COUNT(showtime) FROM screenings INNER JOIN tickets ON tickets.screening_id = screenings.id WHERE screenings.film_id = $1 GROUP BY showtime'
    values = [film_id]
    showtimes = SqlRunner.run(sql, values)
    most_popular = showtimes.max_by { |showtime| showtime['count'] }
    return most_popular['showtime']
  end
end
