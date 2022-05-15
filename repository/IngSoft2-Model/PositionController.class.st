Class {
	#name : #PositionController,
	#superclass : #Object,
	#instVars : [
		'positions',
		'winner'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
PositionController class >> assertCollectionOfShipsIsValid:aCollectionOfShips [

	(aCollectionOfShips size  > 1) ifFalse: [ 
		Error signal: 'Game must have more than one Ship']
	
]

{ #category : #'instance creation' }
PositionController class >> for:ships [
	self assertCollectionOfShipsIsValid:ships.
	^self new initializeWith:ships.
	
]

{ #category : #initialization }
PositionController >> initializeWith: ships [

	positions := ships collect: [ :ship | 
		             PositionOfAShip of: ship at: 1 and: 1 ].
	winner := 'No one'.
]

{ #category : #action }
PositionController >> moveBackwards: aShip to: aBox with: endPosition [

	| oldPosition shipNewBoxNumber shipNewLapNumber |
	oldPosition := positions detect: [ :each | each ownerShip = aShip ].
	shipNewBoxNumber := oldPosition boxNumber + aBox.
	shipNewLapNumber:= oldPosition lapNumber.
	(shipNewBoxNumber < 1 and: oldPosition lapNumber > 1) ifTrue: [ 
		shipNewBoxNumber := endPosition + shipNewBoxNumber.
		shipNewLapNumber := oldPosition lapNumber - 1 ].
	(shipNewBoxNumber < 1 and: oldPosition lapNumber = 1) ifTrue: [ 
		shipNewBoxNumber := 1 ].

	positions
		replaceAll: oldPosition
		with: (PositionOfAShip of: aShip at: shipNewBoxNumber and: shipNewLapNumber)
]

{ #category : #action }
PositionController >> moveBackwards: aShip to: aBox with: endPosition and:laps [

	| oldPosition shipNewBoxNumber shipNewLapNumber |
	oldPosition := positions detect: [ :each | each ownerShip = aShip ].
	shipNewBoxNumber := oldPosition boxNumber + aBox.
	shipNewLapNumber:= oldPosition lapNumber.
	(shipNewBoxNumber < 1 and: oldPosition lapNumber > 1) ifTrue: [ 
		shipNewBoxNumber := endPosition + shipNewBoxNumber.
		shipNewLapNumber := oldPosition lapNumber - 1 ].
	(shipNewBoxNumber < 1 and: oldPosition lapNumber = 1) ifTrue: [ 
		shipNewBoxNumber := 1 ].

	positions
		replaceAll: oldPosition
		with: (PositionOfAShip of: aShip at: shipNewBoxNumber and: shipNewLapNumber)
]

{ #category : #action }
PositionController >> moveForward: aShip to: aBox with: endPosition [

	| oldPosition shipNewBoxNumber shipNewLapNumber |
	oldPosition := positions detect: [ :each | each ownerShip = aShip  ].
	shipNewBoxNumber := oldPosition boxNumber + aBox.
	shipNewBoxNumber > endPosition
		ifTrue: [ 
			shipNewLapNumber := oldPosition lapNumber + 1.
			shipNewBoxNumber := shipNewBoxNumber - endPosition ]
		ifFalse: [ shipNewLapNumber := oldPosition lapNumber ].
	positions
		replaceAll: oldPosition
		with:
		(PositionOfAShip
			 of: aShip 
			 at: shipNewBoxNumber
			 and: shipNewLapNumber)
]

{ #category : #action }
PositionController >> moveForward: aShip to: aBox with: endPosition and: laps [

	| oldPosition shipNewBoxNumber shipNewLapNumber |
	oldPosition := positions detect: [ :each | each ownerShip = aShip ].
	shipNewBoxNumber := oldPosition boxNumber + aBox.
	(shipNewBoxNumber > endPosition and: oldPosition lapNumber = laps) 
		ifTrue: [ shipNewBoxNumber := endPosition. winner:= oldPosition ownerShip ].
	(shipNewBoxNumber > endPosition and: oldPosition lapNumber < laps)
		ifTrue: [ 
			shipNewLapNumber := oldPosition lapNumber + 1.
			shipNewBoxNumber := shipNewBoxNumber - endPosition]
		ifFalse: [ shipNewLapNumber := oldPosition lapNumber ].
	positions
		replaceAll: oldPosition
		with:
		(PositionOfAShip
			 of: aShip
			 at: shipNewBoxNumber
			 and: shipNewLapNumber)
]

{ #category : #accesing }
PositionController >> positionOf: aShip [
	^ positions detect: [ :each | each ownerShip = aShip ]
]

{ #category : #accesing }
PositionController >> positions [
	^ positions
]

{ #category : #accesing }
PositionController >> rankingOf: aShip [

	self sortPositionsByRanking.
	positions do: [ :positionOfAShip | 
		positionOfAShip ownerShip = aShip ifTrue: [ 
			^ positions indexOf: positionOfAShip ] ]
]

{ #category : #accesing }
PositionController >> sortPositionsByRanking [

	positions sort: [ :positionOfShip1 :positionOfShip2 | 
		 positionOfShip1 lapNumber > positionOfShip2 lapNumber  or: [ positionOfShip1 lapNumber = positionOfShip2 lapNumber and: positionOfShip1 boxNumber  > positionOfShip2 boxNumber ]  ]
]

{ #category : #accesing }
PositionController >> winner [
	^winner
]