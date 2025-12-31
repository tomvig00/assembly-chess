dseg	segment ;Note: There is some old code in the form of comments. I feel bad deleting it.
	sqSize	=	60	; game square size
	yMin	=	0	; completely unecessery, but doesnt really make a diffrence, more readable perhaps?
	xMin	=	0	; completely unecessery, but doesnt really make a diffrence, more readable perhaps?
	yMin0	=	sqSize 
	game 	db 	12h, 13h, 14h, 15h, 16h, 14h, 13h, 12h
			db  11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h
			db  20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
			db  20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
			db  20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
			db  20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
			db 	01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h
			db	02h, 03h, 04h, 05h, 06h, 04h, 03h, 02h
	;gameEn	db 	?
	turn	db	0	;Game turn. 0 - white's turn, 1 - black's turn
	moves	db	28 dup(?)	;27 is the highest possible number of moves (queen in the middle of the board) + 1 for knowing end of the possible moves (=0ffh).
	a		db	8 dup(sqSize), 0ffh	;for drawing the board
	color	dw	0fh
	selctn	db	1
	oldX	dw	?
	oldY	dw	?
	miniSqr	db	sqSize, sqSize, 0ffh
	oldCords dw	?
	oldColor dw	?
	oldStrt	dw	?
	oldEnd	dw	?
	king0Loc dw ?
	king1Loc dw ?
	cast0	dw	0		;castling bools. 0 - can castle  1 - can't
	cast0l	dw	0
	cast0r	dw	0
	cast1	dw	0
	cast1l	dw	0
	cast1r	dw	0
	enPass	dw	0
	notAI	dw	0
	checkm8	dw	?
	sPiece	db ?
	BlackAI	db	1
	WhiteAI	db	0
	hType	dw	offset comp
	hType0	dw	offset player
	lType	dw	offset player
	lType0	dw	offset ailevel
	TypeNum	dw	?
	
	countr	dw	0
	
	AIlev   dw	4 ;AI level - number of recursivly doing aimax/min. Has to be 0 or more. 4 is best. probably.
	curMax	dw	0
	curMin	dw	0fffeh ;(curMin - curMax)/2 = 07fffh (mid value) (used in counting points)
	maxXY	dw	?
	maxXY0	dw	?
	minXY	dw	?
	minXY0	dw	?
	
	
	;Pieces, stored in RNE form
	
	pawn	db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  29,2,0,0,29,0ffh
			db  27,6,0,0,27,0ffh
			db  26,2,4,0,0,2,0,0,26,0ffh
			db  25,2,6,0,0,2,0,0,25,0ffh
			db  25,2,6,0,0,2,0,0,25,0ffh
			db  25,2,6,0,0,2,0,0,25,0ffh
			db  25,2,6,0,0,2,0,0,25,0ffh
			db  25,2,6,0,0,2,0,0,25,0ffh
			db  26,2,4,0,0,2,0,0,26,0ffh
			db  26,2,4,0,0,2,0,0,26,0ffh
			db  25,3,4,0,0,3,0,0,25,0ffh
			db  23,4,6,0,0,4,0,0,23,0ffh
			db  22,2,12,0,0,2,0,0,22,0ffh
			db  21,2,14,0,0,2,0,0,21,0ffh
			db  21,1,16,0,0,1,0,0,21,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  21,1,16,0,0,1,0,0,21,0ffh
			db  21,2,14,0,0,2,0,0,21,0ffh
			db  22,2,12,0,0,2,0,0,22,0ffh
			db  23,2,10,0,0,2,0,0,23,0ffh
			db  23,3,8,0,0,3,0,0,23,0ffh
			db  22,3,10,0,0,3,0,0,22,0ffh
			db  21,3,12,0,0,3,0,0,21,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  19,2,18,0,0,2,0,0,19,0ffh
			db  18,2,20,0,0,2,0,0,18,0ffh
			db  17,2,22,0,0,2,0,0,17,0ffh
			db  16,2,24,0,0,2,0,0,16,0ffh
			db  16,2,24,0,0,2,0,0,16,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  15,1,28,0,0,1,0,0,15,0ffh
			db  14,2,28,0,0,2,0,0,14,0ffh
			db  14,2,28,0,0,2,0,0,14,0ffh
			db  14,2,28,0,0,2,0,0,14,0ffh
			db  14,2,28,0,0,2,0,0,14,0ffh
			db  14,2,28,0,0,2,0,0,14,0ffh
			db  14,2,28,0,0,2,0,0,14,0ffh
			db  14,32,0,0,14,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh

	rook	db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  15,6,0,0,6,6,0,0,6,6,0,0,15,0ffh
			db  15,1,4,0,0,1,0,0,6,1,4,0,0,1,0,0,6,1,4,0,0,1,0,0,15,0ffh
			db  15,1,4,0,0,1,0,0,6,1,4,0,0,1,0,0,6,1,4,0,0,1,0,0,15,0ffh
			db  15,1,4,0,0,8,4,0,0,8,4,0,0,1,0,0,15,0ffh
			db  15,1,4,0,0,8,4,0,0,8,4,0,0,1,0,0,15,0ffh
			db  15,1,28,0,0,1,0,0,15,0ffh
			db  15,1,28,0,0,1,0,0,15,0ffh
			db  15,2,0,26,0,2,0,0,15,0ffh
			db  15,3,0,24,0,3,0,0,15,0ffh
			db  16,3,22,0,0,3,0,0,16,0ffh
			db  17,3,20,0,0,3,0,0,17,0ffh
			db  18,3,0,18,0,3,0,0,18,0ffh
			db  20,2,0,16,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  20,2,0,16,0,2,0,0,20,0ffh
			db  19,3,0,16,0,3,0,0,19,0ffh
			db  18,2,20,0,0,2,0,0,18,0ffh
			db  17,2,22,0,0,2,0,0,17,0ffh
			db  16,2,0,24,0,2,0,0,16,0ffh
			db  15,2,0,26,0,2,0,0,15,0ffh
			db  15,2,0,26,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  11,6,0,26,0,6,0,0,11,0ffh
			db  11,6,0,26,0,6,0,0,11,0ffh
			db  11,2,34,0,0,2,0,0,11,0ffh
			db  11,2,34,0,0,2,0,0,11,0ffh
			db  11,38,0,0,11,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			
	knight	db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  16,1,0,0,9,1,0,0,33,0ffh
			db  16,3,0,0,7,2,0,0,32,0ffh
			db  16,4,0,0,5,4,0,0,31,0ffh
			db  16,2,1,0,0,2,0,0,4,2,1,0,0,2,0,0,30,0ffh
			db  16,2,2,0,0,2,0,0,2,2,3,0,0,2,0,0,29,0ffh
			db  16,2,3,0,0,1,0,0,1,3,3,0,0,4,0,0,27,0ffh
			db  16,2,3,0,0,5,3,0,0,7,0,0,24,0ffh
			db  16,3,1,0,0,5,4,0,0,1,4,0,0,4,0,0,22,0ffh
			db  16,3,1,0,0,2,14,0,0,4,0,0,20,0ffh
			db  16,3,19,0,0,3,0,0,19,0ffh
			db  15,2,1,0,0,1,20,0,0,3,0,0,18,0ffh
			db  14,2,24,0,0,3,0,0,17,0ffh
			db  14,2,2,3,0,0,20,0,0,3,0,0,16,0ffh
			db  13,2,2,4,0,0,21,0,0,3,0,0,15,0ffh
			db  13,2,1,4,0,0,23,0,0,3,0,0,14,0ffh
			db  13,2,1,4,0,0,24,0,0,2,0,0,14,0ffh
			db  13,2,1,3,0,0,12,2,0,0,11,0,0,3,0,0,13,0ffh
			db  13,2,1,1,0,0,14,2,0,0,12,0,0,2,0,0,13,0ffh
			db  12,2,17,2,0,0,12,0,0,3,0,0,12,0ffh
			db  11,2,18,2,0,0,13,0,0,2,0,0,12,0ffh
			db  11,2,17,3,0,0,13,0,0,3,0,0,11,0ffh
			db  10,2,18,2,0,0,15,0,0,2,0,0,11,0ffh
			db  10,2,18,0,0,2,15,0,0,3,0,0,10,0ffh
			db  9,2,19,0,0,2,16,0,0,2,0,0,10,0ffh
			db  9,1,19,0,0,3,16,0,0,2,0,0,10,0ffh
			db  8,2,16,0,0,3,0,0,2,1,16,0,0,3,0,0,9,0ffh
			db  8,1,15,0,0,3,0,0,4,1,17,0,0,2,0,0,9,0ffh
			db  7,2,1,2,0,0,10,0,0,3,0,0,5,2,17,0,0,2,0,0,9,0ffh
			db  7,1,2,2,0,0,8,0,0,3,0,0,7,2,17,0,0,3,0,0,8,0ffh
			db  7,1,1,3,0,0,7,0,0,2,0,0,9,2,17,0,0,3,0,0,8,0ffh
			db  7,1,1,2,0,0,7,0,0,2,0,0,9,2,18,0,0,3,0,0,8,0ffh
			db  7,2,4,2,0,0,2,0,0,2,0,0,9,2,20,0,0,2,0,0,8,0ffh
			db  8,2,3,2,0,0,1,0,0,2,0,0,9,3,20,0,0,2,0,0,8,0ffh
			db  8,3,1,2,0,1,1,0,0,1,0,0,10,2,21,0,0,2,0,0,8,0ffh
			db  9,5,1,0,0,2,0,0,9,2,22,0,0,3,0,0,7,0ffh
			db  13,3,0,0,9,2,23,0,0,3,0,0,7,0ffh
			db  24,2,24,0,0,3,0,0,7,0ffh
			db  23,2,25,0,0,3,0,0,7,0ffh
			db  22,2,26,0,0,3,0,0,7,0ffh
			db  22,2,26,0,0,3,0,0,7,0ffh
			db  21,2,27,0,0,3,0,0,7,0ffh
			db  21,1,28,0,0,3,0,0,7,0ffh
			db  20,2,28,0,0,3,0,0,7,0ffh
			db  20,2,28,0,0,3,0,0,7,0ffh
			db  20,2,28,0,0,3,0,0,7,0ffh
			db  20,33,0,0,7,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			
	bishop	db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  28,4,0,0,28,0ffh
			db  27,2,2,0,0,2,0,0,27,0ffh
			db  27,1,4,0,0,1,0,0,27,0ffh
			db  27,1,4,0,0,1,0,0,27,0ffh
			db  27,2,2,0,0,2,0,0,27,0ffh
			db  28,4,0,0,28,0ffh
			db  28,4,0,0,28,0ffh
			db  27,2,2,0,0,2,0,0,27,0ffh
			db  25,3,4,0,0,3,0,0,25,0ffh
			db  24,3,6,0,0,3,0,0,24,0ffh
			db  23,2,10,0,0,2,0,0,23,0ffh
			db  21,3,12,0,0,3,0,0,21,0ffh
			db  20,3,14,0,0,3,0,0,20,0ffh
			db  19,2,8,2,0,0,8,0,0,2,0,0,19,0ffh
			db  18,2,9,2,0,0,9,0,0,2,0,0,18,0ffh
			db  18,2,9,2,0,0,9,0,0,2,0,0,18,0ffh
			db  18,1,10,2,0,0,10,0,0,1,0,0,18,0ffh
			db  18,1,6,10,0,0,6,0,0,1,0,0,18,0ffh
			db  18,1,6,10,0,0,6,0,0,1,0,0,18,0ffh
			db  18,1,10,2,0,0,10,0,0,1,0,0,18,0ffh
			db  18,1,10,2,0,0,10,0,0,1,0,0,18,0ffh
			db  18,2,9,2,0,0,9,0,0,2,0,0,18,0ffh
			db  18,2,9,2,0,0,9,0,0,2,0,0,18,0ffh
			db  19,2,18,0,0,2,0,0,19,0ffh
			db  19,2,18,0,0,2,0,0,19,0ffh
			db  20,2,16,0,0,2,0,0,20,0ffh
			db  21,2,3,8,0,0,3,0,0,2,0,0,21,0ffh
			db  22,1,0,14,0,1,0,0,22,0ffh
			db  22,1,0,3,0,0,8,3,0,1,0,0,22,0ffh
			db  22,1,14,0,0,1,0,0,22,0ffh
			db  21,2,14,0,0,2,0,0,21,0ffh
			db  21,2,14,0,0,2,0,0,21,0ffh
			db  21,2,0,14,0,2,0,0,21,0ffh
			db  20,2,0,16,0,2,0,0,20,0ffh
			db  20,3,14,0,0,3,0,0,20,0ffh
			db  21,3,12,0,0,3,0,0,21,0ffh
			db  22,16,0,0,22,0ffh
			db  26,8,0,0,26,0ffh
			db  26,2,1,0,0,2,1,0,0,2,0,0,26,0ffh
			db  24,3,2,0,0,2,2,0,0,3,0,0,24,0ffh
			db  8,18,2,0,0,4,2,0,0,18,0,0,8,0ffh
			db  7,17,4,0,0,4,4,0,0,17,0,0,7,0ffh
			db  7,2,18,0,0,2,0,0,2,2,18,0,0,2,0,0,7,0ffh
			db  8,1,16,0,0,3,0,0,4,3,16,0,0,1,0,0,8,0ffh
			db  8,19,0,0,6,19,0,0,8,0ffh
			db  8,3,0,0,38,3,0,0,8,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
	
	queen	db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  28,4,0,0,28,0ffh
			db  27,6,0,0,27,0ffh
			db  17,4,0,0,6,2,2,0,0,2,0,0,6,4,0,0,17,0ffh
			db  16,6,0,0,5,2,2,0,0,2,0,0,5,6,0,0,16,0ffh
			db  16,2,2,0,0,2,0,0,6,4,0,0,6,2,2,0,0,2,0,0,16,0ffh
			db  16,2,2,0,0,2,0,0,7,2,0,0,7,2,2,0,0,2,0,0,16,0ffh
			db  7,3,0,0,7,4,0,0,8,2,0,0,8,4,0,0,7,3,0,0,7,0ffh
			db  6,5,0,0,8,1,0,0,9,2,0,0,9,1,0,0,8,5,0,0,6,0ffh
			db  6,2,2,0,0,2,0,0,7,1,0,0,9,2,0,0,9,1,0,0,7,2,2,0,0,2,0,0,6,0ffh
			db  6,2,2,0,0,2,0,0,7,1,0,0,9,2,0,0,9,1,0,0,7,2,2,0,0,2,0,0,6,0ffh
			db  6,5,0,0,8,2,0,0,8,2,0,0,8,2,0,0,8,5,0,0,6,0ffh
			db  7,3,0,0,9,2,0,0,8,2,0,0,8,2,0,0,9,3,0,0,7,0ffh
			db  9,1,0,0,9,2,0,0,8,2,0,0,8,2,0,0,9,1,0,0,9,0ffh
			db  10,1,0,0,8,3,0,0,6,4,0,0,6,3,0,0,8,1,0,0,10,0ffh
			db  10,1,0,0,8,3,0,0,6,4,0,0,6,3,0,0,8,1,0,0,10,0ffh
			db  10,2,0,0,7,3,0,0,6,4,0,0,6,3,0,0,7,2,0,0,10,0ffh
			db  11,1,0,0,7,4,0,0,5,4,0,0,5,4,0,0,7,1,0,0,11,0ffh
			db  11,2,0,0,6,1,1,0,0,2,0,0,5,1,2,0,0,1,0,0,5,2,1,0,0,1,0,0,6,2,0,0,11,0ffh
			db  11,2,0,0,6,1,2,0,0,2,0,0,3,2,2,0,0,2,0,0,3,2,2,0,0,1,0,0,6,2,0,0,11,0ffh
			db  11,3,0,0,5,1,2,0,0,2,0,0,3,2,2,0,0,2,0,0,3,2,2,0,0,1,0,0,5,3,0,0,11,0ffh
			db  11,3,0,0,5,1,3,0,0,1,0,0,3,2,2,0,0,2,0,0,3,1,3,0,0,1,0,0,5,3,0,0,11,0ffh
			db  11,4,0,0,4,1,3,0,0,2,0,0,2,2,2,0,0,2,0,0,2,2,3,0,0,1,0,0,4,4,0,0,11,0ffh
			db  12,1,1,0,0,1,0,0,4,1,3,0,0,2,0,0,2,1,4,0,0,1,0,0,2,2,3,0,0,1,0,0,4,1,1,0,0,1,0,0,12,0ffh
			db  12,1,1,0,0,2,0,0,3,1,4,0,0,4,4,0,0,4,4,0,0,1,0,0,3,2,1,0,0,1,0,0,12,0ffh
			db  12,1,2,0,0,2,0,0,2,1,5,0,0,3,4,0,0,3,5,0,0,1,0,0,2,2,2,0,0,1,0,0,12,0ffh
			db  12,1,2,0,0,2,0,0,2,1,5,0,0,10,5,0,0,1,0,0,2,2,2,0,0,1,0,0,12,0ffh
			db  12,1,3,0,0,28,3,0,0,1,0,0,12,0ffh
			db  12,3,1,0,0,13,2,0,0,13,1,0,0,3,0,0,12,0ffh
			db  12,10,16,0,0,10,0,0,12,0ffh
			db  13,7,20,0,0,7,0,0,13,0ffh
			db  13,2,30,0,0,2,0,0,13,0ffh
			db  14,2,3,22,0,0,3,0,0,2,0,0,14,0ffh
			db  15,2,0,26,0,2,0,0,15,0ffh
			db  15,2,0,4,0,0,18,4,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  15,2,5,16,0,0,5,0,0,2,0,0,15,0ffh
			db  16,2,0,24,0,2,0,0,16,0ffh
			db  16,2,0,6,0,0,12,6,0,2,0,0,16,0ffh
			db  16,2,24,0,0,2,0,0,16,0ffh
			db  16,2,6,12,0,0,6,0,0,2,0,0,16,0ffh
			db  16,2,3,18,0,0,3,0,0,2,0,0,16,0ffh
			db  15,2,0,9,0,0,8,9,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  14,2,28,0,0,2,0,0,14,0ffh
			db  16,8,12,0,0,8,0,0,16,0ffh
			db  20,20,0,0,20,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh

	king	db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  29,2,0,0,29,0ffh
			db  29,2,0,0,29,0ffh
			db  29,2,0,0,29,0ffh
			db  26,8,0,0,26,0ffh
			db  29,2,0,0,29,0ffh
			db  29,2,0,0,29,0ffh
			db  29,2,0,0,29,0ffh
			db  29,2,0,0,29,0ffh
			db  29,2,0,0,29,0ffh
			db  29,2,0,0,29,0ffh
			db  27,6,0,0,27,0ffh
			db  26,1,0,6,0,1,0,0,26,0ffh
			db  25,1,0,1,0,0,6,1,0,1,0,0,25,0ffh
			db  25,1,0,1,0,0,6,1,0,1,0,0,25,0ffh
			db  13,8,0,0,4,1,0,1,0,0,6,1,0,1,0,0,4,8,0,0,13,0ffh
			db  11,2,0,8,0,2,0,0,2,1,0,1,0,0,6,1,0,1,0,0,2,2,0,8,0,2,0,0,11,0ffh
			db  10,1,0,2,0,0,8,2,0,1,0,0,1,1,0,1,0,0,6,1,0,1,0,0,1,1,0,2,0,0,8,2,0,1,0,0,10,0ffh
			db  9,1,0,1,0,0,12,1,0,2,0,1,0,0,6,1,0,2,0,1,0,0,12,1,0,1,0,0,9,0ffh
			db  8,1,0,1,0,0,14,1,0,2,0,1,0,0,4,1,0,2,0,1,0,0,14,1,0,1,0,0,8,0ffh
			db  8,1,0,1,0,0,15,1,0,1,0,1,0,0,4,1,0,1,0,1,0,0,15,1,0,1,0,0,8,0ffh
			db  8,1,0,1,0,0,16,1,0,1,0,1,0,0,2,1,0,1,0,1,0,0,16,1,0,1,0,0,8,0ffh
			db  8,1,0,1,0,0,16,1,0,1,0,1,0,0,2,1,0,1,0,1,0,0,16,1,0,1,0,0,8,0ffh
			db  8,1,0,1,0,0,17,1,0,1,0,2,0,1,0,1,0,0,17,1,0,1,0,0,8,0ffh
			db  8,1,0,1,0,0,18,1,0,2,0,1,0,0,18,1,0,1,0,0,8,0ffh
			db  8,1,0,1,0,0,18,1,0,2,0,1,0,0,18,1,0,1,0,0,8,0ffh
			db  8,1,0,1,0,0,18,1,0,2,0,1,0,0,18,1,0,1,0,0,8,0ffh
			db  9,1,0,1,0,0,17,1,0,2,0,1,0,0,17,1,0,1,0,0,9,0ffh
			db  10,1,0,1,0,0,17,2,0,0,17,1,0,1,0,0,10,0ffh
			db  10,1,0,1,0,0,17,2,0,0,17,1,0,1,0,0,10,0ffh
			db  11,1,0,2,0,0,15,2,0,0,15,2,0,1,0,0,11,0ffh
			db  12,2,0,1,0,0,5,20,0,0,5,1,0,2,0,0,12,0ffh
			db  14,1,0,30,0,1,0,0,14,0ffh
			db  15,2,0,4,0,0,18,4,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  15,2,26,0,0,2,0,0,15,0ffh
			db  16,2,4,16,0,0,4,0,0,2,0,0,16,0ffh
			db  16,2,0,24,0,2,0,0,16,0ffh
			db  16,2,0,5,0,0,14,5,0,2,0,0,16,0ffh
			db  16,2,24,0,0,2,0,0,16,0ffh
			db  16,2,6,12,0,0,6,0,0,2,0,0,16,0ffh
			db  16,1,1,24,0,0,1,0,0,1,0,0,16,0ffh
			db  15,2,0,8,0,0,10,8,0,2,0,0,15,0ffh
			db  15,4,22,0,0,4,0,0,15,0ffh
			db  14,5,22,0,0,5,0,0,14,0ffh
			db  16,8,12,0,0,8,0,0,16,0ffh
			db  20,20,0,0,20,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh
			db  60,0ffh

	kingEn	db	?
	
	comp	db  0,0,58,0ffh
			db  0,0,4,0,0,6,7,0,0,6,4,0,0,4,1,0,0,5,2,0,0,4,3,0,0,2,2,0,0,4,4,0ffh
			db  0,0,3,0,0,8,5,0,0,8,3,0,0,17,2,0,0,10,2,0ffh
			db  0,0,2,0,0,10,3,0,0,10,2,0,0,17,2,0,0,11,0ffh
			db  0,0,1,0,0,5,3,0,0,3,2,0,0,5,2,0,0,4,2,0,0,5,2,0,0,4,2,0,0,4,2,0,0,5,2,0,0,4,0ffh
			db  0,0,1,0,0,4,9,0,0,4,4,0,0,4,1,0,0,4,3,0,0,4,2,0,0,4,2,0,0,4,4,0,0,4,0ffh
			db  0,0,1,0,0,4,9,0,0,4,4,0,0,4,1,0,0,4,3,0,0,4,2,0,0,4,2,0,0,4,4,0,0,4,0ffh
			db  0,0,1,0,0,4,9,0,0,4,4,0,0,4,1,0,0,4,3,0,0,4,2,0,0,4,2,0,0,4,4,0,0,4,0ffh
			db  0,0,1,0,0,5,3,0,0,4,1,0,0,5,2,0,0,4,2,0,0,4,3,0,0,4,2,0,0,4,2,0,0,5,2,0,0,4,0ffh
			db  0,0,2,0,0,10,3,0,0,10,2,0,0,4,3,0,0,4,2,0,0,4,2,0,0,11,0ffh
			db  0,0,2,0,0,9,5,0,0,8,3,0,0,4,3,0,0,4,2,0,0,4,2,0,0,10,2,0ffh
			db  0,0,4,0,0,6,7,0,0,6,4,0,0,4,3,0,0,4,2,0,0,4,2,0,0,8,4,0ffh
			db  0,0,46,0,0,3,9,0ffh
			db  0,0,46,0,0,3,9,0ffh
	player	db  0,0,67,0ffh
			db  0,0,14,0,0,4,49,0ffh
			db  0,0,14,0,0,4,49,0ffh
			db  0,0,14,0,0,4,49,0ffh
			db  0,0,1,0,0,2,2,0,0,4,5,0,0,4,4,0,0,7,4,0,0,4,3,0,0,4,4,0,0,6,4,0,0,4,1,0,0,4,0ffh
			db  0,0,1,0,0,10,3,0,0,4,3,0,0,10,2,0,0,4,3,0,0,4,3,0,0,8,3,0,0,9,0ffh
			db  0,0,1,0,0,11,2,0,0,4,3,0,0,10,2,0,0,4,3,0,0,4,2,0,0,10,2,0,0,9,0ffh
			db  0,0,1,0,0,5,2,0,0,4,2,0,0,4,2,0,0,4,3,0,0,4,3,0,0,3,3,0,0,3,2,0,0,5,2,0,0,5,1,0,0,8,0ffh
			db  0,0,1,0,0,4,4,0,0,4,1,0,0,4,8,0,0,5,3,0,0,4,1,0,0,4,2,0,0,4,4,0,0,4,1,0,0,5,4,0ffh
			db  0,0,1,0,0,4,4,0,0,4,1,0,0,4,4,0,0,9,3,0,0,4,1,0,0,3,3,0,0,12,1,0,0,4,5,0ffh
			db  0,0,1,0,0,4,4,0,0,4,1,0,0,4,3,0,0,4,2,0,0,4,4,0,0,7,3,0,0,4,9,0,0,4,5,0ffh
			db  0,0,1,0,0,5,2,0,0,4,2,0,0,4,2,0,0,4,3,0,0,4,4,0,0,7,3,0,0,5,2,0,0,5,1,0,0,4,5,0ffh
			db  0,0,1,0,0,11,2,0,0,4,2,0,0,11,5,0,0,5,5,0,0,10,2,0,0,4,5,0ffh
			db  0,0,1,0,0,10,3,0,0,4,2,0,0,11,5,0,0,5,5,0,0,9,3,0,0,4,5,0ffh
			db  0,0,1,0,0,8,5,0,0,4,3,0,0,5,2,0,0,4,4,0,0,5,7,0,0,6,4,0,0,4,5,0ffh
			db  0,0,1,0,0,3,32,0,0,4,27,0ffh
			db  0,0,1,0,0,3,29,0,0,7,27,0ffh
			db  0,0,33,0,0,6,28,0ffh
			db  0,0,33,0,0,5,29,0ffh
	ailevel	db	?
	
