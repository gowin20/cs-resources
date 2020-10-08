import pygame, sys, random
from pygame.locals import *
#defining things
TILESIZE = 40
MAPWIDTH = 40
MAPHEIGHT = 20

BLACK = (0,0,0)
BROWN = (153, 76, 0)
GREEN = (0, 250, 0)
BLUE = (0, 0, 255)
WHITE = (255, 255, 255)



wormx = -200
wormy = random.randint(0, MAPHEIGHT)*TILESIZE

DIRT =13
GRASS =14

STONE =1
COAL =2
IRON = 3
WATER =4
OBSIDIAN =5
DIAMOND =6
BUCKET = 7
TROPHY = 8
BRICK = 9
COBBLE = 10
LAVA =11
WORM = 12

resources = [
		STONE, 
		COBBLE,
		BRICK,
		COAL, 
		IRON,
		WATER, 
		#LAVA, 
		DIAMOND, 
		OBSIDIAN,
		BUCKET,
		TROPHY
			]

textures = {
	DIRT:pygame.image.load('dirt.png'),
	GRASS:pygame.image.load('grass.png'),
	IRON:pygame.image.load('iron.png'),
	WATER:pygame.image.load('water.png'),
	COAL:pygame.image.load('coal.png'),
	STONE:pygame.image.load('stone.png'),
	LAVA:pygame.image.load('lava.png'),
	DIAMOND:pygame.image.load('diamond.png'),
	OBSIDIAN:pygame.image.load('obsidian.png'),
	WORM:pygame.image.load('worm1.png'),
	BUCKET:pygame.image.load('bucket.png'),
	TROPHY:pygame.image.load('trophy.png'),
	BRICK:pygame.image.load('brick.png'),
	COBBLE:pygame.image.load('cobble.png')
}

inventory = {
	STONE:0,
	COBBLE:0,
	BRICK:0,
	COAL:0,
	IRON:0,
	WATER:0,
#	LAVA:0,
	DIAMOND:0,
	OBSIDIAN:0,
	BUCKET:0,
	TROPHY:0
	
}

craft = {
	TROPHY : {DIAMOND : 5, IRON: 10, OBSIDIAN: 10, WATER:5},
	BRICK : {STONE:1, COAL:1},
	BUCKET : {IRON: 5, COAL: 10},
	COBBLE : {STONE:1}
}

controls = {
COBBLE : 49,
BRICK : 50,
BUCKET : 51,
TROPHY : 52
}



tilemap = [
	[DIRT for w in range(MAPWIDTH)] for h in range (MAPHEIGHT)
]

#program
pygame.init()
displayboy = pygame.display.set_mode((MAPWIDTH*TILESIZE,MAPHEIGHT*TILESIZE + 70))
pygame.display.set_caption('SHIT MINECRAFT')
pygame.display.set_icon(pygame.image.load('monster.png'))

PLAYER = pygame.image.load('monster.png').convert_alpha()
playerPos = [0,0]

INVFONT = pygame.font.Font('FreeSansBold.ttf', 18)



for rw in range(MAPHEIGHT):
	for cl in range (MAPWIDTH):
		randomNumber = random.randint(0,80)
		if randomNumber == 0:
			tile = DIAMOND
		if randomNumber >= 1 and randomNumber <= 6:
			tile = LAVA
		elif randomNumber >= 7 and randomNumber <= 14:
			tile = WATER
		elif randomNumber >= 15 and randomNumber <= 25:
			tile = COAL
		elif randomNumber >= 26 and randomNumber <= 35:
			tile = IRON
		elif randomNumber >= 36:
			tile = STONE
		tilemap[rw][cl] = tile	
selectedblock = 1

#core game loop
while True:

	displayboy.fill(BLACK)

