require_relative('../db/sql_runner')
require 'pry'

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save
    sql = 'INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id'
    values = [@title, @price]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def self.all
    sql = 'SELECT * FROM films'
    return SqlRunner.run(sql).map {|film| Film.new(film)}
  end

  def self.find(id)
    sql = 'SELECT * FROM films WHERE id = $1'
    values = [id]
    film = SqlRunner.run(sql, values).first
    return Film.new(film) if film != nil
  end

  def update
    sql = 'UPDATE films SET (title, price) = ($1, $2) WHERE id = $3'
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = 'DELETE FROM films WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql)
  end

  def self.delete_all
    sql = 'DELETE FROM films'
    SqlRunner.run(sql)
  end

  # Search

  def customers
    sql = 'SELECT customers.* FROM customers INNER JOIN tickets ON tickets.customer_id = customers.id WHERE film_id = $1'
    values = [@id]
    return SqlRunner.run(sql, values).map {|customer| Customer.new(customer)}
  end

  def film_customer_count
    sql = 'SELECT * FROM tickets WHERE film_id = $1'
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.count
  end
end
