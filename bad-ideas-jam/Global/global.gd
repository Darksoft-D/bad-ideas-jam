extends Node

var gold_amount: int = 0
var last_used_item: InvItem
var shown_sell_container: VBoxContainer
var bring_items: Array[InvItem]
var used_items: Array[InvItem]
var owned_relics: Array[Relic]
var common_chance = 65
var uncommon_chance = 85
var rare_chance = 98

signal gold_changed
signal health_changed

var shop_relics = [
	preload("uid://clyb3jibfixti"),
	preload("uid://dgp7icdt4u65k"),
	preload("uid://btgthlgaijuhb"),
	preload("uid://cuqfhanhjg15k"),
	preload("uid://ce0pcvorx0e2o"),
	preload("uid://bbu87igdx5oiv")
]
