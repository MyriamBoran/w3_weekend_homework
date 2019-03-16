require 'pry'

require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

Ticket.delete_all
Film.delete_all
Customer.delete_all
Screening.delete_all


customer1 = Customer.new({
  'name' => 'Alana',
  'funds' => 40
  })
customer1.save

customer2 = Customer.new({
  'name' => 'Bradley',
  'funds' => 20
})
customer2.save


film1 = Film.new({
  'title' => 'Mr. Nobody',
  'price' => 8
})
film1.save

film2 = Film.new({
  'title' => 'Bohemian Rhapsody',
  'price' => 6
})
film2.save


screening1 = Screening.new({
  'showtime' => '22:00',
  'film_id' => film1.id
  })
screening1.save

screening2 = Screening.new({
  'showtime' => '20:00',
  'film_id' => film1.id
  })
screening2.save

screening3 = Screening.new({
  'showtime' => '20:00',
  'film_id' => film2.id
  })
screening3.save


ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film2.id,
  'screening_id' => screening3.id

  })
ticket1.save

ticket2 = Ticket.new({
  'customer_id' => customer2.id,
  'film_id' => film1.id,
  'screening_id' => screening1.id
})
ticket2.save

ticket3 = Ticket.new({
  'customer_id' => customer2.id,
  'film_id' => film1.id,
  'screening_id' => screening1.id
})
ticket3.save


customer1.buy_ticket(screening1.id)
customer1.buy_ticket(screening2.id)
Ticket.customer_ticket_count(customer1.id)
film1.film_customer_count
Screening.film_showtime_popularity(film1.id)


binding.pry
nil
