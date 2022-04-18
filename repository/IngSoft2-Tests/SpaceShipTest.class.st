Class {
	#name : #SpaceShipTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
SpaceShipTest >> testSpaceShipIsCreatedWithPositionZero [

	
	| spaceship1 aBoard |
	aBoard:= Board with:10.
	spaceship1 := Ship withBoard:aBoard.
	self assert: (spaceship1 getPosition = 0).
	self deny:  (spaceship1 getPosition = 2).
]

{ #category : #tests }
SpaceShipTest >> testSpaceShipMovesThreePositions [

	
	| spaceship1 aBoard |
	aBoard:= Board with:10.
	spaceship1 := Ship withBoard:aBoard.
	spaceship1 changePositionTo:3.
	self assert: (spaceship1 getPosition == 3).
	self deny: (spaceship1 getPosition == 2).
]