#death condition
	if tilemap[playerPos[1]][playerPos[0]] == LAVA:
		pygame.quit()
		sys.exit()
	if abs(playerPos[0]*TILESIZE - (wormx + 1.5*TILESIZE)) <= 1 and (playerPos[1]*TILESIZE == wormy):
		print(playerPos[0], playerPos[1], wormx)

	#event loop
	for event in pygame.event.get():
		if event.type == QUIT:
			pygame.quit()
			sys.exit()
		elif event.type == KEYDOWN:
			#moving around
			if (event.key == K_w) and playerPos[1] > 0:
				playerPos[1] -= 1
			if (event.key == K_a) and playerPos[0] > 0:
				playerPos[0] -= 1
			if (event.key == K_s) and playerPos[1] < MAPHEIGHT - 1:
				playerPos[1] += 1
			if (event.key == K_d) and playerPos[0] < MAPWIDTH - 1:
				playerPos[0] += 1
			for key in controls:
				if (event.key == controls[key]):
					if key in craft:
						canBeMade = True
						for i in craft[key]:
							if craft[key][i] > inventory[i]:
								canBeMade = False
								break
						if canBeMade == True:
							for i in craft[key]:
								inventory[i] -= craft[key][i]
							inventory[key] += 1
							print(inventory[key])
				
		
		#Picking up and placing blocks, as well as scrolling through the selection stuff
		elif event.type == pygame.MOUSEBUTTONDOWN:
			#picking up blocks
			if event.button == 1:
				currentTile = tilemap[playerPos[1]][playerPos[0]]
				if (currentTile != STONE):
					if (currentTile != WATER) or (inventory[BUCKET] > 0):
						inventory[currentTile] += 1
						tilemap[playerPos[1]][playerPos[0]] = STONE
			
			#placing blocks
			if event.button == 3:
				currentTile = tilemap[playerPos[1]][playerPos[0]]
				#print(currentTile)
				if inventory[selectedblock] > 0:
					inventory[selectedblock] -= 1
					tilemap[playerPos[1]][playerPos[0]] = selectedblock
					inventory[currentTile] += 1
			
			if event.button == 4:
				if selectedblock < 10:
					selectedblock += 1
#					print(inventory[selectedblock])
				else:
					selectedblock = 1
					
			if event.button == 5:
				if selectedblock > 1:
					selectedblock -= 1
				else:
					selectedblock = 10
	
	
	
	
	
	
	
	
	
	#update the tiles
	for row in range(MAPHEIGHT):
		for column in range(MAPWIDTH):
		#check if any water is touching lava, and turn the lava to obsidian
			if (column + 1 < MAPWIDTH):
				if (tilemap[row][column] == LAVA) and (tilemap[row][column + 1] == WATER):
		#			print('coolio')
					tilemap[row][column] = OBSIDIAN
			if (column - 1 > 0):
				if (tilemap[row][column] == LAVA) and (tilemap[row][column - 1] == WATER):
			#		print('coolio')
					tilemap[row][column] = OBSIDIAN
			if (row - 1 > 0):
				if (tilemap[row][column] == LAVA) and (tilemap[row - 1][column] == WATER):
			#		print('coolio')
					tilemap[row][column] = OBSIDIAN
			if (row + 1 < MAPHEIGHT):
				if (tilemap[row][column] == LAVA) and (tilemap[row + 1][column] == WATER):
			#		print('coolio')
					tilemap[row][column] = OBSIDIAN
			
			displayboy.blit(textures[tilemap[row][column]], (column*TILESIZE,row*TILESIZE))	
	
	
	
	#MOVE THE WORMMMM
	displayboy.blit(textures[WORM].convert_alpha(),(wormx,wormy))
	wormx += 1
	if wormx > MAPWIDTH*TILESIZE:
		wormy = random.randint(0, MAPHEIGHT)*TILESIZE
		wormx = -200
	
	
	
	#update player
	displayboy.blit(PLAYER,(playerPos[0]*TILESIZE,playerPos[1]*TILESIZE))
	
	#check for death condition

	
	
	
	
	
	
	
	#update inventory
	placePosition = 10
	for item in resources:
		if (item != WATER) or (inventory[BUCKET] > 0):
			displayboy.blit(textures[item],(placePosition,MAPHEIGHT*TILESIZE+20))
			placePosition += 30
			textObj = INVFONT.render(str(inventory[item]), True, WHITE, BLACK)
			displayboy.blit(textObj,(placePosition+15,MAPHEIGHT*TILESIZE+20))
			placePosition += 50
	
	#update selected block UI
	displayboy.blit(textures[selectedblock], (MAPWIDTH*TILESIZE - 200, MAPHEIGHT*TILESIZE + 20))
	displayboy.blit((INVFONT.render(str('Current Block:'), True, WHITE, BLACK)),(MAPWIDTH*TILESIZE - 350,MAPHEIGHT*TILESIZE + 20))	
	
	
	
	#tick, AKA update the screen
	pygame.display.update()
	

	
	
	
	
	
	
	
	
	
	
	
	
	
