extends StaticBody2D
## tower.gd -- Common code for towers
##
## A collection of reusable functions and common variables for towers.
## Potentially can be used for other structures.
##
## This is **NOT** intended to be directly attached to objects. Other scripts 
## attached to a StaticBody2D node should extend this file instead 
## of the built-in StaticBody2D object.
@export var HEALTH : int = 5
@export var UPGRADES : int = 0