dseg	ends

cseg	segment
assume	cs:cseg, ds:dseg
	draw	proc ;color18,color16,color14,color12,mem10,mem8,x6,y4				
			push bp
			mov bp, sp
			push ax bx cx dx si di
			mov bh, 0
			mov cx, ss:[bp + 6]
			mov dx, ss:[bp + 4]
			mov ah, 0ch
			mov si, ss:[bp + 10]
	incd:	mov al, ss:[bp + 18]
			xor di, di
	test1:	mov bl, ds:[si]
			cmp bl, 0ffh
			jz dwn
	col:	cmp bl, 0
			jz switch
			dec bl
			int 10h
			inc cx
			jmp col
	switch: inc si
			inc di
			cmp di, 1
			jz wfrt
			cmp di, 2
			jz wfrf
			cmp di, 3
			jz wfrc
			jmp incd
	wfrt:	mov al, ss:[bp + 16]
			jmp test1
	wfrf:	mov al, ss:[bp + 14]
			jmp test1
	wfrc:	mov al, ss:[bp + 12]
			jmp test1
	dwn:	mov cx, ss:[bp + 6]
			inc dx
			inc si
			cmp si, ss:[bp + 8]
			jnz incd
			pop di si dx cx bx ax bp
			ret 16
	draw	endp

	; drawb	proc ;Not relevent anymore, ignore
			; ret
	; drawb	endp
	
	frame	proc ;x8,y6,color4
			push bp
			mov bp, sp
			push ax bx cx dx si
			mov cx, ss:[bp + 8]
			mov dx, ss:[bp + 6]
			mov ax, ss:[bp + 4]
			cmp al, 10h
			jnz frameit
			add cx, 3 ;reads color (for deleting cursor)
			add dx, 3
			mov ah, 0dh
			int 10h
			sub dx, 3
			sub cx, 3
	frameit:mov si, dx ;the framing is that complicated because it draws two lines
			mov ah, 0ch
			mov bx, 0
	rightp:	int 10h ;upper line
			cmp dx, si
			jnz cnt1
			inc dx
			jmp rightp
	cnt1:	dec dx
			inc cx
			inc bl
			cmp bl, sqSize
			jnz rightp
			dec cx
			mov si, cx
			add dx, 2
			xor bl, bl
	downp:	int 10h ;right line
			cmp cx, si
			jnz cnt2
			dec cx
			jmp downp
	cnt2:	inc cx
			inc dx
			inc bl
			cmp bl, sqSize - 2
			jnz downp
			dec dx
			mov si, dx
			sub cx, 2
			xor bl, bl
	leftp:	int 10h ;down line
			cmp dx, si
			jnz cnt3
			dec dx
			jmp leftp
	cnt3:	inc dx
			dec cx
			inc bl
			cmp bl, sqSize - 2
			jnz leftp
			inc cx
			mov si, cx
			sub dx, 2
			xor bl, bl
	upp:	int 10h ;left line
			cmp cx, si
			jnz cnt4
			inc cx
			jmp upp
	cnt4:   dec cx
			dec dx
			inc bl
			cmp bl, sqSize - 4
			jnz upp
			pop si dx cx bx ax bp
			ret 6
	frame 	endp
	
	options	proc	;ruins: al cx dx di (si - locY bx - locX ah - color al - piece oldCords- loc)
			xor di, di
			;mov al, game[si + bx] ;old line
			cmp al, 1	;finds possible moves.	
			jnz nWpawn
			jmp wPawn
	nWpawn:	cmp al, 11h
			jnz nBpawn
			jmp bPawn
	nBpawn:	and al, 0fh
			cmp al, 2
			jnz noRook
			jmp rook0
	noRook:	cmp al, 3
			jnz noKnight
			jmp knight0
	noKnight:cmp al, 4
			jnz noBishop
			jmp bishop0
	noBishop:cmp al, 5
			jnz king0
			jmp queen0
	king0:	cmp si, 0			;king
			jz n1rank
			mov al, game[si + bx - 8]
			shr al, 4
			cmp al, ah
			jz nope
			sub si, 8			;up
			call coMove
			add si, 8
	nope:	cmp bx, 0
			jz n1rank2
			mov al, game[si + bx - 8 - 1]
			shr al, 4
			cmp al, ah
			jz nope0
			dec bx				;up-left	
			sub si, 8
			call coMove
			inc bx
			add si, 8
	nope0:	cmp bx, 7
			jz n1rank
	n1rank2:mov al, game[si + bx - 8 + 1]
			shr al, 4
			cmp al, ah
			jz n1rank
			inc bx				;up-right
			sub si, 8
			call coMove
			dec bx
			add si, 8
	n1rank: cmp si, 7*8			
			jz n2rank
			mov al, game[si + bx + 8]
			shr al, 4
			cmp al, ah
			jz nope1
			add si, 8			;down
			call coMove
			sub si, 8
	nope1:	cmp bx, 0
			jz n2rank2
			mov al, game[si + bx + 8 - 1]
			shr al, 4
			cmp al, ah
			jz nope2
			dec bx				;down-left
			add si, 8
			call coMove
			inc bx
			sub si, 8
	nope2:	cmp bx, 7
			jz n2rank
	n2rank2:mov al, game[si + bx + 8 + 1]
			shr al, 4
			cmp al, ah
			jz n2rank
			inc bx				;down-right
			add si, 8
			call coMove
			dec bx
			sub si, 8
	n2rank: cmp bx, 0			;left
			jz	ncol
			mov al, game[si + bx - 1]
			shr al, 4
			cmp al, ah
			jz nope3
			dec bx
			call coMove
			inc bx
	nope3:	cmp bx, 7			;right
			jnz ncol
			jmp mEnd
	ncol:	mov al, game[si + bx + 1]
			shr al, 4
			cmp al, ah
			jz kcstl ;should be "qcstl"...
			inc bx				
			call coMove
			dec bx
    kcstl:	cmp notAI, 1 ; can be removed, but slows AI.
			jz noAI
			jmp mEnd
	noAI:	cmp ah, 0
			jz jjsd
			cmp cast1, 0
			jz jdfh
			jmp mEnd
	jdfh:	mov dx, si	;check ruins si and bx..
			add dx, bx
			call check
			mov si, dx
			and si, 0f8h	;1111 1000
			mov bx, dx
			and bx, 07		;0000 0111
			cmp ch, 1
			jnz ifjd
			jmp mEnd
	ifjd:	cmp cast1r, 0
			jnz qcstl
			jmp contg
	jjsd:	cmp cast0, 0
			jz odjd 
			jmp mEnd
	odjd:	mov dx, si
			add dx, bx
			call check
			mov si, dx
			and si, 0f8h	;1111 1000
			mov bx, dx
			and bx, 07		;0000 0111
			cmp ch, 1
			jnz fgry
			jmp mEnd
	fgry:	cmp cast0r, 0
			jnz qcstl
	contg:	cmp game[si + bx + 1], 20h
			jnz qcstl
			cmp game[si + bx + 2], 20h
			jnz qcstl
			inc bx
			call check
			mov si, dx ;dx = si + bx from before
			and si, 0f8h	;1111 1000
			mov bx, dx
			and bx, 07		;0000 0111
			cmp ch, 1
			jz qcstl
			add bx, 2
			call coMove
			sub bx, 2
			mov dx , si ;probably useless...
			add dx, bx
	qcstl:	cmp ah, 0
			jz ojsd
			cmp cast1l, 0
			jz conta
			jmp mEnd
	ojsd:	cmp cast0l, 0
			jnz mEnd
	conta:	cmp game[si + bx - 1], 20h
			jnz mEnd
			cmp game[si + bx - 2], 20h
			jnz mEnd
			cmp game[si + bx - 3], 20h
			jnz mEnd
			dec bx
			call check
			mov si, dx
			and si, 0f8h	;1111 1000
			mov bx, dx
			and bx, 07		;0000 0111
			cmp ch, 1
			jz mEnd
			sub bx, 2
			call coMove
			add bx, 2
			mov dx , si
			add dx, bx
	mEnd:	;mov di, countr ;old line
			;mov moves[di], 0ffh ;old line
			;jmp mvmnt ;old line
			ret																			;RET IS HERE
	wPawn:  sub si, 8
			cmp game[si + bx], 20h		;up
			jz gght
			add si, 8
			jmp notwo
	gght:	call coMove
			add si, 8 ;relates to sub 6 lines prior
			cmp si, 8*6					; 2up
			jnz notwo
			sub si, 8*2
			cmp game[si + bx], 20h
			jz ytwo
			add si, 8*2
			jmp notwo
	ytwo:	call coMove
			add si, 8*2
	notwo:	cmp bx, 0					;up - left
			jz lside1
			mov al, game[si + bx - 8 - 1]
			shr al, 4
			cmp al, 1
			jnz lside		;enpass check here
			sub si, 8
			dec bx
			call coMove
			add si, 8
			inc bx
	lside:	cmp bx, 7					;up - right
			jz wpass
	lside1:	mov al, game[si + bx - 8 + 1]
			shr al, 4
			cmp al, 1
			jnz wpass		;enpass check here
			sub si, 8
			inc bx
			call coMove
			add si, 8
			dec bx
			;ret ;jmp mEnd ;old lines
	wPass:	cmp enPass, 0
			jz mEnd
			cmp si, 8*3
			jnz mEnd
			add si, bx
			sub si, enPass
			cmp si, 1
			jz wPassL
			cmp si, 0ffffh ;basically minus 1 (weird obvious comments like that exist because at the time i wasnt aware of negative numbers in assembly)
			jz wPassR
			add si, enPass
			sub si, bx
			ret	
	wPassL: add si, enPass ;1 + enPass
			sub si, bx
			mov game[si + bx - 1], 20h
			sub si, 8
			dec bx
			call coMove
			add si, 8
			inc bx
			mov game[si + bx - 1], 11h
			ret
	wPassR: add si, enPass	;-1 + enpass
			sub si, bx
			mov game[si + bx + 1], 20h
			sub si, 8
			inc bx
			call coMove
			add si, 8
			dec bx
			mov game[si + bx + 1], 11h
			ret
	bPawn:  add si, 8
			cmp game[si + bx], 20h		;down
			jz gghd
			sub si, 8
			jmp notwo0
	gghd:	call coMove
			sub si, 8
			cmp si, 8					;2down
			jnz notwo0
			add si, 8*2
			cmp game[si + bx], 20h
			jz ytwo0
			sub si, 8*2
			jmp notwo0
	ytwo0:	call coMove
			sub si, 8*2
	notwo0:	cmp bx, 0					;down - left
			jz lside3
			mov al, game[si + bx + 8 - 1]
			shr al, 4
			cmp al, 0
			jnz lside2		;enpass check here
			add si, 8							
			dec bx
			call coMove
			sub si, 8
			inc bx
	lside2:	cmp bx, 7					;down - right
			jnz lside3
			jmp bPass ;jmp mEnd ;old line
	lside3:	mov al, game[si + bx + 8 + 1]
			shr al, 4
			cmp al, 0
			jz xxfg
			jmp bPass ;jmp mEnd ;old line ;enpass check here
	xxfg:	add si, 8
			inc bx
			call coMove
			sub si, 8
			dec bx
			;ret ;jmp mEnd ;old line
	bPass:	cmp enPass, 0
			jnz djfe
			jmp mEnd
	djfe:	cmp si, 8*4
			jz fjrs
			jmp mEnd
	fjrs:	add si, bx
			sub si, enPass
			cmp si, 1
			jz bPassL
			cmp si, 0ffffh ;basically minus 1
			jz bPassR
			add si, enPass
			sub si, bx
			ret
	bPassL: add si, enPass
			sub si, bx
			mov game[si + bx - 1], 20h
			add si, 8
			dec bx
			call coMove
			sub si, 8
			inc bx
			mov game[si + bx - 1], 01h
			ret
	bPassR: add si, enPass
			sub si, bx
			mov game[si + bx + 1], 20h
			add si, 8
			inc bx
			call coMove
			sub si, 8
			dec bx
			mov game[si + bx + 1], 01h
			ret
	rook0:	mov cx, bx							
	rRight:	cmp bx, 7 					;right
			jz rLeft
			inc bx
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz rLeft
			call coMove
			cmp al, 2
			jz rRight
	rLeft:	mov bx, cx
	rLeft0:	sub bx, 1					;left
			jc rUp
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz rUp
			call coMove
			cmp al, 2
			jz rLeft0
	rUp:	mov bx, cx
	rUp1:	mov cx, si
	rUp0: 	sub si, 8					;up
			jc rDown
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz rDown
			call coMove
			cmp al, 2
			jz rUp0
	rDown:	mov si, cx
	rDown0: cmp si, 8*7					;down			
			jz rEnd
			add si, 8
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz rEnd
			call coMove
			cmp al, 2
			jz rDown0
	rEnd:	mov si, cx
	rEnd0:	ret ;jmp mEnd ;old line
	knight0:
			cmp bx, 0
			jnz ffgy
			jmp cut00
	ffgy:	cmp si, 0
			jz cut1
			cmp bx, 1
			jz cut2
			mov al, game[si + bx - 8 - 2]	;up - 2left
			shr al, 4
			cmp al, ah
			jz cut2
			sub si, 8
			sub bx, 2
			call coMove
			add si, 8
			add bx, 2
	cut2:	cmp si, 8
			jz cut1
			mov al, game[si + bx - 8*2 - 1]	;2up - left
			shr al, 4
			cmp al, ah
			jz cut10
			sub si, 8*2
			dec bx
			call coMove
			add si, 8*2
			inc bx
	cut10:	cmp si, 8*7
			jz cut0
	cut1:	cmp bx, 1
			jz cut3
			mov al, game[si + bx + 8 - 2]	;down - 2left
			shr al, 4
			cmp al, ah
			jz cut3
			add si, 8
			sub bx, 2
			call coMove
			sub si, 8
			add bx, 2
	cut3:   cmp si, 8*6
			jz cut0
			mov al, game[si + bx + 8*2 - 1]	;2down - left
			shr al, 4
			cmp al, ah
			jz cut0
			add si, 8*2
			dec bx
			call coMove
			sub si, 8*2
			inc bx
	cut0:	cmp bx, 7
			jnz cut00
			ret ;jmp mEnd
	cut00:	cmp si, 0
			jz cut4
			cmp bx, 6
			jz cut5
			mov al, game[si + bx - 8 + 2]	;up - 2right
			shr al, 4
			cmp al, ah
			jz cut5
			sub si, 8
			add bx, 2
			call coMove
			add si, 8
			sub bx, 2
	cut5:	cmp si, 8
			jz cut4
			mov al, game[si + bx - 8*2 + 1]	;2up - right
			shr al, 4
			cmp al, ah
			jz cut40
			sub si, 8*2
			inc bx
			call coMove
			add si, 8*2
			dec bx
	cut40:	cmp si, 8*7
			jz nEnd
	cut4:	cmp bx, 6
			jz cut6
			mov al, game[si + bx + 8 + 2]	;down - 2right
			shr al, 4
			cmp al, ah
			jz cut6
			add si, 8
			add bx, 2
			call coMove
			sub si, 8
			sub bx, 2
	cut6:   cmp si, 8*6
			jz nEnd
			mov al, game[si + bx + 8*2 + 1]	;2down - right
			shr al, 4
			cmp al, ah
			jz nEnd
			add si, 8*2
			inc bx
			call coMove
			sub si, 8*2
			dec bx		
	nEnd:	ret ;jmp mEnd
	bishop0:mov cx, si
			add cx, bx
	bRightd:cmp bx, 7						;right - down
			jz bLeftu
			cmp si, 8*7
			jz bLeftu
			inc bx
			add si, 8
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz bLeftu
			call coMove
			cmp al, 2
			jz bRightd
	bLeftu:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	bLeftu0:sub bx, 1					;left - up
			jc bUpr
			sub si, 8
			jc bUpr
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz bUpr
			call coMove
			cmp al, 2
			jz bLeftu0
	bUpr:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	bUpr0:	cmp bx, 7					;up - right
			jz bDownl
			sub si, 8
			jc bDownl
			inc bx
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz bDownl
			call coMove
			cmp al, 2
			jz bUpr0
	bDownl:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	bDownl0:sub bx, 1					;left - Down
			jc bEnd
			cmp si, 8*7
			jz bEnd
			add si, 8
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz bEnd
			call coMove
			cmp al, 2
			jz bDownl0
	bEnd:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	bEnd0:	ret ;jmp mEnd ;old line
	queen0:	mov cx, bx
	qRight:	cmp bx, 7						;right
			jz qLeft
			inc bx
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qLeft
			call coMove
			cmp al, 2
			jz qRight
	qLeft:	mov bx, cx
	qLeft0:	sub bx, 1					;left
			jc qUp
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qUp
			call coMove
			cmp al, 2
			jz qLeft0
	qUp:	mov bx, cx
	qUp1:	mov cx, si
	qUp0: 	sub si, 8					;up
			jc qDown
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qDown
			call coMove
			cmp al, 2
			jz qUp0
	qDown:	mov si, cx
	qDown0: cmp si, 8*7					;down
			jz qRightd
			add si, 8
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qRightd
			call coMove
			cmp al, 2
			jz qDown0
	qRightd:mov si, cx
	qRightd1:add cx, bx
	qRightd0:cmp bx, 7						;right - down
			jz qLeftu
			cmp si, 8*7
			jz qLeftu
			add si, 8
			inc bx
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qLeftu
			call coMove
			cmp al, 2
			jz qRightd0
	qLeftu:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	qLeftu0:sub bx, 1					;left - up
			jc qUpr
			sub si, 8
			jc qUpr
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qUpr
			call coMove
			cmp al, 2
			jz qLeftu0
	qUpr:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	qUpr0:	cmp bx, 7					;up - right
			jz qDownl
			sub si, 8
			jc qDownl
			inc bx
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qDownl
			call coMove
			cmp al, 2
			jz qUpr0
	qDownl:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	qDownl0:sub bx, 1					;left - Down
			jc qEnd
			cmp si, 8*7
			jz qEnd
			add si, 8
			mov al, game[si + bx]
			shr al, 4
			cmp al, ah
			jz qEnd
			call coMove
			cmp al, 2
			jz qDownl0
	qEnd:	mov si, cx
			and si, 0f8h	;1111 1000
			mov bx, cx
			and bx, 07		;0000 0111
	qEnd0:	ret ;jmp mEnd
			
	options endp		
	
	coMove 	proc			;there is already a function called cMove... stands for "confirm move"
							;Option: coMove recives nothing, original location is saved in memory, and si and bx are the new location - is it better (and\or faster)? Must consider this. done.
							;Option: make part of the coMove diffrent for king (send to a diff funct, and jmp here) - because of kingloc and all.. Did something similar
			;push bp		; deleted for efficiency... 
			;mov bp,sp		;old line
			push cx ; dx	;old line ; ruins dx
			mov cx, bx
			mov bx, oldCords
			mov dl, game[bx]
			mov game[bx], 20h
			mov bx, cx
			add cx, si
			mov dh, game[si + bx]
			mov game[si + bx], dl
			cmp dl, 6
			jz Kmoved
			cmp dl, 16h
			jz Kmoved
			cmp ah, 0
			jz iswturn
			mov bx, king1loc
			jmp foundK
	iswturn:mov	bx, king0loc
	foundK:	mov si, bx
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
	Kmoved:	call check
			mov bl, cl
			cmp ch, 1 ;if the move is legal, ch will be 0
			jz funcEnd
			mov moves[di], bl
			inc di				;apparently, you need to add 2 each jump in a dw array - no longer relevent
	funcEnd:
			mov game[bx], dh
			mov bx, oldCords
			mov game[bx], dl
			mov bl, cl
			mov si, bx
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			pop cx ;dx bp ;old line
			ret 
	coMove	endp
	
	check 	proc	;inst: si, bx - location, ah - color. result in ch(0 - no check, 1 - check);ruins: si, bx, ch
			push cx dx di
			mov cx, si
			add cx, bx			
			mov ch, ah
			xor ch, 1 ;key
			shl ch, 4
			; knight checks
			add ch, 3
			cmp bx, 0
			jnz ffgy2
			jmp cut002
	ffgy2:	cmp si, 0
			jz cut12
			cmp bx, 1
			jz cut22
			mov dl, game[si + bx - 8 - 2]	;up - 2left
			cmp dl, ch
			jnz cut22
			jmp isCheck
	cut22:	cmp si, 8
			jz cut12
			mov dl, game[si + bx - 8*2 - 1]	;2up - left
			cmp dl, ch
			jnz cut102
			jmp isCheck
	cut102:	cmp si, 8*7
			jz cut02
	cut12:	cmp bx, 1
			jz cut32
			mov dl, game[si + bx + 8 - 2]	;down - 2left
			cmp dl, ch
			jnz cut32
			jmp isCheck
	cut32:   cmp si, 8*6
			jz cut02
			mov dl, game[si + bx + 8*2 - 1]	;2down - left
			cmp dl, ch
			jnz cut02
			jmp isCheck
	cut02:	cmp bx, 7
			jnz cut002
			jmp noNCheck
	cut002:	cmp si, 0
			jz cut42
			cmp bx, 6
			jz cut52
			mov dl, game[si + bx - 8 + 2]	;up - 2right
			cmp dl, ch
			jnz cut52
			jmp isCheck
	cut52:	cmp si, 8
			jz cut42
			mov dl, game[si + bx - 8*2 + 1]	;2up - right
			cmp dl, ch
			jnz cut402
			jmp isCheck
	cut402:	cmp si, 8*7
			jz noNCheck
	cut42:	cmp bx, 6
			jz cut62
			mov dl, game[si + bx + 8 + 2]	;down - 2right
			cmp dl, ch
			jnz cut62
			jmp isCheck
	cut62:   cmp si, 8*6
			jz noNCheck
			mov dl, game[si + bx + 8*2 + 1]	;2down - right
			cmp dl, ch
			jnz noNcheck
			jmp isCheck
	noNCheck:
			; rook/queen/king checks
			add ch, 2 ; 3 + 2 = 5 = queen
			mov cl, bl
	rqRight:inc bl						;right
			cmp bl, 8
			jz rqLeft
			mov dl, game[si + bx]
			cmp dl, 20h
			jz rqRight
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz rqLeft
			cmp dh, ch
			jz rqcheck
			and dh, 0fh ; 0000 1111
			cmp dh, 2
			jz rqcheck
			cmp dh, 6
			jnz rqLeft
			sub bl , cl
			cmp bl, 1
			jnz rqLeft
	rqcheck:jmp isCheck
	rqLeft:	mov bl, cl
	rqLeft0:sub bl, 1					;left
			jc rqUp
			mov dl, game[si + bx]
			cmp dl, 20h
			jz rqLeft0
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz rqUp
			cmp dh, ch
			jz rqcheck0
			and dh, 0fh ; 0000 1111
			cmp dh, 2
			jz rqcheck0
			cmp dh, 6
			jnz rqUp
			sub bl , cl
			cmp bl, 0ffh ; 0ffh - baisically minus 1
			jnz rqUp
	rqcheck0:jmp isCheck 
	rqUp:	mov bl, cl
			;mov bh, 0					;old line
			mov di, si
	rqUp0: 	sub si, 8					;up
			jc rqDown
			mov dl, game[si + bx]
			cmp dl, 20h
			jz rqUp0
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz rqDown
			cmp dh, ch
			jz rqcheck1
			and dh, 0fh ; 0000 1111
			cmp dh, 2
			jz rqcheck1
			cmp dh, 6
			jnz rqDown
			sub si , di
			cmp si, 0fff8h ; 0fff8h - baisically minus 8 
			jnz rqDown
	rqcheck1:jmp isCheck 
	rqDown:	mov si, di
	rqDown0:add si, 8					;down
			cmp si, 8*8
			jz nRQcheck
			mov dl, game[si + bx]
			cmp dl, 20h
			jz rqDown0
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz nRQcheck
			cmp dh, ch
			jz rqcheck2
			and dh, 0fh ; 0000 1111
			cmp dh, 2
			jz rqcheck2
			cmp dh, 6
			jnz nRQcheck
			sub si , di
			cmp si, 8 
			jnz nRQcheck
	rqcheck2:jmp isCheck 
	nRQcheck:mov si, di
			; bishop/queen/king/pawn checks
	bqRightd:cmp bl, 7						;right - down
			jz bqLeftu
			cmp si, 8*7
			jz bqLeftu
			inc bl
			add si, 8
			mov dl, game[si + bx]
			cmp dl, 20h
			jz bqRightd
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz bqLeftu
			cmp dh, ch
			jz bqCheck
			and dh, 0fh ;0000 1111
			cmp dh, 4
			jz bqCheck
			sub bl, cl
			cmp bl, 1
			jnz bqLeftu
			cmp dh, 6
			jz bqCheck
			cmp ah, 1		;color check (for pawn)
			jnz bqLeftu
			cmp dh, 1	
			jnz bqLeftu
	bqCheck:jmp isCheck
	bqLeftu:mov bl, cl
			mov si, di
	bqLeftu0:sub bl, 1					;left - up
			jc bqUpr
			sub si, 8
			jc bqUpr
			mov dl, game[si + bx]
			cmp dl, 20h
			jz bqLeftu0
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz bqUpr
			cmp dh, ch
			jz bqCheck0
			and dh, 0fh ;0000 1111
			cmp dh, 4
			jz bqCheck0
			sub bl, cl
			cmp bl, 0ffh ; 0ffh - baisically minus 1
			jnz bqUpr
			cmp dh, 6
			jz bqCheck0
			cmp ah, 0		;color check (for pawn check)
			jnz bqUpr
			cmp dh, 1	
			jnz bqUpr
	bqCheck0:jmp isCheck
	bqUpr:	mov bl, cl
			mov si, di
	bqUpr0:	cmp bl, 7					;up - right
			jz bqDownl
			sub si, 8
			jc bqDownl
			inc bl
			mov dl, game[si + bx]
			cmp dl, 20h
			jz bqUpr0
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz bqDownl
			cmp dh, ch
			jz bqCheck1
			and dh, 0fh ;0000 1111
			cmp dh, 4
			jz bqCheck1
			sub bl, cl
			cmp bl, 1
			jnz bqDownl
			cmp dh, 6
			jz bqCheck1
			cmp ah, 0		;color check (for pawn check)
			jnz bqDownl
			cmp dh, 1	
			jnz bqDownl
	bqCheck1:jmp isCheck
	bqDownl:mov bl, cl
			mov si, di
	bqDownl0:sub bl, 1					;left - Down
			jc noCheck
			cmp si, 8*7
			jz noCheck
			add si, 8
			mov dl, game[si + bx]
			cmp dl, 20h
			jz bqDownl0
			mov dh, dl
			shr dl, 4
			cmp dl, ah
			jz noCheck
			cmp dh, ch
			jz isCheck
			and dh, 0fh ;0000 1111
			cmp dh, 4
			jz isCheck
			sub bl, cl
			cmp bl, 0ffh ; 0ffh - baisically minus 1
			jnz noCheck
			cmp dh, 6
			jz isCheck
			cmp ah, 1		;color check (for pawn check)
			jnz noCheck
			cmp dh, 1	
			jz isCheck
	noCheck:
			pop di dx cx
			mov ch, 0 
			ret
	isCheck:
			pop di dx cx
			mov ch, 1 
			ret
	
	check 	endp
	
	k0loc 	proc
			push bx
			mov bx, 8*8
	keepl:	dec bx
			cmp game[bx], 6
			jnz keepl
			mov king0loc, bx
			pop bx
			ret
	k0loc 	endp
	
	k1loc 	proc
			push bx
			xor bx, bx
			cmp game[bx], 16h
			jz ghyh
	keepl1:	inc bx
			cmp game[bx], 16h
			jnz keepl1
	ghyh:	mov king1loc, bx
			pop bx
			ret	
	k1loc 	endp
	
	AImax0	proc		;aimax0 is nessecery for maximum efficiency
			mov curMax, 0
			jmp rStart ;key
	done:	mov cx, maxXY	
			mov dx, cx
			and dx, 0f8h	;1111 1000
			shr dx, 3 ;basically dx/8
			and cx, 07		;0000 0111 
			push cx
			call mult
			pop cx
			push dx
			call mult
			pop dx
			mov ah, 0dh
			int 10h
			xor ah, ah
			mov oldColor, ax
			mov oldX, cx
			mov oldY, dx
			mov bx, maxXY
			mov al, game[bx]
			call getPiece
			mov oldCords, bx ; = maxXY
			mov si, maxXY0
			mov cx, si
			mov dx, cx
			and dx, 0f8h	;1111 1000
			shr dx, 3 ;basically dx/8
			and cx, 07		;0000 0111 
			push cx
			call mult
			pop cx
			push dx
			call mult
			pop dx
			call makemov
			ret									;ret is here
	rStart:	mov di, 0ffffh
	brloop:	cmp di, 63
			jz done
			inc di
			mov al, game[di]
			shr al, 4
			cmp al, ah
			jnz brloop
			mov dh, game[di]
			push di dx
			mov oldCords, di
			mov si, di
			mov bx, di
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			mov al, dh
			call options
			pop dx
			cmp di, 0 ; again, di is the number of avalible moves
			jnz ktrh
			pop di
			jmp brloop
	ktrh:	add si, bx
			mov game[si], 20h
			mov bl, moves[di - 1]
			;cmp bl, 19h ;old line for debugging
			mov dl, game[bx]
			mov game[bx], dh
			cmp ah, 0 
			jz grfft
			cmp dh, 16h
			jnz dtggy
			mov king1Loc, bx
			jmp dtggh
	dtggy:	cmp dh, 11h
			jnz dtggh
			cmp bx, 8*7
			jc dtggh
			mov game[bx], 15h
			jmp dtggh
	grfft:	cmp dh, 06
			jnz dtggx
			mov king0Loc, bx
			jmp dtggh
	dtggx:	cmp dh, 1
			jnz dtggh
			cmp bx, 8
			jnc dtggh
			mov game[bx], 5
	dtggh:  cmp AIlev, 0
			jz docount
			push enPass oldCords si bx dx di
			mov enPass, 0; i am so sorry for this - disables enpass for AI
			dec AIlev
			xor ah, 1
			mov curMin, 0ffffh
			call AImin
			xor ah, 1
			inc AIlev
			pop di dx bx si oldCords enPass
			jmp krtty
	docount:call count
	krtty:  mov game[bx], dl
			mov game[si], dh
			cmp ah, 0
			jz grffl
			cmp dh, 16h
			jnz dtggl
			mov king1Loc, si
			jmp dtggl
	grffl:	cmp dh, 06
			jnz dtggl
			mov king0Loc, si
	dtggl:  cmp curMax, bp
			jnc ruey
			mov curMax, bp
			mov maxXY, si
			mov maxXY0, bx
	ruey:   dec di
			cmp di, 0
			jnz	mmoves
	zmoves:	pop di
			jmp brloop
	mmoves:	mov bx, si
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			mov al, dh
			push dx di
			call options
			pop di dx
			jmp ktrh
	AImax0	endp
	
	AImin	proc
			jmp rStart0
	done0:	mov bp, curMin
			cmp bp, 0ffffh ;determines whether its a checkmate or a stalemate
			jnz goret
			push cx 
			cmp ah, 1
			jz fyyg
			mov si, king0loc
			jmp ffdy
	fyyg:	mov si, king1loc
	ffdy:	mov bx, si
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			call check
			cmp ch, 1
			jz dfgt
			mov bp, 07fffh ;stalemate
			jmp kfut
	dfgt:	mov bp, 0fff0h ;checkmate
	kfut:	pop cx
	goret:	ret									;ret is here
	rStart0:mov di, 0ffffh
	brloop0:cmp di, 63
			jz done0
			inc di
			mov al, game[di]
			shr al, 4
			cmp al, ah
			jnz brloop0
			mov dh, game[di]
			push di dx
			mov oldCords, di
			mov si, di
			mov bx, di
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			mov al, dh
			call options
			pop dx
			cmp di, 0
			jnz ktrh0
			pop di
			jmp brloop0
	ktrh0:	add si, bx
			mov bl, moves[di - 1]
			cmp bl, 23
			jnz dytr
			inc di
			dec di
	dytr:	cmp bl, 1eh
			jnz dytr1
			cmp ailev, 2
			jnz dytr1
			inc di
			dec di
	dytr1:
			mov game[si], 20h
			mov dl, game[bx]
			mov game[bx], dh
			cmp ah, 0
			jz grfft0
			cmp dh, 16h
			jnz dtggy0
			mov king1Loc, bx
			jmp dtggh0
	dtggy0:	cmp dh, 11h
			jnz dtggh0
			cmp bx, 8*7
			jc dtggh0
			mov game[bx], 15h
			jmp dtggh0
	grfft0:	cmp dh, 06
			jnz dtggx0
			mov king0Loc, bx
			jmp dtggh0
	dtggx0:	cmp dh, 1
			jnz dtggh0
			cmp bx, 8
			jnc dtggh0
			mov game[bx], 5
	dtggh0: cmp AIlev, 0
			jz docount0
			push oldCords curMax si bx dx di
			dec AIlev
			xor ah, 1
			mov curMax, 1 ; 1 - so if theres a checkmate next move, itll will still pick a move ;no longer neccesary
			call AImax
			xor ah, 1
			inc AIlev
			pop di dx bx si curMax oldCords
			jmp krtty0
	docount0:xor ah, 1
			call count
			xor ah, 1
	krtty0:	mov game[bx], dl
			mov game[si], dh
			cmp ah, 0
			jz grffl0
			cmp dh, 16h
			jnz dtggl0
			mov king1Loc, si
			jmp dtggl0
	grffl0:	cmp dh, 06h
			jnz dtggl0
			mov king0Loc, si
	dtggl0: cmp bp, curMin
			jnc ruey0
			mov curMin, bp
			cmp curMax, bp
			jc ruey0
			pop di
			ret
	ruey0:  dec di
			cmp di, 0
			jnz	mmoves0
	zmoves0:pop di
			jmp brloop0
	mmoves0:mov bx, si
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			mov al, dh
			push dx di
			call options
			pop di dx
			jmp ktrh0
	AImin 	endp
	
	AImax	proc
			jmp rStart1
	done1:	mov bp, curMax
			cmp bp, 1 ;determines whether its a checkmate or a stalemate
			jnz goret1
			push cx 
			cmp ah, 1
			jz fyyg1
			mov si, king0loc
			jmp ffdy1
	fyyg1:	mov si, king1loc
	ffdy1:	mov bx, si
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			call check
			cmp ch, 1
			jz dfgt1
			mov bp, 07fffh ;stalemate
			jmp kfut1
	dfgt1:	mov bp, 10 ;checkmate
	kfut1:	pop cx
	goret1:	ret									;ret is here
	rStart1:mov di, 0ffffh
	brloop1:cmp di, 63
			jz done1
			inc di
			mov al, game[di]
			shr al, 4
			cmp al, ah
			jnz brloop1
			mov dh, game[di]
			push di dx
			mov oldCords, di
			mov si, di
			mov bx, di
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			mov al, dh
			call options
			pop dx
			cmp di, 0
			jnz ktrh1
			pop di
			jmp brloop1
	ktrh1:	add si, bx
			mov game[si], 20h
			mov bl, moves[di - 1]
			mov dl, game[bx]
			mov game[bx], dh
			cmp ah, 0
			jz grfft1
			cmp dh, 16h
			jnz dtggy1
			mov king1Loc, bx
			jmp dtggh1
	dtggy1:	cmp dh, 11h
			jnz dtggh1
			cmp bx, 8*7
			jc dtggh1
			mov game[bx], 15h
			jmp dtggh1
	grfft1:	cmp dh, 06
			jnz dtggx1
			mov king0Loc, bx
			jmp dtggh1
	dtggx1:	cmp dh, 1
			jnz dtggh1
			cmp bx, 8
			jnc dtggh1
			mov game[bx], 5
	dtggh1: cmp AIlev, 0
			jz docount1
			push oldCords curMin si bx dx di
			dec AIlev
			xor ah, 1
			mov curMin, 0ffffh
			call AImin
			xor ah, 1
			inc AIlev
			pop di dx bx si curMin oldCords
			jmp krtty1
	docount1:call count
	krtty1:	mov game[bx], dl
			mov game[si], dh
			cmp ah, 0
			jz grffl1
			cmp dh, 16h
			jnz dtggl1
			mov king1Loc, si
			jmp dtggl1
	grffl1:	cmp dh, 06
			jnz dtggl1
			mov king0Loc, si
	dtggl1: cmp curMax, bp
			jnc ruey1
			mov curMax, bp
			cmp bp, curMin
			jc ruey1
			pop di
			ret
	ruey1:  dec di
			cmp di, 0
			jnz	mmoves1
	zmoves1:pop di
			jmp brloop1
	mmoves1:mov bx, si
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			mov al, dh
			push dx di
			call options
			pop di dx
			jmp ktrh1
	AImax 	endp
	
	count	proc
			mov bp, 07fffh
			push di
			mov di, 8*8
	loop2:	sub di, 1
			jc countEnd
			mov al, game[di]
			mov cl, al		;are we sure al and cl are free to use? should be.
			shr al, 4
			cmp al, 2
			jz loop2
			and cl, 0fh
			cmp al, ah
			jz isbcolor
			cmp cl, 1
			jnz chrook
			dec bp
			jmp loop2
	chrook:	cmp cl, 2
			jnz chknight
			sub bp, 5
			jmp loop2
	chknight:cmp cl, 3
			jz chbishop
			cmp cl, 4
			jnz chqueen
	chbishop:sub bp, 3
			jmp loop2
	chqueen:cmp cl, 5
			jnz loop2
			sub bp, 9
			jmp loop2
	isbcolor:cmp cl, 1
			jnz chrook1
			inc bp
			jmp loop2
	chrook1:cmp cl, 2
			jnz chknight1
			add bp, 5
			jmp loop2
	chknight1:cmp cl, 3
			jz chbishop1
	        cmp cl, 4
			jnz chqueen1
	chbishop1:add bp, 3
			jmp loop2
	chqueen1:cmp cl, 5
			jnz loop2
			add bp, 9
			jmp loop2
	countEnd:
			pop di
			ret
	count	endp
	
	; count1	proc		;old code, could be used, not really necessary
			; mov bp, 07fffh
			; push di
			; mov di, 8*8
	; loop20:	sub di, 1
			; jc countEnd0
			; mov al, game[di]
			; mov cl, al		;are we sure al and cl are free to use?
			; shr al, 4
			; cmp al, 2
			; jz loop20
			; and cl, 0fh
			; cmp al, 1
			; jz isbcolor0
			; cmp cl, 1
			; jnz chrook0
			; inc bp
			; jmp loop20
	; chrook0:	cmp cl, 2
			; jnz chknight0
			; add bp, 5
			; jmp loop20
	; chknight0:cmp cl, 3
			; jz chbishop0
			; cmp cl, 4
			; jnz chqueen0
	; chbishop0:add bp, 3
			; jmp loop20
	; chqueen0:cmp cl, 5
			; jnz loop20
			; add bp, 9
			; jmp loop20
	; isbcolor0:cmp cl, 1
			; jnz chrook10
			; dec bp
			; jmp loop20
	; chrook10:cmp cl, 2
			; jnz chknight10
			; sub bp, 5
			; jmp loop20
	; chknight10:cmp cl, 3
			; jz chbishop10
	        ; cmp cl, 4
			; jnz chqueen10
	; chbishop10:sub bp, 3
			; jmp loop20
	; chqueen10:cmp cl, 5
			; jnz loop20
			; sub bp, 9
			; jmp loop20
	; countEnd0:
			; pop di
			; ret
	; count1	endp
	
	makemov proc	;si - new location	;problem: how to cancel castling if rook was eaten? fixed, checks corners.
			push oldColor oldColor oldColor oldColor oldStrt oldEnd oldX oldY	;remove 'old' piece - oldStrt & oldEnd because it really doesnt matter...
			call draw
			mov di, oldCords
			mov al, game[di]
			mov game[di], 20h
			cmp turn, 0
			jz itswhit
			jmp itsblck
	itswhit:cmp si, (0*8)
			jz dght
			cmp si, (0*8 + 7)
			jz jfkr
			jmp kdfr
	dght:	mov cast1l, 1
			jmp kdfr
	jfkr:	mov cast1r, 1
	kdfr:	cmp al, 1 ;wPawn
			jnz nwpawnq
			jmp wpawnq
	nwpawnq:cmp cast0, 0
			jnz rescue
			cmp al, 6 ;wKing
			jz wkcast
			cmp al, 2 ;wRook
			jnz rescue
			cmp di, (7*8+7)
			jnz fhhy
			mov cast0r, 1
			jmp nbpawnq
	fhhy:	cmp di, (7*8)
			jnz rescue
			mov cast0l, 1
			jmp nbpawnq
	rescue: jmp nbpawnq
	wkcast:	mov cast0, 1
			sub di, si
			cmp di, 2
			jz ycast0l
			jmp ncast0l
	ycast0l:mov game[7*8 + 3], 02h
			mov game[7*8], 20h
			push 2 2 2 2 offset rook offset knight 
			push (xMin) 
			push (yMin + sqSize*7)
			call draw
			push 0fh 0 0fh 0 offset rook offset knight 
			push (xMin + sqSize*3) 
			push (yMin + sqSize*7)
			call draw
			jmp nbpawnq
	ncast0l:cmp di, 0fffeh ; minus 2
			jz ycast0r
			jmp nbpawnq
	ycast0r:mov game[7*8 + 5], 02h
			mov game[7*8 + 7], 20h
			push 0fh 0fh 0fh 0fh offset rook offset knight 
			push (xMin + sqSize*7) 
			push (yMin + sqSize*7)
			call draw
			push 0fh 0 0fh 0 offset rook offset knight 
			push (xMin + sqSize*5) 
			push (yMin + sqSize*7)
			call draw
			jmp nbpawnq
	itsblck:cmp si, (7*8)
			jz dsht
			cmp si, (7*8 + 7)
			jz jskr
			jmp ksfr
	dsht:	mov cast0l, 1
			jmp ksfr
	jskr:	mov cast0r, 1
	ksfr:	cmp al, 11h ;bPawn
			jnz nbpawnq0
			jmp bpawnq
	nbpawnq0:cmp cast1, 0
			jnz rescue0
			cmp al, 16h ;bKing
			jz bkcast
			cmp al, 12h ;bRook
			jnz rescue0
			cmp di, (0*8+7)
			jnz fhhz
			mov cast1r, 1
			jmp nbpawnq
	fhhz:	cmp di, (0*8)
			jnz rescue0
			mov cast1l, 1
			jmp nbpawnq
	rescue0:jmp nbpawnq
	bkcast:	mov cast1, 1
			sub di, si
			cmp di, 2
			jz ycast1l
			jmp ncast1l
	ycast1l:mov game[0*8 + 3], 12h
			mov game[0*8], 20h
			push 0fh 0fh 0fh 0fh offset rook offset knight 
			push (xMin) 
			push (yMin)
			call draw
			push 2 0 0 0fh offset rook offset knight 
			push (xMin + sqSize*3) 
			push (yMin)
			call draw
			jmp nbpawnq
	ncast1l:cmp di, 0fffeh ; minus 2
			jz ycast1r
			jmp nbpawnq
	ycast1r:mov game[0*8 + 5], 12h
			mov game[0*8 + 7], 20h
			push 2 2 2 2 offset rook offset knight 
			push (xMin + sqSize*7) 
			push (yMin)
			call draw
			push 2 0 0 0fh offset rook offset knight 
			push (xMin + sqSize*5) 
			push (yMin)
			call draw
			jmp nbpawnq
	bpawnq:	sub di, si
			cmp di, 0fff7h ;minus 9
			jz dfrh1
			cmp di, 0fff9h ;minus 7
			jz dfrh1
			jmp dfra1
	dfrh1:	sub si, 8
			cmp enPass, si
			jz jdhe1
			add si, 8
			jmp dfra1
	jdhe1:	add si, 8
			mov game[si - 8], 20h
			push si bx cx dx
			sub si, 8
			jmp fjjd
	dfra1:	cmp di, 0fff0h 	;basically minus 16
			jnz sskd
			mov enPass, si
			jmp yEnPass
	sskd:	add di, si
			and di, 0f8h	;1111 1000 ;getting the line the piece is at - for queening purposes
			cmp di, 6*8
			jz fkdr
			jmp nbpawnq
	fkdr:	cmp notAI, 1
			jz dgtff
			mov al, 15h
			mov sPiece, 15h
			jmp gfgr
	dgtff:	push 0 0 0fh
			call promoting
			mov al, sPiece
			jmp gfgr
	wpawnq: sub di, si
			cmp di, 7
			jz dfrh
			cmp di, 9
			jz dfrh
			jmp dfra
	dfrh:	add si, 8
			cmp enPass, si
			jz jdhe
			sub si, 8
			jmp dfra
	jdhe:	sub si, 8
			mov game[si + 8], 20h
			push si bx cx dx
			add si, 8
	fjjd:	mov bx, si
			and si, 0f8h	;1111 1000
			and bx, 07		;0000 0111
			shr si, 3 ;/8
			add si, bx
			ror si, 1
			jnc gtty
			push 2 2 2 2
			jmp jfid
	gtty:	push 0fh 0fh 0fh 0fh
	jfid:	push oldStrt oldEnd
			rol si, 1
			sub si, bx
			push bx
			call mult
			pop cx
			push si
			call mult
			pop dx
			push cx dx
			call draw
			pop dx cx bx si
			jmp nbpawnq
	dfra:	cmp di, 16 	
			jnz sskd1
			mov enPass, si
			jmp yEnPass
	sskd1:	add di, si
			and di, 0f8h	;1111 1000 ;getting the line the piece is at - for queening purposes
			cmp di, 8
			jnz nbpawnq
			cmp notAI, 1
			jz dgtf
			mov al, 05h
			mov sPiece, 05h
			jmp gfgr
	dgtf:   push 0 0fh 0
			call promoting
			mov al, sPiece
	gfgr:	call getPiece
			mov al, sPiece
	nbpawnq:mov enPass, 0
	yEnPass:mov game[si], al
		    mov ah, 0dh
			add cx, 3			;..do not fall victim to the black frame 
			add dx, 3
			int 10h
			sub cx, 3
			sub dx, 3
			mov ah, 0			
			mov color, ax
			push color
			cmp turn, 0
			jz	wturn2
			push 0 0 0fh
			jmp ksng1
	wturn2:	push 0 0fh 0
	ksng1:	push oldStrt oldEnd cx dx	
			call draw
			xor turn, 1
			call k0loc		;get kings location, (not efficient) (and doesnt have to be!)
			call k1loc
			ret
	makemov endp
	
	mult	proc		;i tried to use mul once, froze the program without even reaching the line it was written at... wrote this instead
			push bp
			mov bp, sp
			push ax bx dx
			xor dx, dx
			mov ax, sqSize ; number 1
			mov bx, ss:[bp + 4] ; number 2
	loopp0:
			shr bx, 1
			jnc cond
			add dx, ax ; result is stored in dx
	cond:
			shl ax, 1
			cmp bx, 0
			jnz loopp0
			mov ss:[bp + 4], dx
			pop dx bx ax bp
			ret
	mult	endp
	
	getPiece proc	;ruins al..
			and al, 0fh
			cmp al, 1
			jnz npawn
			mov oldStrt, offset pawn			
			mov oldEnd, offset rook			
			ret
	npawn:	cmp al, 2
			jnz nrook
			mov oldStrt, offset rook			
			mov oldEnd, offset knight
			ret
	nrook:	cmp al, 3
			jnz nknight
			mov oldStrt, offset knight			
			mov oldEnd, offset bishop			
			ret
	nknight:cmp al, 4
			jnz nbishop
			mov oldStrt, offset bishop			
			mov oldEnd, offset queen			
			ret
	nbishop:cmp al, 5
			jnz nqueen
			mov oldStrt, offset queen			
			mov oldEnd, offset king			
			ret
	nqueen:	mov oldStrt, offset king			
			mov oldEnd, offset kingEn			
			ret
	getPiece endp
	
	checkmate proc
			push ax si bx cx dx di oldCords
			xor bx, bx
			xor si, si
			mov ah, turn
	findmvs:mov al, game[si + bx]
			mov cl, al
			shr cl, 4
			cmp cl, ah
			jnz grut
			mov oldCords, si
			add oldCords, bx
			call options
			cmp di, 0
			jnz nckm8
	grut:	cmp bx, 7
			jz frrt
			inc bx
			jmp findmvs
	frrt:	cmp si, 8*7
			jz yckm8
			add si, 8
			xor bx, bx
			jmp findmvs
	nckm8:	mov checkm8, 0
			pop oldCords di dx cx bx si ax
			ret
	yckm8:	mov checkm8, 1
			pop oldCords di dx cx bx si ax
			ret
	checkmate endp
	
	promoting proc
			push cx dx 10h ;deletes cursor
			call frame ;deletes cursor
			push bp
			mov bp, sp
			push ax cx dx color
			; mov cx, sqSize*8 + 40 ;old, stupid code
			; mov dx, yMin0
	; minilp:	push 0fh 2 0fh 2 offset miniSqr offset oldCords cx dx
			; call draw
			; inc dx
			; cmp dx, sqSize + yMin0
			; jnz minilp
	; minilp0:push 2 0fh 2 0fh offset miniSqr offset oldCords cx dx
			; call draw
			; inc dx
			; cmp dx, sqSize * 2 + yMin0
			; jnz minilp0
			push 2 ss:[bp + 8] ss:[bp + 6] ss:[bp + 4] offset queen offset king 
			push sqSize*8 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0
			call draw
			push 0fh ss:[bp + 8] ss:[bp + 6] ss:[bp + 4] offset rook offset knight 
			push sqSize*9 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0
			call draw
			push 0fh ss:[bp + 8] ss:[bp + 6] ss:[bp + 4] offset bishop offset queen 
			push sqSize*8 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0 + sqSize
			call draw
			push 2 ss:[bp + 8] ss:[bp + 6] ss:[bp + 4] offset knight offset bishop 
			push sqSize*9 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0 + sqSize
			call draw
			
			mov cx, sqSize*8 + 40 
			mov dx, yMin0
			mov sPiece, 0
			push cx dx 0
			call frame
			
			mov ah, 7
	mvmnt0:	int 21h				;movment
			cmp al, 'd'
			jz right0
			cmp al, 'a'
			jz left0
			cmp al, 's'
			jz down0
			cmp al, 'w'
			jz up0
			cmp al, ' '
			jnz fdgf0
			jmp selctd0
	fdgf0:	cmp al, 27
			jnz mvmnt0
			jmp endd
	right0:	cmp cx, (9*sqSize + 40)			
			jz mvmnt0
			inc sPiece
			push cx dx 10h
			add cx, sqSize
			jmp drawit0
	left0:	cmp cx, (8*sqSize + 40)			
			jz mvmnt0
			dec sPiece
			push cx dx 10h
			sub cx, sqSize
			jmp drawit0
	down0:	cmp dx, (yMin0 + sqSize)			
			jz mvmnt0
			add sPiece, 8
			push cx dx 10h
			add dx, sqSize
			jmp drawit0
	up0:	cmp dx, yMin0			
			jz mvmnt0
			sub sPiece, 8
			push cx dx 10h
			sub dx, sqSize
			jmp drawit0
	drawit0:call frame
			cmp color, 0fh
			jz	white0
			mov color, 0fh
			jmp cnt0
	white0:	mov color, 2
	cnt0:	push cx dx 0
			call frame
			jmp mvmnt0			;end of movment0
			
	selctd0:mov ah, turn
			cmp sPiece, 0
			jnz tRook
			mov sPiece, ah
			shl sPiece, 4
			add sPiece, 5
			jmp psend
	tRook:	cmp sPiece, 1
			jnz tKnight
			mov sPiece, ah
			shl sPiece, 4
			add sPiece, 2
			jmp psend
	tKnight:cmp sPiece, 9
			jnz tBishop
			mov sPiece, ah
			shl sPiece, 4
			add sPiece, 3
			jmp psend
	tBishop:mov sPiece, ah
			shl sPiece, 4
			add sPiece, 4
	psend:	
			push 0 0 0 0 offset queen offset king 
			push sqSize*8 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0
			call draw
			push 0 0 0 0 offset rook offset knight 
			push sqSize*9 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0
			call draw
			push 0 0 0 0 offset bishop offset queen 
			push sqSize*8 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0 + sqSize
			call draw
			push 0 0 0 0 offset knight offset bishop 
			push sqSize*9 + 40					;cant push in one line with "modified" constants. does weird stuff.
			push yMin0 + sqSize
			call draw
			
			pop color dx cx ax bp
			ret 6
	promoting endp
	
	plType	proc	;changes the type of player - AI/Player
			cmp selctn, 1
			jz ddtk
			push oldColor		;unmark selection
			cmp turn, 0
			jz	wturn10
			push 0 0 0fh
			jmp ksng0
	wturn10:push 0 0fh 0
	ksng0:	push oldStrt oldEnd oldX oldY	
			call draw	
			mov selctn, 1
	ddtk:	push cx dx 10h ;deletes cursor
			call frame ;deletes cursor
			push dx ax
			cmp dx, (4*sqSize + yMin)
			jae bottom
			;mov 
			push 0 0eh 0 0  hType  hType0
			push sqSize*8
			push 0
			call draw
			mov dx, 0
			jmp contis
	bottom:	push 0 0eh 0 0  lType  lType0
			push sqSize*8
			push 461
			call draw
			mov dx, 461
	contis:	;pop ;removed
			mov ah, 7
	mvmnt1:	int 21h				;movment
			; cmp al, 'd' ;removed
			; jz right1 ;removed
			cmp al, 'a'
			jz left1
			cmp al, 's'
			jnz dxfr
			jmp down1
	dxfr:	cmp al, 'w'
			jnz ghtu
			jmp up1
	ghtu:	cmp al, ' '
			jnz fdgf1
			jmp selctd1
	fdgf1:	cmp al, 27
			jnz mvmnt1
			jmp endd
	; right1:	cmp cx, (9*sqSize + 40)		;belongs to the original mvmnt, not needed here	
			; jz mvmnt1
			; inc sPiece
			; push cx dx 10h
			; add cx, sqSize
			; jmp drawit1
	left1:	push 0 0fh 0 0  hType  hType0
			push sqSize*8
			push 0
			call draw
			push 0 0fh 0 0  lType  lType0
			push sqSize*8
			push 461
			call draw
			pop ax dx
			ret							;ret is here
	down1:	cmp dx, (461)
			jnz gxtt
			jmp mvmnt1
	gxtt:	push 0 0fh 0 0  hType  hType0
			push sqSize*8
			push 0
			call draw
			push 0 0eh 0 0  lType  lType0
			push sqSize*8
			push 461
			call draw
			mov dx, 461
			jmp mvmnt1
	up1:	cmp dx, 0
			jnz fxth
			jmp mvmnt1
	fxth:	push 0 0fh 0 0  lType  lType0
			push sqSize*8
			push 461
			call draw
			push 0 0eh 0 0  hType  hType0
			push sqSize*8
			push 0
			call draw
			xor dx, dx
			jmp mvmnt1
	; drawit1:call frame ;belongs to the original mvmnt, not needed here	
			; cmp color, 0fh
			; jz	white1
			; mov color, 0fh
			; jmp cnt1
	; white1:	mov color, 2
	; cnt1:	push cx dx 0
			; call frame
			; jmp mvmnt1			;end of movment1
			
	selctd1:cmp dx, 0
			jz yUpper
			jmp nUpper
	yUpper:	push 0 0 0 0  hType  hType0
			push sqSize*8
			push 0
			call draw
			cmp hType, offset comp
			jnz nhcomp
			mov hType, offset player
			mov hType0, offset ailevel
			mov BlackAI, 0
			jmp xdrg
	nhcomp:	mov hType, offset comp
			mov hType0, offset player
			mov BlackAI, 1
	xdrg:	push 0 0eh 0 0  hType  hType0
			push sqSize*8
			push 0
			call draw
			jmp mvmnt1
	nUpper:	push 0 0 0 0  lType  lType0
			push sqSize*8
			push 461
			call draw
			cmp lType, offset comp
			jnz nlcomp
			mov lType, offset player
			mov lType0, offset ailevel
			mov WhiteAI, 0
			jmp xdrg0
	nlcomp:	mov lType, offset comp
			mov lType0, offset player
			mov WhiteAI, 1
	xdrg0:	push 0 0eh 0 0  lType  lType0
			push sqSize*8
			push 461
			call draw
			jmp mvmnt1
			;ret
	plType	endp
	
	antiloop proc
	dsde:	mov BlackAI, 0
			mov	WhiteAI, 0
			mov hType, offset player
			mov hType0, offset ailevel
			mov lType, offset player
			mov lType0, offset ailevel
			push 0 0fh 0 0  lType  lType0
			push sqSize*8
			push 461
			call draw
			push 0 0fh 0 0  hType  hType0
			push sqSize*8
			push 0
			call draw
			ret
	antiloop endp
	
	Begin:
			mov ax, dseg
			mov ds, ax
			;jmp nngame ;Planned on making a 'new game' option, figured itll just be time wasting and useless
	;newGame:mov turn, 0		
	;nngame:	
			mov si, 4	;counter
			mov ah, 0
			mov al, 12h
			int 10h
			mov cx, xMin	;drawing the board
			mov dx, yMin			
			mov ax, sqSize			
	llop:	push 0fh 2 0fh 2 offset a offset color cx dx		
			call draw
			inc dx
			dec ax
			jnz llop
			mov ax, sqSize			
	lop1:	push 2 0fh 2 0fh offset a offset color cx dx
			call draw
			inc dx
			dec ax
			jnz lop1
			mov ax, sqSize
			dec si
			jz ggft			;end of drawing the borad
			jmp llop
	ggft:
			push 0 0fh 0 0 offset comp offset player
			push sqSize*8
			push 0
			call draw
			push 0 0fh 0 0 offset player offset ailevel
			push sqSize*8
			push 461
			call draw
				;drawing pieces - Black
			push 0fh 0 0 0fh offset rook offset knight xMin yMin
			call draw
			push 2 0 0 0fh offset rook offset knight 
			push (xMin + sqSize * 7) 					;cant push in one line with "modified" constants. does weird stuff.
			push yMin
			call draw
			push 2 0 0 0fh offset knight offset bishop 
			push (xMin + sqSize) 
			push yMin
			call draw
			push 0fh 0 0 0fh offset knight offset bishop 
			push (xMin + sqSize * 6) 
			push yMin
			call draw
			push 0fh 0 0 0fh offset bishop offset queen 
			push (xMin + sqSize * 2) 
			push yMin
			call draw
			push 2 0 0 0fh offset bishop offset queen 
			push (xMin + sqSize * 5) 
			push yMin
			call draw
			push 2 0 0 0fh offset queen offset king 
			push (xMin + sqSize * 3) 
			push yMin
			call draw
			push 0fh 0 0 0fh offset king offset kingEn 
			push (xMin + sqSize * 4) 
			push yMin
			call draw
			mov di, xMin
	bpawns:	push 2 0 0 0fh offset pawn offset rook di
			push (yMin + sqSize)
			call draw
			add	di, sqSize
			push 0fh 0 0 0fh offset pawn offset rook di
			push (yMin + sqSize)
			call draw
			add	di, sqSize
			cmp di, sqSize * 8 + Xmin
			jz wPieces
			jmp bpawns
	wPieces:push 2 0 0fh 0 offset rook offset knight xMin
			push (yMin + sqSize*7)
			call draw
			push 0fh 0 0fh 0 offset rook offset knight 
			push (xMin + sqSize * 7) 
			push (yMin + sqSize*7)
			call draw
			push 0fh 0 0fh 0 offset knight offset bishop 
			push (xMin + sqSize) 
			push (yMin + sqSize*7)
			call draw
			push 2 0 0fh 0 offset knight offset bishop 
			push (xMin + sqSize * 6) 
			push (yMin + sqSize*7)
			call draw
			push 2 0 0fh 0 offset bishop offset queen 
			push (xMin + sqSize * 2) 
			push (yMin + sqSize*7)
			call draw
			push 0fh 0 0fh 0 offset bishop offset queen 
			push (xMin + sqSize * 5) 
			push (yMin + sqSize*7)
			call draw
			push 0fh 0 0fh 0 offset queen offset king 
			push (xMin + sqSize * 3) 
			push (yMin + sqSize*7)
			call draw
			push 2 0 0fh 0 offset king offset kingEn 
			push (xMin + sqSize * 4) 
			push (yMin + sqSize*7)
			call draw
			mov di, xMin
	wpawns:	push 0fh 0 0fh 0 offset pawn offset rook di
			push (yMin + sqSize * 6)
			call draw
			add	di, sqSize
			push 2 0 0fh 0 offset pawn offset rook di
			push (yMin + sqSize * 6)
			call draw
			add	di, sqSize
			cmp di, sqSize * 8 + Xmin
			jz nPieces
			jmp wpawns
						;end of drawing pieces
	nPieces:
			mov dx, (yMin + sqSize*7)	;setting the cursor to bottom right corner		
			mov cx, (xMin + sqSize*7)
			push cx dx 0
			call frame
			mov si, 8*7
			mov bx, 7
			
			call k0loc		;get kings location
			call k1loc
			
	whoturn:;push cx dx 0 ;redraws the cursor
			;call frame
			call checkmate
			cmp checkm8, 1
			jz wNotAI ; in order to prevent the ai "forcing" a move even though the game is finished
			;call antiloop ; old
			cmp WhiteAI, 1
			jnz allokay
			cmp BlackAI, 1
			jnz allokay
			;push cx dx 10h ;deletes cursor
			;call frame ;deletes cursor
			push ax
			mov ah, 0bh ;used to stop ai vs ai, if this doesnt exist, you cant exit 
			int 21h
			cmp al, 0ffh
			jnz allokay0
			mov ah, 7
			int 21h ; "uses" the key - meaning the key that was pressed to stop the ai, is not used as a move
			call antiloop ;only used one, made it a function to keep this place somewhat clean
	allokay0:pop ax
	allokay:cmp turn, 0
			jnz blTurn
			cmp WhiteAI, 0
			jz wNotAI
			;cmp checkm8, 1 ;moved to start
			;jz wNotAI
			
			push ax di bp si bx cx dx color ; put push curMax and curMin at AImax0! done
			mov ah, turn
			xor bp, bp
			call AImax0
			pop color dx cx bx si bp di ax
			jmp whoturn
	wNotAI:	push cx dx 0 ;redraws the cursor
			call frame
			mov ah, 7
			jmp mvmnt
	blTurn: cmp BlackAI, 0
			jz bNotAI
			;cmp checkm8, 1 ;moved to start
			;jz bNotAI
			push ax di bp si bx cx dx color ; put push curMax and curMin at AImax0! done
			mov ah, turn
			xor bp, bp
			call AImax0
			pop color dx cx bx si bp di ax
			jmp whoturn
	bNotAI:	push cx dx 0 ;redraws the cursor
			call frame
			mov ah, 7
			jmp mvmnt
			
			;mov ah, 7
	mvmnt:	int 21h				;movment
			cmp al, 'd'
			jz right
			cmp al, 'a'
			jz left
			cmp al, 's'
			jz down
			cmp al, 'w'
			jz up
			cmp al, ' '
			jnz fdgf
			jmp selctd
	fdgf:	cmp al, 27
			jnz mvmnt
			;jnz moreopt ;Build mode... cancelled
			jmp endd
	;moreopt:cmp al, 'b'
			;jnz mvmnt
			;call bulid
	right:	cmp cx, (7*sqSize)			
			;jz mvmnt ; this is a special case - choosing AI/Player
			jnz nPlType
			call PlType
			jmp whoturn
	nPlType:push cx dx 10h 
			add cx, sqSize
			inc bx			; all si changes = 'game' array control
			jmp drawit
	left:	cmp cx, xMin			
			jz mvmnt
			push cx dx 10h
			sub cx, sqSize
			dec bx
			jmp drawit
	down:	cmp dx, (7*sqSize + yMin)			
			jz mvmnt
			push cx dx 10h
			add dx, sqSize
			add si, 8
			jmp drawit
	up:		cmp dx, yMin			
			jz mvmnt
			push cx dx 10h
			sub dx, sqSize
			sub si, 8
			jmp drawit
	drawit:	call frame
			cmp color, 0fh
			jz	white
			mov color, 0fh
			jmp cnt
	white:	mov color, 2
	cnt:	push cx dx 0
			call frame
			jmp mvmnt			;end of movment
	
	selctd:	xor selctn, 1
			cmp selctn, 1
			jnz kfth
			jmp makemove
	kfth:	mov al, game[si + bx]
			cmp al, 0
			jnz wfff
	gmvmnt:	xor selctn, 1
			jmp mvmnt
	wfff:	shr al, 4
			cmp al, turn
			jnz gmvmnt
			mov oldX, cx
			mov oldY, dx
			mov di, color
			mov	oldColor, di
			cmp di, 2		;mark selection
			jz green
			push 0eh 
			jmp wwwf
	green:	push 0ah 
	wwwf:	cmp al, 0
			jz	wturn
			push 0 0 0fh
			jmp kkng
	wturn:	push 0 0fh 0
	kkng:	mov al, game[si + bx]
			call getPiece
			push oldStrt oldEnd cx dx
			call draw
			push cx dx 0
			call frame						
			;mov countr, 0 ;Gave up on a counter
			mov oldCords, si
			add oldCords, bx
			push cx dx ax
			mov ah, turn
			mov al, game[si + bx]
			mov notAI, 1
			call options
			mov notAI, 0
			pop ax dx cx
			push di;see 2939. Could potentioally cause STACK OVERFLOW. Consider moving to var
			jmp mvmnt
	makeMove:
			push oldColor		;unmark selection
			cmp turn, 0
			jz	wturn1
			push 0 0 0fh
			jmp ksng
	wturn1:	push 0 0fh 0
	ksng:	push oldStrt oldEnd oldX oldY	
			call draw			
			
			pop di ;2939
			push ax
			add si, bx
			xor ah, ah
	chMove:	sub di, 1
			jc noMove
			mov al, moves[di]
	vffg:   cmp ax, si
			jnz chMove
			;sub si, bx ;done later
			mov notAI, 1
			call makemov
			mov notAI, 0
			;mov oldCords, si ;whole section moved to whoturn
			;add oldCords, bx 
			; call checkmate
			; cmp checkm8, 1
			; jz noMove
	    	; push di bp si bx cx dx color ; put push curMax and curMin at AImax0! done?
			; mov ah, turn
			; xor bp, bp
			; call AImax0
			; pop color dx cx bx si bp di
			; add si, bx
	noMove:	sub si, bx
			pop ax
			; push cx dx 0 ;moved to whoturn
			; call frame
			;jmp mvmnt ;changed to whoturn
			jmp whoturn
	endd:		int 3
cseg	ends
end		begin

	