% Om Patel
% June 8, 2018
% Mr. Rosen
% This game is a driving simulator, made for my grade 9 ISP

import GUI % Imports the Graphical User Interface library

% Set up screen
setscreen ("offscreenonly")
setscreen ("nocursor")

% Global Variable Declaration Section
var mainWindow : int := Window.Open ("position:center;center,graphics:900;500") % Main window
var menuButton, instructionsButton, playGameButton, exitButton : int % GUI buttons
var carControl : int := Pic.Scale (Pic.FileNew ("ISP - Car.jpg"), 28, 28) % User car image
var controlx : int := 269 % User car x coordinate
var controly : int := 5 % User car y coordinate
var carx1, carx2, carx3, carx4 : int % Horizontal obstacle cars x coordinates
var cary1, cary2 : int % Horizontal obstacle cars y coordinates
var personx, persony : int % Pedestrian coordinates
% Decides whether the traffic lights are green or red
var light1 : int := Rand.Int (0, 2)
var light2 : int := Rand.Int (0, 2)
var light3 : int := Rand.Int (0, 2)
var light4 : int := Rand.Int (0, 2)
var lightColor1, lightColor2, lightColor3, lightColor4 : int % Traffic lights colors
var pedestrianLocation : int := Rand.Int (0, 3) % Decides which pedestrian will go
var carCollision, pedestrianCollision, redLight, offLane : boolean := false % Checks if user loses
var pedestrianCrossed : boolean := false % Checks if pedestrian crossed the road
var goalReached : boolean := false % Checks if user arrives home safely
var randColor : int % Randomly selects obstacle car colors

% This process loops the music
process music
    Music.PlayFileLoop ("Looney Tunes Theme Music.mp3") % Plays the music file
end music

% This is the title procedure
procedure title
    cls % Clears the screen
    locate (1, 49) % Locates text position
    put "Driving Simulator" ..
end title

% This procedure draws the vertially moving cars
procedure verticalCars
    drawfillbox (230, cary1, 258, cary1 + 29, 30) % Erase
    drawfillbox (230, cary1, 258, cary1 + 28, randColor) % Car
    drawfillbox (232, cary1, 236, cary1 + 2, 0) % Headlight
    drawfillbox (252, cary1, 256, cary1 + 2, 0) % Other headlight
    drawfillbox (605, cary2, 633, cary2 + 29, 30) % Erase
    drawfillbox (605, cary2, 633, cary2 + 28, randColor + 5) % Car
    drawfillbox (607, cary2, 611, cary2 + 2, 0) % Headlight
    drawfillbox (627, cary2, 631, cary2 + 2, 0) % Other headlight
    % Changes y coordinates so that cars move vertically
    cary1 := cary1 - 1
    cary2 := cary2 - 1
end verticalCars

% This procedure draws the horizontally moving cars
procedure horizontalCars
    drawfillbox (carx1 - 1, 336, carx1 + 27, 364, 30) % Erase
    drawfillbox (carx1, 336, carx1 + 28, 364, randColor) % Car
    drawfillbox (carx1 + 26, 338, carx1 + 28, 342, 0) % Headlight
    drawfillbox (carx1 + 26, 358, carx1 + 28, 362, 0) % Other headlight
    drawfillbox (carx2 - 1, 102, carx2 + 27, 130, 30) % Erase
    drawfillbox (carx2, 102, carx2 + 28, 130, randColor + 5) % Car
    drawfillbox (carx2 + 26, 104, carx2 + 28, 108, 0) % Headlight
    drawfillbox (carx2 + 26, 124, carx2 + 28, 128, 0) % Other headlight
    drawfillbox (carx3 + 1, 369, carx3 + 29, 397, 30) % Erase
    drawfillbox (carx3, 369, carx3 + 28, 397, randColor + 10) % Car
    drawfillbox (carx3, 371, carx3 + 2, 375, 0) % Headlight
    drawfillbox (carx3, 391, carx3 + 2, 395, 0) % Other headlight
    drawfillbox (carx4 + 1, 135, carx4 + 29, 163, 30) % Erase
    drawfillbox (carx4, 135, carx4 + 28, 163, randColor + 15) % Car
    drawfillbox (carx4, 137, carx4 + 2, 141, 0) % Headlight
    drawfillbox (carx4, 157, carx4 + 2, 161, 0) % Other headlight
    % Changes x coordinates so that cars move horizontally
    carx1 := carx1 + 1
    carx2 := carx2 + 1
    carx3 := carx3 - 1
    carx4 := carx4 - 1
