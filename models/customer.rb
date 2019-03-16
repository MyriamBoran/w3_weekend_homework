require_relative('../db/sql_runner')

class Customer
  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  # CRUD

  def save
    sql = 'INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id'
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def self.all
    sql = 'SELECT * FROM customers'
    return SqlRunner.run(sql).map {|customer| Customer.new(customer)}
  end

  def self.find(id)
    sql = 'SELECT * FROM customers WHERE id = $1'
    values = [id]
    customer = SqlRunner.run(sql, values).first
    return Customer.new(customer) if customer != nil
  end

  def update
    sql = 'UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3'
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = 'DELETE FROM customers WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql)
  end

  def self.delete_all
    sql = 'DELETE FROM customers'
    SqlRunner.run(sql)
  end

  # Search

  def films
    sql = 'SELECT films.* FROM films INNER JOIN tickets ON tickets.film_id = films.id WHERE customer_id = $1'
    values = [@id]
    return SqlRunner.run(sql, values).map {|film| Film.new(film)}
  end

  def buy_ticket(screening_id)
    screening = Screening.find(screening_id)
    if screening != nil
      film = Film.find(screening.film_id)
      @funds -= film.price
      Ticket.new({
        'customer_id' => @id,
        'film_id' => film.id,
        'screening_id' => screening.id
      }).save
    end
    return @funds
  end
end
