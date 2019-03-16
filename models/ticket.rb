require_relative('../db/sql_runner')
require_relative('./film')
require_relative('./customer')

class Ticket
  attr_reader :id
  attr_accessor :customer_id, :film_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  # CRUD

  def save
    sql = 'INSERT INTO tickets (customer_id, film_id, screening_id) VALUES ($1, $2, $3) RETURNING id'
    values = [@customer_id, @film_id, @screening_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def self.all
    sql = 'SELECT * FROM tickets'
    return SqlRunner.run(sql).map {|ticket| Ticket.new(ticket)}
  end

  def self.find(id)
    sql = 'SELECT * FROM tickets WHERE id = $1'
    values = [id]
    ticket = SqlRunner.run(sql, values).first
    return Ticket.new(ticket) if ticket != nil
  end

  def update
    sql = 'UPDATE tickets SET (customer_id, film_id, screening_id) = ($1, $2, $3) WHERE id = $4'
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = 'DELETE FROM tickets WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql)
  end

  def self.delete_all
    sql = 'DELETE FROM tickets'
    SqlRunner.run(sql)
  end

  # Search

  def self.customer_ticket_count(customer_id)
    sql = 'SELECT * FROM tickets WHERE customer_id = $1'
    values = [customer_id]
    tickets = SqlRunner.run(sql, values)
    return tickets.count
  end
end