end horizontalCars

% This procedure sets the color of the traffic lights
procedure trafficLights
    % Randomly selects if light is red or green (green is twice as likely as red)
    if light1 = 0 then
	lightColor1 := 12 % Changes light color to red
    elsif light1 = 1 or light1 = 2 then
	lightColor1 := 2 % Changes light color to green
    end if

    if light2 = 0 then
	lightColor2 := 12 % Changes light color to red
    elsif light2 = 1 or light2 = 2 then
	lightColor2 := 2 % Changes light color to green
    end if

    if light3 = 0 then
	lightColor3 := 12 % Changes light color to red
    elsif light3 = 1 or light3 = 2 then
	lightColor3 := 2 % Changes light color to green
    end if

    if light4 = 0 then
	lightColor4 := 12 % Changes light color to red
    elsif light4 = 1 or light4 = 2 then
	lightColor4 := 2 % Changes light color to green
    end if

    % Draws the traffic lights
    for i : 0 .. 9
	% Light 1
	drawoval (689, 416, i, i, lightColor1)
	drawoval (690, 416, i, i, lightColor1)
	drawoval (689, 417, i, i, lightColor1)
	% Light 2
	drawoval (314, 416, i, i, lightColor2)
	drawoval (315, 416, i, i, lightColor2)
	drawoval (314, 417, i, i, lightColor2)
	% Light 3
	drawoval (314, 182, i, i, lightColor3)
	drawoval (315, 182, i, i, lightColor3)
	drawoval (314, 183, i, i, lightColor3)
	% Light 4
	drawoval (689, 182, i, i, lightColor4)
	drawoval (690, 182, i, i, lightColor4)
	drawoval (689, 183, i, i, lightColor4)
    end for
end trafficLights

% This procedure selects which pedestrian will appear
procedure whichPedestrian
    pedestrianLocation := Rand.Int (0, 3) % Randomly selects a pedestrian location
    % Sets the pedestrian location (chooses from 4 locations)
    if pedestrianLocation = 0 then
	personx := 229 % Sets x coordinate
	persony := 92 % Sets y coordinate
    elsif pedestrianLocation = 1 then
	personx := 306 % Sets x coordinate
	persony := 398 % Sets y coordinate
    elsif pedestrianLocation = 2 then
	personx := 594 % Sets x coordinate
	persony := 102 % Sets y coordinate
    elsif pedestrianLocation = 3 then
	personx := 671 % Sets x coordinate
	persony := 326 % Sets y coordinate
    end if
end whichPedestrian

% This procedure moves the pedestrian
procedure pedestrianMovement
    drawfilloval (personx, persony, 5, 5, 30) % Erase
    drawfilloval (personx, persony, 4, 4, 7) % Pedestrian
    % Moves the pedestrian
    if pedestrianLocation = 0 then
	personx := personx + 1 % Moves pedestrian right
	if personx >= 296 then % Changes pedestrian location when pedestrian crosses road
	    pedestrianCrossed := true
	end if
    elsif pedestrianLocation = 1 then
	persony := persony - 1 % Moves pedestrian down
	if persony <= 336 then % Changes pedestrian location when pedestrian crosses road
	    pedestrianCrossed := true
	end if
    elsif pedestrianLocation = 2 then
	persony := persony + 1 % Moves pedestrian up
	if persony >= 164 then % Changes pedestrian location when pedestrian crosses road
	    pedestrianCrossed := true
	end if
    elsif pedestrianLocation = 3 then
	personx := personx - 1 % Moves pedestrian left
	if personx <= 604 then % Changes pedestrian location when pedestrian crosses road
	    pedestrianCrossed := true
	end if
    end if
