#!/usr/bin/env ruby

require_relative './config/boot'


puts <<DESCRIPTION
Description:

1. The distance of the route A-B-C.
2. The distance of the route A-D.
3. The distance of the route A-D-C.
4. The distance of the route A-E-B-C-D.
5. The distance of the route A-E-D.
6. The number of trips starting at C and ending at C with a maximum of 3 stops.  In the sample data below, there are two such trips: C-D-C (2 stops). and C-E-B-C (3 stops).
7. The number of trips starting at A and ending at C with exactly 4 stops.  In the sample data below, there are three such trips: A to C (via B,C,D); A to C (via D,C,D); and A to C (via D,E,B).
8. The length of the shortest route (in terms of distance to travel) from A to C.
9. The length of the shortest route (in terms of distance to travel) from B to B.
10.The number of different routes from C to C with a distance of less than 30.  In the sample data, the trips are: CDC, CEBC, CEBCDC, CDCEBC, CDEBC, CEBCEBC, CEBCEBCEBC
DESCRIPTION


puts
puts "Output:"
puts

routes = %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7).map { |str| Route.new(*str.each_char.to_a) }
stop_map = StopMap.new(*routes)

['ABC', 'AD', 'ADC', 'AEBCD', 'AED'].each do |stops|
  if routes = stop_map.get_routes_by_path_stops(stops)
    puts Path.new(*routes).distance
  else
    puts 'NO SUCH ROUTE'
  end
end

puts stop_map.relation_of('C', 'C').where(max_routes_count: 3).count
puts stop_map.relation_of('A', 'C').where(routes_count: 4).count
puts stop_map.relation_of('A', 'C').where(shortest: true).first.distance
puts stop_map.relation_of('B', 'B').where(shortest: true).first.distance
puts stop_map.relation_of('C', 'C').where(max_distance: 30).count

puts
puts 'You may want get other answers by this script:'

puts
puts 'The sortest route from C to C with a distance of less than 30:'
puts stop_map.relation_of('C', 'C').where(max_distance: 30, shortest: true)

puts
puts 'The routes from C to C with a distance of less than 30 and exactly 4 stops:'
puts stop_map.relation_of('C', 'C').where(max_distance: 30, routes_count: 5)

puts
puts 'The routes from C to C with a distance of less than 30 and exactly 7 stops:'
puts stop_map.relation_of('C', 'C').where(max_distance: 30).where(routes_count: 7)
