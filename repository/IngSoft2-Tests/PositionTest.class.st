Class {
	#name : #PositionTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
PositionTest >> should: aBlock raise: anError withMessage: anErrorMessage [

	| tmp2 tmp3 |
	aBlock
		on: anError
		do: [ :error | 
			tmp2 := true.
			tmp3 := error messageText ].
	self
		assert: tmp2;
		assert: tmp3 equals: anErrorMessage
]

{ #category : #tests }
PositionTest >> testPositionHasAPositionBoxNumberGreaterThan0 [

	self
		should: [ PositionOfAShip of: 'Valen' at: -2 and: 0 ]
		raise: Error
		withMessage: 'Box number must be positive'
]

{ #category : #tests }
PositionTest >> testPositionHasAPositionLapNumberGreaterThan0 [

	self
		should: [ PositionOfAShip of: 'Valen' at: 2 and: -2 ]
		raise: Error
		withMessage: 'Lap number must be positive'
]

{ #category : #tests }
PositionTest >> testPositionHasAValidShipName [

	self
		should: [ PositionOfAShip of: 'V' at: 0 and: 0 ]
		raise: Error
		withMessage: 'Ship name must have a name longer than one character'
]