end pedestrianMovement

% This is the game over procedure
procedure endGame
    % Displays message if user wins or loses
    if carCollision = true then
	Text.ColorBack (12) % Sets text background color
	title
	for i : 0 .. 900
	    drawline (i, 0, i, 480, 12) % Sets the background color
	end for
	locate (4, 45) % Locates text position
	put "You crashed into a car!"..
	locate (8, 52) % Locates text position
	put "YOU LOSE!!!"..
	View.Update % Updates the screen
	Music.PlayFile ("ISP Lose Sound Effect.mp3") % Plays lose sound effect
    elsif redLight = true then
	Text.ColorBack (12) % Sets text background color
	title
	for i : 0 .. 900
	    drawline (i, 0, i, 480, 12) % Sets the background color
	end for
	locate (4, 44) % Locates text position
	put "You crossed on a red light!"..
	locate (8, 52) % Locates text position
	put "YOU LOSE!!!"..
	View.Update % Updates the screen
	Music.PlayFile ("ISP Lose Sound Effect.mp3") % Plays lose sound effect
    elsif offLane = true then
	Text.ColorBack (12) % Sets text background color
	title
	for i : 0 .. 900
	    drawline (i, 0, i, 480, 12) % Sets the background color
	end for
	locate (4, 37) % Locates text position
	put "You went off the right side of the road!"..
	locate (8, 52) % Locates text position
	put "YOU LOSE!!!"..
	View.Update % Updates the screen
	Music.PlayFile ("ISP Lose Sound Effect.mp3") % Plays lose sound effect
    elsif pedestrianCollision = true then
	Text.ColorBack (12) % Sets text background color
	title
	for i : 0 .. 900
	    drawline (i, 0, i, 480, 12) % Sets the background color
	end for
	locate (4, 42) % Locates text position
	put "You crashed into a pedestrian!"..
	locate (8, 52) % Locates text position
	put "YOU LOSE!!!"..
	View.Update % Updates the screen
	Music.PlayFile ("ISP Lose Sound Effect.mp3") % Plays lose sound effect
    elsif goalReached = true then
	Text.ColorBack (48) % Sets text background color
	title
	for i : 0 .. 900
	    drawline (i, 0, i, 480, 48) % Sets the background color
	end for
	locate (4, 45) % Locates text position
	put "You arrived home safely!"..
	locate (8, 53) % Locates text position
	put "YOU WIN!!!"..
	View.Update % Updates the screen
	Music.PlayFile ("ISP Win Sound Effect.mp3") % Plays win sound effect
    end if
    GUI.Show (menuButton) % Showa main menu button
    View.Update % Updates the screen
end endGame

