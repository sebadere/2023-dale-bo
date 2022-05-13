Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'board',
		'diceCup',
		'finished',
		'winner',
		'positions',
		'turnSequenceController'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #asserting }
Game class >> assertCollectionOfShipsIsValid:aCollectionOfShips [

	(aCollectionOfShips size  > 1) ifFalse: [ 
		Error signal: 'Game must have more than one Ship']


]

{ #category : #'instance colors' }
Game class >> with: aCollectionOfShips a: aBoard and: aDiceCup [

	self assertCollectionOfShipsIsValid: aCollectionOfShips.
	^ self new initializeWith: aCollectionOfShips a: aBoard and: aDiceCup
]

{ #category : #accesing }
Game >> boxNumberOf: aShip [

	^( self positionOfShip:aShip) boxNumber. 
]

{ #category : #accessing }
Game >> hasFinished [

	^ finished
]

{ #category : #initializing }
Game >> initializeWith: aShips a: aBoard and: aDiceCup [

	positions := aShips collect: [ :ship | PositionOfAShip of: ship at: 1 and: 1].
	board := aBoard.
	diceCup := aDiceCup.
	turnSequenceController := TurnSequenceController with: aShips.
	finished := false
]

{ #category : #'instance creation' }
Game >> newPositionWith: oldPosition and: effect [

	| shipNewLapNumber shipNewBoxNumber |
	shipNewBoxNumber := oldPosition boxNumber + effect.
	shipNewLapNumber := oldPosition lapNumber.
	oldPosition lapNumber < board laps
		ifTrue: [ 
			shipNewBoxNumber > board lastPosition ifTrue: [ 
				shipNewLapNumber := oldPosition lapNumber + 1.
				shipNewBoxNumber := shipNewBoxNumber - board lastPosition ] ]
		ifFalse: [ 
			shipNewBoxNumber >= board lastPosition ifTrue: [ 
				shipNewBoxNumber := board lastPosition.
				finished := true.
				winner := turnSequenceController whoPlays ] ].
	^ PositionOfAShip
		  of: turnSequenceController whoPlays
		  at: shipNewBoxNumber
		  and: shipNewLapNumber
]

{ #category : #action }
Game >> playATurn [

	| shipNewBoxNumber oldPosition targetedShips effect |
	oldPosition := self positionOfShip: turnSequenceController whoPlays.
	shipNewBoxNumber := diceCup roll + oldPosition boxNumber.
	self newPositionWith: oldPosition and: 0.
	targetedShips := board
		                 effectAt: shipNewBoxNumber
		                 for: positions
		                 appliedBy: oldPosition.
	effect := board effectAt: shipNewBoxNumber.
	targetedShips do: [ :each | 
		positions
			replace: each
			with: (self newPositionWith: each and: effect) ].
	turnSequenceController changeTurn
]

{ #category : #action }
Game >> positionOfShip: aShip [

	^ positions detect: [ :each | each ownerShip = aShip ]
]

{ #category : #action }
Game >> rankingOf: aShip [

	self sortPositionsByRanking.
	positions do: [ :positionOfAShip | 
		positionOfAShip ownerShip = aShip ifTrue: [ 
			^ positions indexOf: positionOfAShip ] ]
]

{ #category : #action }
Game >> sortPositionsByRanking [

	positions sort: [ :positionOfShip1 :positionOfShip2 | 
		 positionOfShip1 lapNumber > positionOfShip2 lapNumber  or: [ positionOfShip1 lapNumber = positionOfShip2 lapNumber and: positionOfShip1 boxNumber  > positionOfShip2 boxNumber ]  ]
]

{ #category : #actions }
Game >> winner [

	^ winner
]