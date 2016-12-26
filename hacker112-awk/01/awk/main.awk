#!/usr/bin/awk -f
function updateDirection (increment) {
	dir = (4 + dir + increment) % 4
}

function coordinate(lat, lng) {
	return "(" lat ", " lng ")"
}

function saveVisitedCoordinate (lat, lng) {
	coord=coordinate(lat,lng)
	if(!foundDoubleVisitedCoordinate && coordinates[coord])
	{
		foundDoubleVisitedCoordinate = 1
		dblVisitCoordLat = lat
		dblVisitCoordLng = lng
	}
	coordinates[coord] = 1
}

function abs(v) {
	return v < 0 ? -v : v
}
function blocksAway(lat, lng) {
	return abs(lat) + abs(lng)
}

BEGIN { 
	RS=","
	# 
	# Directions
	# 
	# 0 = North
	# 1 = East
	# 2 = South
	# 3 = West
	dir=0
	# 
	# Latitude
	#
	# Positive North
	# Negative South
	lat=0
	#
	# Longitude
	#
	# Positive East
	# Negative West
	lng=0

	foundDoubleVisitedCoordinate=0
	dblVisitCoordLat=0
	dblVisitCoordLng=0

	saveVisitedCoordinate(lat, lng)
}
/L/ {
	updateDirection(-1)
}

/R/ {
	updateDirection(1)
}
{
	# Adding 0 is required to convert the number-string to a number.
	steps = substr($0,2) + 0

	if (dir == 0) 
	{
		# North
		for(i = 0; i < steps; i++)
		{
			lat += 1
			saveVisitedCoordinate(lat, lng)
		}
	}
	else if (dir == 1)
	{
		# East
		for(i = 0; i < steps; i++)
		{
			lng += 1
			saveVisitedCoordinate(lat, lng)
		}
	}
	else if (dir == 2)
	{
		# South
		for(i = 0; i < steps; i++)
		{
			lat -= 1
			saveVisitedCoordinate(lat, lng)
		}
	}
	else if (dir == 3)
	{
		# West
		for(i = 0; i < steps; i++)
		{
			lng -= 1
			saveVisitedCoordinate(lat, lng)
		}
	}
	else 
	{
		print "Error"
	}
}

END {

	if(foundDoubleVisitedCoordinate)
	{
		dblVisitCoord = coordinate(dblVisitCoordLat, dblVisitCoordLng)
		print "Coordinate visited first twice: " dblVisitCoord
		print blocksAway(dblVisitCoordLat, dblVisitCoordLng) " blocks away"
		print ""
	}

	print "Ended at Lat/long=" coordinate(lat, lng)
	print blocksAway(lat, lng) " blocks away"
}