% This is the main game display procedure
procedure display
    setscreen ("offscreenonly") % Waits for View.Update to update the screen
    var carControlUp : int := Pic.Rotate (carControl, 0, -1, -1) % Car picture up
    var carControlDown : int := Pic.Rotate (carControl, 180, -1, -1) % Car picture down
    var carControlRight : int := Pic.Rotate (carControl, 270, -1, -1) % Car picture right
    var carControlLeft : int := Pic.Rotate (carControl, 90, -1, -1) % Car picture left
    % Resets all the lose game variables to false
    carCollision := false
    pedestrianCollision := false
    redLight := false
    offLane := false
    goalReached := false % Resets the win game variable to false
    loop
	randint (randColor, 32, 55) % Randomizes obstacle cars color
	% Randomizes how far away from the edge of the screen the obstacle cars are
	cary1 := Rand.Int (502, 602)
	cary2 := Rand.Int (502, 602)
	carx1 := Rand.Int (-182, -32)
	carx2 := Rand.Int (-182, -32)
	carx3 := Rand.Int (903, 1083)
	carx4 := Rand.Int (903, 1083)
	% Randomizes whether the lights are green or red
	light1 := Rand.Int (0, 2)
	light2 := Rand.Int (0, 2)
	light3 := Rand.Int (0, 2)
	light4 := Rand.Int (0, 2)
	% Changes pedestrian coordinates to some point so that collision with pedestrian is not detected after pedestrian has crossed
	personx := 0
	persony := 0
	trafficLights % Initializes the color of the traffic lights
	whichPedestrian % Selects which pedestrian will appear on screen
	pedestrianCrossed := false % Each time the loop is repeated, it makes sure that the pedestrian has not crossed (resets value to false)
	loop
	    verticalCars
	    var chars : array char of boolean % Declares an array of boolean for each character
	    Input.KeyDown (chars) % Checks if user presses a key
	    if chars (chr (200)) then
		controly := controly + 1 % Moves user car up
		if controly >= 472 then
		    controly := 472 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controlx >= 263 and controlx <= 273) or (controlx >= 638 and controlx <= 648) or (controly >= 330 and controly <= 338) or (controly >= 96 and controly <= 104) or (controly >= 367 and controly <= 375) or (controly >= 133 and controly <= 141)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx, controly - 1, controlx + 28, controly + 27, 30) % Erase
		Pic.Draw (carControlUp, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (208)) then
		controly := controly - 1 % Moves car down
		if controly <= 0 then
		    controly := 0 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controlx >= 223 and controlx <= 233) or (controlx >= 598 and controlx <= 608) or (controly >= 330 and controly <= 338) or (controly >= 96 and controly <= 104) or (controly >= 367 and controly <= 375) or (controly >= 133 and controly <= 141)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx, controly + 1, controlx + 28, controly + 29, 30) % Erase
		Pic.Draw (carControlDown, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (205)) then
		controlx := controlx + 1 % Moves car right
		if controlx >= 872 then
		    controlx := 872 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controly >= 330 and controly <= 338) or (controly >= 96 and controly <= 104) or (controlx >= 263 and controlx <= 273) or (controlx >= 638 and controlx <= 648) or (controlx >= 223 and controlx <= 233) or (controlx >= 598 and controlx <= 608)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx - 1, controly, controlx + 27, controly + 28, 30) % Erase
		Pic.Draw (carControlRight, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (203)) then
		controlx := controlx - 1 % Moves car left
		if controlx <= 0 then
		    controlx := 0 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controly >= 367 and controly <= 375) or (controly >= 133 and controly <= 141) or (controlx >= 263 and controlx <= 273) or (controlx >= 638 and controlx <= 648) or (controlx >= 223 and controlx <= 233) or (controlx >= 598 and controlx <= 608)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx + 1, controly, controlx + 29, controly + 28, 30) % Erase
		Pic.Draw (carControlLeft, controlx, controly, picMerge) % User controlled car
	    end if
	    % Checks to see if user went on a red light
	    if controlx + 28 > 598 and controlx < 677 and controly + 28 > 330 and controly < 404 and lightColor1 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 223 and controlx < 302 and controly + 28 > 330 and controly < 404 and lightColor2 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 223 and controlx < 302 and controly + 28 > 96 and controly < 170 and lightColor3 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 598 and controlx < 677 and controly + 28 > 96 and controly < 170 and lightColor4 = 12 then
		redLight := true
		exit % Exits the loop
	    end if
	    % Checks to see if user collided with another vehicle
	    if controlx <= 258 and controlx + 28 >= 230 and controly <= cary1 + 28 and controly + 28 >= cary1 then
		carCollision := true
		exit % Exits the loop
	    elsif controlx <= 633 and controlx + 28 >= 605 and controly <= cary2 + 28 and controly + 28 >= cary2 then
		carCollision := true
		exit % Exits the loop
	    end if
	    % Checks to see if user wins the game
	    if controlx >= 712 and controlx <= 824 and controly >= 330 and controly <= 366 then
		goalReached := true
		exit % Exits the loop
	    end if
	    exit when cary1 <= -30 and cary2 <= -30 % Exits when the vertically moving cars go off the screen
	    View.Update % Updates the screen
	    delay (5) % Delays the animations
	end loop
	exit when carCollision = true or redLight = true or offLane = true or goalReached = true % Exits when the player either loses or wins
	% Randomizes whether the lights are green or red
	light1 := Rand.Int (0, 2)
	light2 := Rand.Int (0, 2)
	light3 := Rand.Int (0, 2)
	light4 := Rand.Int (0, 2)
	trafficLights % Changes the color of the traffic lights
	randint (randColor, 32, 55) % Randomizes obstacle car color
	loop
	    horizontalCars
	    var chars : array char of boolean % Declares an array of boolean for each character
	    Input.KeyDown (chars) % Checks if user presses a key
	    if chars (chr (200)) then
		controly := controly + 1 % Moves user car up
		if controly >= 472 then
		    controly := 472 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controlx >= 263 and controlx <= 273) or (controlx >= 638 and controlx <= 648) or (controly >= 330 and controly <= 338) or (controly >= 96 and controly <= 104) or (controly >= 367 and controly <= 375) or (controly >= 133 and controly <= 141)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx, controly - 1, controlx + 28, controly + 27, 30) % Erase
		Pic.Draw (carControlUp, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (208)) then
		controly := controly - 1 % Moves car down
		if controly <= 0 then
		    controly := 0 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controlx >= 223 and controlx <= 233) or (controlx >= 598 and controlx <= 608) or (controly >= 330 and controly <= 338) or (controly >= 96 and controly <= 104) or (controly >= 367 and controly <= 375) or (controly >= 133 and controly <= 141)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx, controly + 1, controlx + 28, controly + 29, 30) % Erase
		Pic.Draw (carControlDown, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (205)) then
		controlx := controlx + 1 % Moves car right
		if controlx >= 872 then
		    controlx := 872 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controly >= 330 and controly <= 338) or (controly >= 96 and controly <= 104) or (controlx >= 263 and controlx <= 273) or (controlx >= 638 and controlx <= 648) or (controlx >= 223 and controlx <= 233) or (controlx >= 598 and controlx <= 608)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx - 1, controly, controlx + 27, controly + 28, 30) % Erase
		Pic.Draw (carControlRight, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (203)) then
		controlx := controlx - 1 % Moves car left
		if controlx <= 0 then
		    controlx := 0 % Makes sure car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controly >= 367 and controly <= 375) or (controly >= 133 and controly <= 141) or (controlx >= 263 and controlx <= 273) or (controlx >= 638 and controlx <= 648) or (controlx >= 223 and controlx <= 233) or (controlx >= 598 and controlx <= 608)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx + 1, controly, controlx + 29, controly + 28, 30) % Erase
		Pic.Draw (carControlLeft, controlx, controly, picMerge) % User controlled car
	    end if
	    % Checks to see if user went on a red light
	    if controlx + 28 > 598 and controlx < 677 and controly + 28 > 330 and controly < 404 and lightColor1 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 223 and controlx < 302 and controly + 28 > 330 and controly < 404 and lightColor2 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 223 and controlx < 302 and controly + 28 > 96 and controly < 170 and lightColor3 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 598 and controlx < 677 and controly + 28 > 96 and controly < 170 and lightColor4 = 12 then
		redLight := true
		exit % Exits the loop
	    end if
	    % Checks to see if user collided with another vehicle
	    if controlx <= carx1 + 28 and controlx + 28 >= carx1 and controly <= 364 and controly + 28 >= 336 then
		carCollision := true
		exit % Exits the loop
	    elsif controlx <= carx2 + 28 and controlx + 28 >= carx2 and controly <= 130 and controly + 28 >= 102 then
		carCollision := true
		exit % Exits the loop
	    elsif controlx <= carx3 + 28 and controlx + 28 >= carx3 and controly <= 397 and controly + 28 >= 369 then
		carCollision := true
		exit % Exits the loop
	    elsif controlx <= carx4 + 28 and controlx + 28 >= carx4 and controly <= 163 and controly + 28 >= 135 then
		carCollision := true
		exit % Exits the loop
	    end if
	    % Checks to see if user wins the game
	    if controlx >= 712 and controlx <= 824 and controly >= 330 and controly <= 366 then
		goalReached := true
		exit % Exits the loop
	    end if
	    exit when carx1 >= 903 and carx2 >= 903 and carx3 <= -30 and carx4 <= -30 % Exits when the horizontally moving cars go off the screen
	    View.Update % Updates the screen
	    delay (5) % Delays the animations
	end loop
	exit when carCollision = true or redLight = true or offLane = true or goalReached = true % Exits when the player either loses or wins
	loop
	    pedestrianMovement
	    var chars : array char of boolean % Declares an array of boolean for each character
	    Input.KeyDown (chars) % Checks if user presses a key
	    if chars (chr (200)) then
		controly := controly + 3 % Moves car up
		if controly >= 472 then
		    controly := 472 % Makes sure that the car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controlx >= 263 and controlx <= 273) or (controlx >= 638 and controlx <= 648)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx, controly - 3, controlx + 28, controly + 25, 30) % Erase
		Pic.Draw (carControlUp, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (208)) then
		controly := controly - 3 % Moves car down
		if controly <= 0 then
		    controly := 0 % Makes sure that the car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controlx >= 223 and controlx <= 233) or (controlx >= 598 and controlx <= 608)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx, controly + 3, controlx + 28, controly + 31, 30) % Erase
		Pic.Draw (carControlDown, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (205)) then
		controlx := controlx + 3 % Moves car right
		if controlx >= 872 then
		    controlx := 872 % Makes sure that the car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controly >= 330 and controly <= 338) or (controly >= 96 and controly <= 104)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx - 3, controly, controlx + 25, controly + 28, 30) % Erase
		Pic.Draw (carControlRight, controlx, controly, picMerge) % User controlled car
	    elsif chars (chr (203)) then
		controlx := controlx - 3 % Moves car left
		if controlx <= 0 then
		    controlx := 0 % Makes sure that the car does not go off the screen
		end if
		% Makes sure user is on the right side of the road
		if not ((controly >= 367 and controly <= 375) or (controly >= 133 and controly <= 141)) then
		    offLane := true
		    exit % Exits the loop
		end if
		drawfillbox (controlx + 3, controly, controlx + 31, controly + 28, 30) % Erase
		Pic.Draw (carControlLeft, controlx, controly, picMerge) % User controlled car
	    end if
	    % Checks to see if user went on a red light
	    if controlx + 28 > 598 and controlx < 677 and controly + 28 > 330 and controly < 404 and lightColor1 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 223 and controlx < 302 and controly + 28 > 330 and controly < 404 and lightColor2 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 223 and controlx < 302 and controly + 28 > 96 and controly < 170 and lightColor3 = 12 then
		redLight := true
		exit % Exits the loop
	    elsif controlx + 28 > 598 and controlx < 677 and controly + 28 > 96 and controly < 170 and lightColor4 = 12 then
		redLight := true
		exit % Exits the loop
	    end if
	    % Checks to see if user collided with a pedestrian
	    if controlx <= personx + 3 and controlx + 28 >= personx - 3 and controly <= persony + 3 and controly + 28 >= persony - 3 then
		pedestrianCollision := true
		exit % Exits the loop
	    end if
	    % Checks to see if user wins the game
	    if controlx >= 712 and controlx <= 824 and controly >= 330 and controly <= 366 then
		goalReached := true
		exit % Exits the loop
	    end if
	    exit when pedestrianCrossed = true % Exits when the pedestrian has crossed
	    View.Update % Updates the screen
	    delay (15) % Delays the animations
	end loop
	drawfilloval (personx, persony, 5, 5, 30) % Erases the pedestrian
	exit when redLight = true or offLane = true or pedestrianCollision = true or goalReached = true % Exits when the user either loses or wins
	View.Update % Updates the screen
    end loop
    endGame
end display

% Declares the intitial position of the user car
procedure initPic
    % Sets user car initial coordinates
    controlx := 269
    controly := 5
    Pic.Draw (carControl, controlx, controly, picMerge) % Draws car picture
    display
end initPic

procedure background
    GUI.Hide (playGameButton) % Hides the play game button
    GUI.Hide (instructionsButton) % Hides the instructions button
    GUI.Hide (exitButton) % Hides the exit button
    for i : 0 .. 900
	drawline (i, 0, i, 500, 30) % Sets the background color
    end for
    % Draws the top and bottom row lawns and backyards
    for i : 0 .. 223
	drawline (i, 404, i, 500, 2)
	drawline (677 + i, 404, 677 + i, 500, 2)
	drawline (i, 170, i, 330, 2)
	drawline (677 + i, 170, 677 + i, 330, 2)
	drawline (i, 0, i, 96, 2)
	drawline (677 + i, 0, 677 + i, 96, 2)
    end for
    % Draws the middle row lawns and backyards
    for i : 0 .. 296
	drawline (302 + i, 404, 302 + i, 500, 2)
	drawline (302 + i, 170, 302 + i, 330, 2)
	drawline (302 + i, 0, 302 + i, 96, 2)
    end for
    % Lane markings
    drawline (0, 367, 223, 367, 14)
    drawline (310, 367, 598, 367, 14)
    drawline (677, 367, 900, 367, 14)
    drawline (0, 133, 223, 133, 14)
    drawline (302, 133, 590, 133, 14)
    drawline (677, 133, 900, 133, 14)
    drawline (262, 500, 262, 404, 14)
    drawline (262, 330, 262, 170, 14)
    drawline (262, 88, 262, 0, 14)
    drawline (637, 500, 637, 404, 14)
    drawline (637, 322, 637, 170, 14)
    drawline (637, 96, 637, 0, 14)
    % Draws the buildings of the corner lots
    for i : 0 .. 75
	drawline (i, 434, i, 500, 137)
	drawline (112 + i, 434, 112 + i, 500, 137)
	drawline (712 + i, 434, 712 + i, 500, 137)
	drawline (825 + i, 434, 825 + i, 500, 137)
	drawline (i, 0, i, 67, 137)
	drawline (112 + i, 0, 112 + i, 67, 137)
	drawline (712 + i, 0, 712 + i, 67, 137)
	drawline (825 + i, 0, 825 + i, 67, 137)
    end for
    % Draws the buildings of the middle column
    for i : 0 .. 94
	drawline (337 + i, 434, 337 + i, 500, 113)
	drawline (468 + i, 434, 468 + i, 500, 113)
	drawline (337 + i, 0, 337 + i, 67, 113)
	drawline (468 + i, 0, 468 + i, 67, 113)
	drawline (337 + i, 200, 337 + i, 300, 15)
	drawline (468 + i, 200, 468 + i, 300, 15)
    end for
    % Draws the buildings in the left and right lots of the middle row
    for i : 0 .. 112
	drawline (75 + i, 200, 75 + i, 300, 4)
	drawline (712 + i, 200, 712 + i, 300, 4)
	drawline (712 + i, 306, 712 + i, 328, 11) % Goal box
    end for
    for i : 0 .. 37
	drawline (i, 200, i, 300, 4)
	drawline (863 + i, 200, 863 + i, 300, 4)
    end for
    % Traffic Lights
    for i : 0 .. 21
	drawline (679 + i, 406, 679 + i, 427, 14)
	drawline (304 + i, 406, 304 + i, 427, 14)
	drawline (304 + i, 172, 304 + i, 193, 14)
	drawline (679 + i, 172, 679 + i, 193, 14)
    end for
    Text.ColorBack (11) % Sets the text background color
    locate (12, 95) % Locates text position
    put "GOAL" ..
    initPic % Draws the initial position of the user car
end background

% This procedure shows the instructions
procedure instructions
    GUI.Hide (playGameButton) % Hides the play game button
    GUI.Hide (instructionsButton) % Hides the instructions button
    GUI.Hide (exitButton) % Hides the exit button
    Text.ColorBack (43) % Sets text background color
    title
    for i : 0 .. 900
	drawline (i, 0, i, 480, 43) % Sets background color
    end for
    locate (3, 1) % Locates text position
    Text.ColorBack (43) % Sets text background color
    % Puts the instructions
    put "Using the arrow keys, drive your car from work to home without crashing into pedestrians or other cars."
    put "" % Skips line
    put "Your car is on the bottom left, and has yellow headlights."
    put "" % Skips line
    put "Remember: if a traffic light is red, do NOT cross!"
    put "" % Skips line
    put "Also, stay on the RIGHT side of the lane and do not go off it!"
    put "" % Skips line
    put "Good luck!!!"
    GUI.Show (menuButton) % Shows the main menu button
    View.Update % Updates the screen
end instructions

% This is the ending goodbye procedure
procedure goodbye
    GUI.Hide (playGameButton) % Hides the play game button
    GUI.Hide (instructionsButton) % Hides the instructions button
    GUI.Hide (exitButton) % Hides the exit button
    Text.ColorBack (60) % Sets text background color
    title
    for i : 0 .. 900
	drawline (i, 0, i, 480, 60) % Blanks out the screen        
    end for    
    locate (3, 48) % Locates text position
    put "Thanks for playing!" % Puts goodbye message
    locate (5, 47) % Locates text position
    put "Created by: Om Patel" % Puts author name
    View.Update % Updates the screen
    delay (2000) % Delays before exiting program
    Music.PlayFileStop % Stops the music
    Window.Close (mainWindow) % Closes the main window
end goodbye

% This is the main menu procedure
procedure mainMenu
    GUI.Hide (menuButton) % Hides the mainMenu button
    for i : 0 .. 900
	drawline (i, 0, i, 500, 11) % Sets the background color`
    end for
    Text.ColorBack (11) % Sets text background color
    title
    instructionsButton := GUI.CreateButton (405, 300, 0, "Instructions", instructions) % Creates and shows the instructions button
    playGameButton := GUI.CreateButton (407, 200, 0, "Play Game", background) % Creates and shows the play game button
    exitButton := GUI.CreateButton (422, 100, 0, "Exit", GUI.Quit) % Creates and shows the exit button
    View.Update % Updates the screen
end mainMenu

% This is the introduction animation and text
procedure introduction
    setscreen ("offscreenonly") % Waits for View.Update to update screen
    Text.ColorBack (14) % Sets text background color
    title
    for i : 0 .. 900
	drawline (i, 0, i, 480, 72) % Sets the background color
    end for
    % Draws the corners
    for i : 0 .. 150
	drawline (0, 350, 150 - i, 500, 36)
	drawline (0, 150, 150 - i, 0, 36)
	drawline (900, 150, 750 + i, 0, 36)
	drawline (900, 350, 750 + i, 500, 36)
    end for
    % Animates the border around the text
    for i : 0 .. 200
	drawfillbox (337, -33 + i, 563, i, 72) % Erase
	drawfillbox (337, -32 + i, 563, 1 + i, blue)
	drawfillbox (-65 + 2 * i, 201, -28 + 2 * i, 299, 72) % Erase
	drawfillbox (-63 + 2 * i, 201, -26 + 2 * i, 299, red)
	drawfillbox (928 - 2 * i, 201, 965 - 2 * i, 299, 72) % Erase
	drawfillbox (926 - 2 * i, 201, 963 - 2 * i, 299, red)
	View.Update % Updates screen
	delay (15) % Delays animation
    end for
    % Animates the arc on top
    for i : 0 .. 80
	drawarc (450, 299, 113, i, 0, 180, i) % Draws colorful design
	View.Update % Updates screen
	delay (15) % Delays animation
    end for
    % Text in middle of screen
    Text.ColorBack (75) % Sets text background color
    locate (15, 53) % Locates text position
    put "This is" ..
    locate (16, 52) % Locates text position
    put "a driving" ..
    locate (17, 54) % Locates text position
    put "game!" ..
    View.Update % Updates the screen
    menuButton := GUI.CreateButton (405, 100, 0, "Main Menu", mainMenu) % Creates and shows the mainMenu button
    View.Update % Updates the screen
end introduction

% Main Program
fork music % Allows music to play continuously in background
introduction
loop
    exit when GUI.ProcessEvent % Exits when user clicks exit button
end loop
goodbye
% End of main program
